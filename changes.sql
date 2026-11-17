-- Berlin spelled three ways in customers.city
BEGIN;
UPDATE customers SET city = 'Berlin' WHERE lower(btrim(city)) IN ('berlin', 'berlín');
COMMIT;

-- Acme GmbH in customers twice (41 consolidated into 1)
BEGIN;
UPDATE instances SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE tickets SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE invoices SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE contacts SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE portal_hits SET customer_ref = 1 WHERE customer_ref = 41;
DELETE FROM customers WHERE customer_id = 41;
COMMIT;

-- Contacts listed twice under the same customer
BEGIN;
UPDATE portal_hits SET contact_ref = 733 WHERE contact_ref = 734;
UPDATE portal_hits SET contact_ref = 760 WHERE contact_ref = 759;
UPDATE portal_hits SET contact_ref = 714 WHERE contact_ref = 715;
UPDATE portal_hits SET contact_ref = 785 WHERE contact_ref = 786;
UPDATE portal_hits SET contact_ref = 766 WHERE contact_ref = 767;
DELETE FROM contacts WHERE contact_id IN (734, 759, 715, 786, 767);
COMMIT;

-- Test accounts in customers
BEGIN;
DELETE FROM usage_daily u USING instances i WHERE i.instance_id = u.instance_id AND i.customer_ref IN (42, 43);
DELETE FROM invoice_lines il USING invoices v WHERE v.invoice_id = il.invoice_id AND v.customer_ref IN (42, 43);
DELETE FROM ticket_notes n USING tickets t WHERE t.ticket_id = n.ticket_id AND t.customer_ref IN (42, 43);
DELETE FROM instances WHERE customer_ref IN (42, 43);
DELETE FROM invoices WHERE customer_ref IN (42, 43);
DELETE FROM tickets WHERE customer_ref IN (42, 43);
DELETE FROM contacts WHERE customer_ref IN (42, 43);
DELETE FROM portal_hits WHERE customer_ref IN (42, 43);
DELETE FROM customers WHERE customer_id IN (42, 43);
COMMIT;

-- Tickets pointing at a customer who doesn't exist
BEGIN;
DELETE FROM ticket_notes WHERE ticket_id IN (SELECT t.ticket_id FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
DELETE FROM tickets t WHERE NOT EXISTS (SELECT 1 FROM customers c WHERE c.customer_id = t.customer_ref);
COMMIT;

-- Tickets closed before they opened
BEGIN;
UPDATE tickets SET closed_at = opened_at + resolved_minutes * INTERVAL '1 minute' WHERE closed_at < opened_at AND resolved_minutes IS NOT NULL;
COMMIT;

-- Blank tickets.resolved_minutes
BEGIN;
UPDATE tickets SET resolved_minutes = round(EXTRACT(EPOCH FROM (closed_at - opened_at)) / 60) WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;
COMMIT;

-- tickets.customer_ref → customers.customer_id
BEGIN;
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_customer
  FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
COMMIT;

-- contacts.customer_ref → customers.customer_id
BEGIN;
ALTER TABLE contacts ADD CONSTRAINT fk_contacts_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
COMMIT;

-- ticket_notes.ticket_id → tickets.ticket_id
BEGIN;
ALTER TABLE ticket_notes ADD CONSTRAINT fk_ticket_notes_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id);
COMMIT;

-- portal_hits.customer_ref → customers.customer_id
BEGIN;
ALTER TABLE portal_hits ADD CONSTRAINT fk_portal_hits_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
COMMIT;

-- portal_hits.contact_ref → contacts.contact_id
BEGIN;
ALTER TABLE portal_hits ADD CONSTRAINT fk_portal_hits_contact FOREIGN KEY (contact_ref) REFERENCES contacts (contact_id);
COMMIT;

-- customers.company_name is unique
BEGIN;
ALTER TABLE customers ADD CONSTRAINT uq_customers_company_name UNIQUE (company_name);
COMMIT;

-- contacts (customer_ref, full_name) is unique
BEGIN;
ALTER TABLE contacts ADD CONSTRAINT uq_contacts_customer_name UNIQUE (customer_ref, full_name);
COMMIT;

-- tickets: closed_at on or after opened_at, or blank
BEGIN;
ALTER TABLE tickets ADD CONSTRAINT ck_ticket_order CHECK (closed_at IS NULL OR closed_at >= opened_at);
COMMIT;

-- customers.status is active or churned
BEGIN;
ALTER TABLE customers ADD CONSTRAINT ck_customer_status CHECK (status IN ('active', 'churned'));
COMMIT;
