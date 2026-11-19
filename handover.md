# CloudByte handover

The eleven tables of `cloudbyte`, one heading each, in the order `schema.sql` declares them: every column, what it holds, and the query that proved it. I hold half B, and map the three tables both halves share and my own four; the other half's four carry their heading and nothing else.

## staff

*12 rows.* `SELECT count(*) FROM staff;`

| column | what it holds | the query that proved it |
|---|---|---|
| `username` | a staff member's short lower-case first name, such as `alice`, `bob`, `carol` | `SELECT * FROM staff ORDER BY username LIMIT 5;` |
| `department` | one of three words: `Engineering` 4, `Marketing` 3, `Operations` 5 | `SELECT department, count(*) FROM staff GROUP BY department ORDER BY department;` |
| `started_on` | the day the person started, from `2020-02-03` to `2024-07-15` | `SELECT min(started_on), max(started_on), count(*) FROM staff;` |

## customers

*40 rows.* `SELECT count(*) FROM customers;`

| column | what it holds | the query that proved it |
|---|---|---|
| `customer_id` | the customer's number, from `1` to `40` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `company_name` | the customer company's name written out, such as `Acme GmbH`; the unique constraint `uq_customers_company_name` refuses an exact repeat | `SELECT * FROM customers ORDER BY customer_id LIMIT 3;` |
| `city` | the customer's city, 26 distinct cities; Berlin is now spelled one way, `Berlin` 7 | `SELECT city, count(*) FROM customers GROUP BY city ORDER BY city;` |
| `country` | a two-letter country code: `AT` 1, `CH` 1, `DE` 37, `SE` 1 | `SELECT country, count(*) FROM customers GROUP BY country ORDER BY country;` |
| `signed_on` | the day the customer signed, from `2023-01-17` to `2025-04-08` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `plan` | one of three plans: `basic` 14, `enterprise` 8, `standard` 18 | `SELECT plan, count(*) FROM customers GROUP BY plan ORDER BY plan;` |
| `status` | `active` 35 or `churned` 5; the check constraint `ck_customer_status` allows only these two values | `SELECT status, count(*) FROM customers GROUP BY status ORDER BY status;` |
| `contact_1_email` | the customer's first contact's email address, filled on 40 of the 40 customers | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_2_email` | a second contact's email address, filled on 29 of the 40 | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_3_email` | a third contact's email address, filled on 2 of the 40. A fourth contact has nowhere to go: no column holds one, and finding a customer by a contact's email means searching all three columns | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |

## pricing

*5 rows.* `SELECT count(*) FROM pricing;`

| column | what it holds | the query that proved it |
|---|---|---|
| `instance_type` | the five instance sizes: `cb.gpu`, `cb.large`, `cb.medium`, `cb.small`, `cb.xlarge` | `SELECT * FROM pricing ORDER BY instance_type;` |
| `rate_eur_hour` | the hourly rate in euros for that size, from `0.024` (`cb.small`) to `0.740` (`cb.gpu`) | `SELECT * FROM pricing ORDER BY instance_type;` |

## instances

*Half A's table: the other side maps it.*

## usage_daily

*Half A's table: the other side maps it.*

## invoices

*Half A's table: the other side maps it.*

## invoice_lines

*Half A's table: the other side maps it.*

## contacts

*82 rows.* `SELECT count(*) FROM contacts;`

| column | what it holds | the query that proved it |
|---|---|---|
| `contact_id` | the contact's number, from `701` to `787` | `SELECT min(contact_id), max(contact_id), min(customer_ref), max(customer_ref), count(*) FROM contacts;` |
| `customer_ref` | a customer number, from `1` to `40`; the foreign key `fk_contacts_customer` requires each to be a `customers.customer_id` | `SELECT min(contact_id), max(contact_id), min(customer_ref), max(customer_ref), count(*) FROM contacts;` |
| `full_name` | a person's first and last name, such as `Jörg Baumgart`; the unique constraint `uq_contacts_customer_name` refuses the same name twice under one customer | `SELECT * FROM contacts ORDER BY contact_id LIMIT 3;` |
| `email` | the person's email address, shaped `first.last@company.example`; 0 addresses have another shape, `SELECT count(*) AS other_shape FROM contacts WHERE email !~ '^[^@. ]+\.[^@. ]+@[^@. ]+\.example$';` | `SELECT * FROM contacts ORDER BY contact_id LIMIT 3;` |
| `role` | one of three roles: `admin` 28, `billing` 28, `technical` 26 | `SELECT role, count(*) FROM contacts GROUP BY role ORDER BY role;` |

## tickets

*915 rows.* `SELECT count(*) FROM tickets;`

| column | what it holds | the query that proved it |
|---|---|---|
| `ticket_id` | the ticket's number, from `3001` to `3915` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `customer_ref` | a customer number, from `1` to `40`; the foreign key `fk_tickets_customer` requires each to be a `customers.customer_id` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `category` | one of five words: `access` 181, `billing` 200, `network` 190, `performance` 160, `storage` 184 | `SELECT category, count(*) FROM tickets GROUP BY category ORDER BY category;` |
| `st_flag_2` | **Not proved:** a number from 1 to 4 that looks like how slow a ticket was to resolve. Per value, `resolved_minutes` runs: `1` 232 tickets, 20 to 239; `2` 223, 129 to 1440; `3` 245, 604 to 7157; `4` 215, 1496 to 20045. The ranges overlap, so no rule sets it | `SELECT st_flag_2, count(*), min(resolved_minutes), max(resolved_minutes) FROM tickets GROUP BY st_flag_2 ORDER BY st_flag_2;` |
| `opened_at` | when the ticket was opened, from `2024-01-02 11:14` to `2025-12-31 08:07` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `closed_at` | when the ticket was closed, from `2024-01-03 13:19` to `2025-12-29 07:25`, blank while the ticket is open; the check constraint `ck_ticket_order` keeps it on or after `opened_at` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `resolved_minutes` | minutes to resolve, from `20` to `20045`, filled on every closed ticket: 71 tickets are open and 0 closed tickets lack it, `SELECT count(*) FILTER (WHERE closed_at IS NULL) AS open, count(*) FILTER (WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL) AS closed_without_minutes FROM tickets;` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `assigned_to` | a staff username, 12 names from `alice` 82 to `leo` 73 | `SELECT assigned_to, count(*) FROM tickets GROUP BY assigned_to ORDER BY assigned_to;` |

## ticket_notes

*3208 rows.* `SELECT count(*) FROM ticket_notes;`

| column | what it holds | the query that proved it |
|---|---|---|
| `note_id` | the note's number, from `40001` to `43208` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `ticket_id` | a ticket number, from `3001` to `3915`; the foreign key `fk_ticket_notes_ticket` requires each to be a `tickets.ticket_id` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `author` | a staff username, the same 12 names as `tickets.assigned_to`, `alice` 235 to `leo` 259 | `SELECT author, count(*) FROM ticket_notes GROUP BY author ORDER BY author;` |
| `note_at` | when the note was written, from `2024-01-03 09:14` to `2026-01-02 13:22` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `body` | one of eight stock sentences, such as `Waiting on the customer.` 387 and `Escalated to engineering.` 366 | `SELECT body, count(*) FROM ticket_notes GROUP BY body ORDER BY body;` |

## portal_hits

*135877 rows.* `SELECT count(*) FROM portal_hits;`

| column | what it holds | the query that proved it |
|---|---|---|
| `hit_id` | the hit's number, from `1` to `135877` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `customer_ref` | a customer number, from `1` to `40`; the foreign key `fk_portal_hits_customer` requires each to be a `customers.customer_id` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `contact_ref` | a contact number, from `701` to `787`; the foreign key `fk_portal_hits_contact` requires each to be a `contacts.contact_id` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `hit_at` | when the page was requested, from `2024-01-01 06:02:53` to `2025-11-28 20:57:12` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `path` | one of ten portal pages, `/account` 13388 to `/support/new` 13515 | `SELECT path, count(*) FROM portal_hits GROUP BY path ORDER BY path;` |
| `status_code` | an HTTP status: `200` 122419, `404` 6636, `500` 6822 | `SELECT status_code, count(*) FROM portal_hits GROUP BY status_code ORDER BY status_code;` |
| `duration_ms` | how long the request took in milliseconds, from `12` to `2400` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |

`portal_hits` stopped being filled early: its last visit is at `2025-11-28 20:57:12`, while the support desk's last ticket was opened at `2025-12-31 08:07:00`, so the portal's visits from 29 November 2025 on are missing. Found with `SELECT max(hit_at) AS last_hit FROM portal_hits;` and `SELECT max(opened_at) AS last_ticket FROM tickets;`

## Relationships

*These counts were taken in Section 3, on the database as loaded, before any repair; the figures for the database now are in the table headings above and under `## Corrections`.*

| relationship | `INNER JOIN` rows | `LEFT JOIN` rows | the queries that proved it |
|---|---|---|---|
| `contacts.customer_ref` → `customers.customer_id` | 87 | 87 | `SELECT count(*) AS inner_join FROM contacts t JOIN customers c ON c.customer_id = t.customer_ref;` `SELECT count(*) AS left_join FROM contacts t LEFT JOIN customers c ON c.customer_id = t.customer_ref;` |
| `tickets.customer_ref` → `customers.customer_id` | 919 | 925 | `SELECT count(*) AS inner_join FROM tickets t JOIN customers c ON c.customer_id = t.customer_ref;` `SELECT count(*) AS left_join FROM tickets t LEFT JOIN customers c ON c.customer_id = t.customer_ref;` |
| `ticket_notes.ticket_id` → `tickets.ticket_id` | 3246 | 3246 | `SELECT count(*) AS inner_join FROM ticket_notes n JOIN tickets t ON t.ticket_id = n.ticket_id;` `SELECT count(*) AS left_join FROM ticket_notes n LEFT JOIN tickets t ON t.ticket_id = n.ticket_id;` |
| `portal_hits.customer_ref` → `customers.customer_id` | 135877 | 135877 | `SELECT count(*) AS inner_join FROM portal_hits h JOIN customers c ON c.customer_id = h.customer_ref;` `SELECT count(*) AS left_join FROM portal_hits h LEFT JOIN customers c ON c.customer_id = h.customer_ref;` |
| `portal_hits.contact_ref` → `contacts.contact_id` | 135877 | 135877 | `SELECT count(*) AS inner_join FROM portal_hits h JOIN contacts k ON k.contact_id = h.contact_ref;` `SELECT count(*) AS left_join FROM portal_hits h LEFT JOIN contacts k ON k.contact_id = h.contact_ref;` |

`tickets` has 925 rows (`SELECT count(*) AS tickets FROM tickets;`). Joined to `ticket_notes` on `ticket_id`, it returns 3246 rows, one for each note (`SELECT count(*) AS after_join FROM tickets t JOIN ticket_notes n ON n.ticket_id = t.ticket_id;`).

Declaring `tickets.customer_ref` → `customers.customer_id` as a foreign key is refused. The statement, as run:

```sql
ALTER TABLE tickets ADD CONSTRAINT fk_tickets_customer
  FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
```

The engine's message:

```text
ERROR:  insert or update on table "tickets" violates foreign key constraint "fk_tickets_customer"
DETAIL:  Key (customer_ref)=(44) is not present in table "customers".
```

Two tickets carry customer `44`: tickets `3920` and `3921` (`SELECT ticket_id, customer_ref FROM tickets WHERE customer_ref = 44 ORDER BY ticket_id;`).

In all, 6 tickets are orphans, and they point at 3 customer numbers that `customers` doesn't hold (`SELECT count(*) AS orphan_tickets, count(DISTINCT t.customer_ref) AS missing_customers FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL;`).

## Corrections

### Blank `tickets.resolved_minutes`

Some closed tickets have no value in `resolved_minutes`. The average of `resolved_minutes` over closed tickets is 3571.10 minutes, calculated from 751 of the 854 closed tickets: `SELECT count(*) AS closed, count(resolved_minutes) AS with_minutes, round(avg(resolved_minutes), 2) AS avg_minutes FROM tickets WHERE closed_at IS NOT NULL;`

The closed tickets the average left out: `SELECT count(*) AS left_out FROM tickets WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;`

*103 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The rule test, run after the orphan-tickets repair, which is why it covers 743 and not 751: on the 743 closed tickets with a duration (`SELECT count(*) AS tickets_to_test FROM tickets WHERE closed_at IS NOT NULL AND resolved_minutes IS NOT NULL;`), all 743 have `resolved_minutes` equal to the whole minutes from `opened_at` to `closed_at` (`SELECT count(*) AS tickets_that_agree FROM tickets WHERE resolved_minutes = round(EXTRACT(EPOCH FROM (closed_at - opened_at)) / 60);`).

The count just before the repair was 101, not 103 (`SELECT count(*) AS left_out FROM tickets WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;`). The orphan repair deleted six tickets, and two of them were closed with a blank duration. The test-account repair removed none: after it, 103 were still blank (850 closed, 747 with a duration).

```sql
BEGIN;
UPDATE tickets SET resolved_minutes = round(EXTRACT(EPOCH FROM (closed_at - opened_at)) / 60) WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;
COMMIT;
```

Tag: `UPDATE 101`. The check, `SELECT ticket_id FROM tickets WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;`, returned 0 rows. Ticket 3003, opened 11:49 and closed 15:45, now reads 236 minutes, as worked out by hand.

The repair moved the figure up, from 3573.76 over 743 of 844 closed tickets to 3651.98 over all 844: `SELECT count(*) AS closed, count(resolved_minutes) AS with_minutes, round(avg(resolved_minutes), 2) AS avg_minutes FROM tickets WHERE closed_at IS NOT NULL;`

### Berlin spelled three ways in `customers.city`

`customers.city` holds Berlin as `Berlin` (7 customers), `Berlín` with an accent on the i (1 customer), and `berlin ` in small letters with a space at the end (2 customers): `SELECT city, length(city) AS characters, count(*) AS customers FROM customers WHERE lower(btrim(city)) LIKE '%berl%' GROUP BY city ORDER BY city;`

All ten folded together: `SELECT count(*) AS customers FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín');`

*10 rows.*

I count the three as one city. All ten rows carry `country` `DE`, and there is one Berlin in Germany. `Berlín` is the Spanish spelling of the same city, and `berlin ` differs from `Berlin` only by a small letter and a trailing space, which are typing differences.

Nothing in cloudbyte had been changed when this count was taken.

The repair, as run:

```sql
BEGIN;
UPDATE customers SET city = 'Berlin' WHERE lower(btrim(city)) IN ('berlin', 'berlín');
COMMIT;
```

The count just before the repair was 10, the same as above (`SELECT count(*) AS customers FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín');`), and the tag was `UPDATE 10`.

The check, `SELECT customer_id, city FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín') AND city <> 'Berlin';`, returned 0 rows.

The repair didn't change the figure from the blank `resolved_minutes` entry: the average is still 3571.10 minutes over 751 of 854 closed tickets, because it reads `tickets`, not `customers.city`.

Had the tag come back below 10, the `UPDATE` would have missed some of the Berlin rows I counted, and they would still carry their old spelling.

### Tickets closed before they opened

A ticket can't close before it opens, so `closed_at` is never earlier than `opened_at`. The tickets that break it: `SELECT ticket_id, opened_at, closed_at FROM tickets WHERE closed_at < opened_at ORDER BY ticket_id;`

*2 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The old `closed_at` values, before the repair: ticket 3558 opened `2025-12-14 13:39:00`, closed `2025-12-14 08:39:00`; ticket 3740 opened `2025-03-21 10:06:00`, closed `2025-03-21 05:06:00`.

The rule test, run after the orphan-tickets repair, like the one under the blank `resolved_minutes` entry: on the 741 tickets that aren't backwards and have a duration (`SELECT count(*) AS tickets_to_test FROM tickets WHERE closed_at >= opened_at AND resolved_minutes IS NOT NULL;`), all 741 have `closed_at` equal to `opened_at` plus `resolved_minutes` minutes (`SELECT count(*) AS tickets_that_agree FROM tickets WHERE closed_at >= opened_at AND resolved_minutes IS NOT NULL AND closed_at = opened_at + resolved_minutes * INTERVAL '1 minute';`).

The repair. The count just before it was still 2.

```sql
BEGIN;
UPDATE tickets SET closed_at = opened_at + resolved_minutes * INTERVAL '1 minute' WHERE closed_at < opened_at AND resolved_minutes IS NOT NULL;
COMMIT;
```

Tag: `UPDATE 2`. The check, the listing above, returned 0 rows. Ticket 3558 now closes at `2025-12-20 04:14:00`: 13:39 plus 8075 minutes. Ticket 3740 closes at `2025-03-30 18:55:00`.

I trusted the duration over the old `closed_at`: the duration agrees with the two timestamps on every one of the 741 tickets I could test, and each old `closed_at` is exactly five hours before its `opened_at` on the same day, which looks like a time-zone slip, not a real time.

The repair didn't change the `resolved_minutes` figure: 3573.76 over 743 of 844. It changed `closed_at`, not the minutes, and both tickets were already closed.

### Acme GmbH in `customers` twice

Each company is in `customers` once. The companies with more than one row, folded: `SELECT lower(btrim(company_name)) AS company, count(*) AS rows FROM customers GROUP BY lower(btrim(company_name)) HAVING count(*) > 1 ORDER BY company;`

*1 row.*

The company's rows: `customer_id` 1 (`Acme GmbH`) and 41 (`ACME GmbH`).

Nothing in cloudbyte had been changed when this count was taken.

The consolidation. Original `customer_id` 1, copy 41. The rows pointing at the copy before `BEGIN` (`SELECT 'instances' AS table_name, count(*) AS rows FROM instances WHERE customer_ref = 41 UNION ALL SELECT 'tickets', count(*) FROM tickets WHERE customer_ref = 41 UNION ALL SELECT 'invoices', count(*) FROM invoices WHERE customer_ref = 41 UNION ALL SELECT 'contacts', count(*) FROM contacts WHERE customer_ref = 41 UNION ALL SELECT 'portal_hits', count(*) FROM portal_hits WHERE customer_ref = 41;`): `instances` 16, `tickets` 31, `invoices` 24, `contacts` 3, `portal_hits` 3780.

```sql
BEGIN;
UPDATE instances SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE tickets SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE invoices SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE contacts SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE portal_hits SET customer_ref = 1 WHERE customer_ref = 41;
DELETE FROM customers WHERE customer_id = 41;
COMMIT;
```

Tags: `UPDATE 16`, `UPDATE 31`, `UPDATE 24`, `UPDATE 3`, `UPDATE 3780`, `DELETE 1`. Each matches its line of the tally.

Checks, both run before and again after `COMMIT` from a new connection, both 0 rows: `SELECT 'instances' AS table_name, instance_id AS id FROM instances WHERE customer_ref = 41 UNION ALL SELECT 'tickets', ticket_id FROM tickets WHERE customer_ref = 41 UNION ALL SELECT 'invoices', invoice_id FROM invoices WHERE customer_ref = 41 UNION ALL SELECT 'contacts', contact_id FROM contacts WHERE customer_ref = 41 UNION ALL SELECT 'portal_hits', hit_id FROM portal_hits WHERE customer_ref = 41;` and `SELECT lower(btrim(company_name)) AS company, count(*) AS rows FROM customers GROUP BY lower(btrim(company_name)) HAVING count(*) > 1 ORDER BY company;`

The consolidation didn't change the `resolved_minutes` figure: still 3571.10 over 751 of 854 closed tickets. It moved tickets between customers, not their minutes.

### Contacts listed twice under the same customer

One person is listed once under one customer: same `full_name`, same `customer_ref`. The people listed more than once: `SELECT full_name, customer_ref, count(*) AS rows FROM contacts GROUP BY full_name, customer_ref HAVING count(*) > 1 ORDER BY full_name;`

*5 rows.*

Each duplicated person's two `contact_id` values, with the rows of `portal_hits` pointing at each (`SELECT contact_ref, count(*) AS hits FROM portal_hits WHERE contact_ref IN (733, 734, 759, 760, 714, 715, 785, 786, 766, 767) GROUP BY contact_ref ORDER BY contact_ref;`; an id with no line has 0 hits):

- Anke Kroll, customer 16: 733 (1289 hits), 734 (0 hits)
- Bernd Nissen, customer 29: 759 (959 hits), 760 (991 hits)
- Clara Nissen, customer 7: 714 (1965 hits), 715 (0 hits)
- Dirk Ahrens, customer 41: 785 (1894 hits), 786 (0 hits)
- Holger Fricke, customer 31: 766 (858 hits), 767 (794 hits)

Nothing in cloudbyte had been changed when this count was taken.

The pair Dirk Ahrens moved: it was under customer 41, and the Acme consolidation above moved it to customer 1. It is still a pair.

What the deleted rows held that the kept rows don't (`SELECT contact_id, full_name, email, role FROM contacts WHERE contact_id IN (733, 734, 759, 760, 714, 715, 785, 786, 766, 767) ORDER BY full_name, contact_id;`, run before the repair):

- Anke Kroll: kept 733; deleted 734 had email `akroll@petersenmarine.example` (0 hits)
- Bernd Nissen: kept 760; deleted 759 held the same email and role
- Clara Nissen: kept 714; deleted 715 had email `cnissen@gerlachpharma.example` (0 hits)
- Dirk Ahrens: kept 785; deleted 786 had email `dahrens@acmegmbh.example` (0 hits)
- Holger Fricke: kept 766 (`billing`); deleted 767 had role `admin`, so Holger Fricke also works as `admin`

The repair. For each pair I keep the row with more portal hits and move the other row's hits to it. The count just before the repair was still 5 pairs (the Acme consolidation moved one pair to customer 1 but didn't change the count).

```sql
BEGIN;
UPDATE portal_hits SET contact_ref = 733 WHERE contact_ref = 734;
UPDATE portal_hits SET contact_ref = 760 WHERE contact_ref = 759;
UPDATE portal_hits SET contact_ref = 714 WHERE contact_ref = 715;
UPDATE portal_hits SET contact_ref = 785 WHERE contact_ref = 786;
UPDATE portal_hits SET contact_ref = 766 WHERE contact_ref = 767;
DELETE FROM contacts WHERE contact_id IN (734, 759, 715, 786, 767);
COMMIT;
```

Tags: `UPDATE 0`, `UPDATE 959`, `UPDATE 0`, `UPDATE 0`, `UPDATE 794`, each the hits on that pair's copy, and `DELETE 5`, one per copy.

Checks, before and after `COMMIT`, both 0 rows: `SELECT full_name, customer_ref, count(*) AS rows FROM contacts GROUP BY full_name, customer_ref HAVING count(*) > 1 ORDER BY full_name;` and `SELECT h.hit_id, h.contact_ref FROM portal_hits h LEFT JOIN contacts k ON k.contact_id = h.contact_ref WHERE k.contact_id IS NULL;`

The repair didn't change the `resolved_minutes` figure: still 3571.10.

### Test accounts in `customers`

A test account isn't a customer. The rows whose `company_name` says test: `SELECT customer_id, company_name FROM customers WHERE company_name ILIKE '%test%' ORDER BY customer_id;`

*2 rows.*

The test accounts are `customer_id` 42 (`zz_test_account`) and 43 (`TEST-Account`). Rows linked to them in each of the eight tables: `SELECT 'instances' AS table_name, count(*) AS rows FROM instances WHERE customer_ref IN (42, 43) UNION ALL SELECT 'invoices', count(*) FROM invoices WHERE customer_ref IN (42, 43) UNION ALL SELECT 'contacts', count(*) FROM contacts WHERE customer_ref IN (42, 43) UNION ALL SELECT 'tickets', count(*) FROM tickets WHERE customer_ref IN (42, 43) UNION ALL SELECT 'portal_hits', count(*) FROM portal_hits WHERE customer_ref IN (42, 43) UNION ALL SELECT 'usage_daily, through instances', count(*) FROM usage_daily u JOIN instances i ON i.instance_id = u.instance_id WHERE i.customer_ref IN (42, 43) UNION ALL SELECT 'invoice_lines, through invoices', count(*) FROM invoice_lines il JOIN invoices v ON v.invoice_id = il.invoice_id WHERE v.customer_ref IN (42, 43) UNION ALL SELECT 'ticket_notes, through tickets', count(*) FROM ticket_notes n JOIN tickets t ON t.ticket_id = n.ticket_id WHERE t.customer_ref IN (42, 43);`

- `instances`: 4
- `invoices`: 44
- `contacts`: 0
- `tickets`: 4
- `portal_hits`: 0
- `usage_daily`, through `instances`: 2136
- `invoice_lines`, through `invoices`: 75
- `ticket_notes`, through `tickets`: 15

Nothing in cloudbyte had been changed when this count was taken.

The repair. The tally taken again just before `BEGIN` gave the same eight figures as above.

```sql
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
```

Tags: `DELETE 2136`, `DELETE 75`, `DELETE 15`, `DELETE 4`, `DELETE 44`, `DELETE 4`, `DELETE 0`, `DELETE 0`, `DELETE 2`. Each matches its line of the tally, and the last is the two test accounts.

Checks, before and after `COMMIT`, both 0 rows: `SELECT 'instances' AS table_name, instance_id AS id FROM instances WHERE customer_ref IN (42, 43) UNION ALL SELECT 'invoices', invoice_id FROM invoices WHERE customer_ref IN (42, 43) UNION ALL SELECT 'contacts', contact_id FROM contacts WHERE customer_ref IN (42, 43) UNION ALL SELECT 'tickets', ticket_id FROM tickets WHERE customer_ref IN (42, 43) UNION ALL SELECT 'portal_hits', hit_id FROM portal_hits WHERE customer_ref IN (42, 43);` and `SELECT 'usage_daily' AS table_name, u.usage_id AS id FROM usage_daily u WHERE NOT EXISTS (SELECT 1 FROM instances i WHERE i.instance_id = u.instance_id) UNION ALL SELECT 'invoice_lines', il.line_id FROM invoice_lines il WHERE NOT EXISTS (SELECT 1 FROM invoices v WHERE v.invoice_id = il.invoice_id) UNION ALL SELECT 'ticket_notes', n.note_id FROM ticket_notes n WHERE NOT EXISTS (SELECT 1 FROM tickets t WHERE t.ticket_id = n.ticket_id);`

The repair moved the `resolved_minutes` figure down, from 3571.10 over 751 of 854 closed tickets to 3557.75 over 747 of 850: the four test-account tickets were closed and carried slow times.

### Tickets pointing at a customer who doesn't exist

Every row points at a customer who exists. The orphan tickets: `SELECT t.ticket_id, t.customer_ref FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL ORDER BY t.ticket_id;`

*6 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The repair. Before `BEGIN`, the orphans still counted 6 (`SELECT count(*) AS orphan_tickets, count(DISTINCT t.customer_ref) AS missing_customers FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL;`), and their notes counted 23 (`SELECT count(*) AS notes FROM ticket_notes WHERE ticket_id IN (SELECT t.ticket_id FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL);`).

```sql
BEGIN;
DELETE FROM ticket_notes WHERE ticket_id IN (SELECT t.ticket_id FROM tickets t LEFT JOIN customers c ON t.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
DELETE FROM tickets t WHERE NOT EXISTS (SELECT 1 FROM customers c WHERE c.customer_id = t.customer_ref);
COMMIT;
```

Tags: `DELETE 23`, matching the notes, and `DELETE 6`, matching the orphan count under `## Relationships`.

Checks, before and after `COMMIT`, both 0 rows: the orphan listing above, and `SELECT n.note_id FROM ticket_notes n WHERE NOT EXISTS (SELECT 1 FROM tickets t WHERE t.ticket_id = n.ticket_id);`

The repair moved the `resolved_minutes` figure up, from 3557.75 over 747 of 850 closed tickets to 3573.76 over 743 of 844.

`customers.status` holds two values, `active` 35 and `churned` 5 (`SELECT status, count(*) FROM customers GROUP BY status ORDER BY status;`), and neither is a fault: a churned customer was a real customer who left, so its row is true.

### The corrected figures

**Day one's top five**

The published query, run unchanged on `billing_export`: `SELECT city, sum(amount_eur) AS total_eur FROM billing_export GROUP BY city ORDER BY total_eur DESC LIMIT 5;`

The corrected query: `WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT CASE WHEN lower(btrim(city)) IN ('berlin', 'berlín') THEN 'Berlin' ELSE city END AS one_city, sum(amount_eur) AS total_eur FROM each_bill WHERE company NOT ILIKE '%test%' AND amount_eur IS NOT NULL GROUP BY one_city ORDER BY total_eur DESC LIMIT 5;`

| Rank | Published | Corrected |
|---|---|---|
| 1 | Bremen, EUR 6296.25 | Berlin, EUR 10221.05 |
| 2 | Hamburg, EUR 5932.03 | Bremen, EUR 5343.37 |
| 3 | Berlin, EUR 5749.73 | Hamburg, EUR 4858.99 |
| 4 | München, EUR 3717.24 | München, EUR 3185.13 |
| 5 | Berlín, EUR 3279.31 | Jena, EUR 2434.80 |

The rows the corrected query leaves out, counted at each stop (406 → 336 → 327 → 306):

- bills that are in twice: 70 rows (`SELECT count(*) AS stop_1 FROM billing_export;` and `WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT count(*) AS stop_2 FROM each_bill;`)
- test accounts: 9 rows (`WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT count(*) AS stop_3 FROM each_bill WHERE company NOT ILIKE '%test%';`)
- blank amounts: 21 rows (`WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT count(*) AS stop_4 FROM each_bill WHERE company NOT ILIKE '%test%' AND amount_eur IS NOT NULL;`)

The published answer was wrong mainly because it split Berlin across three spellings: counted as one city, Berlin spends EUR 10221.05 and moves from third to first, while the bills that were in twice inflated every other city's total.

**The time to close a ticket**

The two queries from the first entry, run again: `SELECT count(*) AS closed, count(resolved_minutes) AS with_minutes, round(avg(resolved_minutes), 2) AS avg_minutes FROM tickets WHERE closed_at IS NOT NULL;` and `SELECT count(*) AS left_out FROM tickets WHERE closed_at IS NOT NULL AND resolved_minutes IS NULL;`

|  | Old | Now |
|---|---|---|
| The figure | 3571.10 minutes, over 751 of 854 closed tickets | 3651.98 minutes, over all 844 closed tickets |
| Rows it left out | 103 | 0 |

The old figure was wrong because it left out the 103 closed tickets with a blank duration, and it also counted ten tickets that later repairs deleted: four from the test accounts and six orphans.

## Constraints

| # | the statement | what it closes |
|---:|---|---|
| 1 | `ALTER TABLE tickets ADD CONSTRAINT fk_tickets_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);` | `## Relationships`: `tickets.customer_ref` → `customers.customer_id` |
| 2 | `ALTER TABLE contacts ADD CONSTRAINT fk_contacts_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);` | `## Relationships`: `contacts.customer_ref` → `customers.customer_id` |
| 3 | `ALTER TABLE ticket_notes ADD CONSTRAINT fk_ticket_notes_ticket FOREIGN KEY (ticket_id) REFERENCES tickets (ticket_id);` | `## Relationships`: `ticket_notes.ticket_id` → `tickets.ticket_id` |
| 4 | `ALTER TABLE portal_hits ADD CONSTRAINT fk_portal_hits_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);` | `## Relationships`: `portal_hits.customer_ref` → `customers.customer_id` |
| 5 | `ALTER TABLE portal_hits ADD CONSTRAINT fk_portal_hits_contact FOREIGN KEY (contact_ref) REFERENCES contacts (contact_id);` | `## Relationships`: `portal_hits.contact_ref` → `contacts.contact_id` |
| 6 | `ALTER TABLE customers ADD CONSTRAINT uq_customers_company_name UNIQUE (company_name);` | `## Corrections`: Acme GmbH in `customers` twice |
| 7 | `ALTER TABLE contacts ADD CONSTRAINT uq_contacts_customer_name UNIQUE (customer_ref, full_name);` | `## Corrections`: Contacts listed twice under the same customer |
| 8 | `ALTER TABLE tickets ADD CONSTRAINT ck_ticket_order CHECK (closed_at IS NULL OR closed_at >= opened_at);` | `## Corrections`: Tickets closed before they opened |
| 9 | `ALTER TABLE customers ADD CONSTRAINT ck_customer_status CHECK (status IN ('active', 'churned'));` | the sentence on the status column, below the Section 4 entries |

```sql
SELECT c.conrelid::regclass::text AS table_name, c.conname AS name,
       CASE c.contype WHEN 'f' THEN 'foreign key' WHEN 'u' THEN 'unique' ELSE 'check' END AS kind
  FROM pg_constraint c
 WHERE c.connamespace = 'public'::regnamespace AND c.contype IN ('f', 'u', 'c')
UNION ALL
SELECT a.attrelid::regclass::text, a.attname::text, 'not null'
  FROM pg_attribute a JOIN pg_class r ON r.oid = a.attrelid
 WHERE r.relnamespace = 'public'::regnamespace AND r.relkind = 'r'
   AND a.attnum > 0 AND NOT a.attisdropped AND a.attnotnull
   AND NOT EXISTS (SELECT 1 FROM pg_constraint p
                    WHERE p.conrelid = a.attrelid AND p.contype = 'p' AND a.attnum = ANY (p.conkey))
ORDER BY table_name, name;
```

```
  table_name  |           name            |    kind     
--------------+---------------------------+-------------
 contacts     | fk_contacts_customer      | foreign key
 contacts     | uq_contacts_customer_name | unique
 customers    | ck_customer_status        | check
 customers    | uq_customers_company_name | unique
 portal_hits  | fk_portal_hits_contact    | foreign key
 portal_hits  | fk_portal_hits_customer   | foreign key
 ticket_notes | fk_ticket_notes_ticket    | foreign key
 tickets      | ck_ticket_order           | check
 tickets      | fk_tickets_customer       | foreign key
(9 rows)
```

The unique constraint on `company_name` refuses a second `Acme GmbH` spelled exactly the same, but it lets in `ACME GmbH`: `SELECT company_name, company_name = 'ACME GmbH' AS same_text FROM customers WHERE lower(btrim(company_name)) = 'acme gmbh';` prints `f`, because to PostgreSQL different capital letters make different text.

In `customers.status`, `active` means a customer who still has an account with CloudByte, and `churned` means a real customer who has left; the constraint allows only those two values.

## The slow report

The monthly report, portal hits per day for September 2025. Every plan below was taken on this statement, with `EXPLAIN (ANALYZE, BUFFERS)` in front of it:

```sql
SELECT date_trunc('day', h.hit_at) AS day, count(*) AS hits
FROM portal_hits h
WHERE h.hit_at >= TIMESTAMP '2025-09-01' AND h.hit_at < TIMESTAMP '2025-10-01'
GROUP BY day ORDER BY day;
```

| | node type | `Buffers:` under the line that names `portal_hits h` |
|---|---|---|
| before the index | `Seq Scan` | 1364 |
| after the index | `Index Only Scan` | 24 |

The kept index:

```sql
CREATE INDEX ix_portal_hits_hit_at ON portal_hits (hit_at);
```

Why it helps: before it, the only index on `portal_hits` was `portal_hits_pkey`, which sorts by `hit_id` first, and the report's `WHERE` tests `hit_at`, so no index could find September's rows and the scan read all 1364 pages. `ix_portal_hits_hit_at` sorts by `hit_at` first, so PostgreSQL goes straight to September's entries, and since the report reads no other column, it answers from the index alone.

The before plan can't be re-run while `ix_portal_hits_hit_at` is on the table: drop `ix_portal_hits_hit_at` to see it again.

## The blocked session

The diagnosis query, as run (with expanded display on, `\x on`, typed before it):

```sql
SELECT w.usename AS waiting, w.wait_event_type, w.wait_event, w.query AS waiting_query,
       b.usename AS blocking, b.state AS blocking_state, b.query AS blocking_query
FROM pg_stat_activity w
JOIN pg_stat_activity b ON b.pid = ANY (pg_blocking_pids(w.pid))
WHERE w.wait_event_type = 'Lock'
  AND w.pid <> pg_backend_pid();
```

The record it printed, taken while my `UPDATE` of customer 4 waited for the lock, printed with expanded display:

```
-[ RECORD 1 ]---+-------------------------------------------------------------
waiting         | ops_admin
wait_event_type | Lock
wait_event      | transactionid
waiting_query   | UPDATE customers SET city = 'Dresden' WHERE customer_id = 4;
blocking        | henry
blocking_state  | idle in transaction
blocking_query  | UPDATE customers SET city = 'Leipzig' WHERE customer_id = 4;
```

The statement that held the lock, confirmed by the person who held it as `henry`: `UPDATE customers SET city = 'Leipzig' WHERE customer_id = 4;`

What I'd do about a blocking session whose transaction I can't fully see: ask the person who owns the session to end their own transaction with `COMMIT;` or `ROLLBACK;`, and not end the session myself. Ending it rolls back everything its transaction did, and `blocking_query` shows only the last statement, so I could undo work I never saw. On this instance I couldn't end it anyway: PostgreSQL refused my attempt to end `henry`'s session with `ERROR:  permission denied to terminate process`, because `ops_admin` holds neither `henry`'s privileges nor those of `pg_signal_backend`.

On a quiet database, when no session waits for a lock, the diagnosis query returns no rows, so a later run prints `(0 rows)` and not this record.

## For a reader who does not read SQL

Start with `## Corrections`: it says which published figures changed.

The customer and support records we inherited had several faults: Berlin was typed three different ways, Acme GmbH was in the customer list twice, some contact people were listed twice under the same company, two test accounts sat among the real customers, six support tickets belonged to customers that did not exist, two tickets were closed five hours before they were opened, and 101 closed tickets had no time to resolve recorded. All of these are now fixed. The database now refuses some of the same mistakes if anyone tries them again: the exact same company name twice, the same person twice under one company, a ticket that closes before it opens, a customer that is neither active nor churned, and a ticket, contact or website visit linked to a customer, ticket or contact that doesn't exist. It still lets in a closed ticket with no time to resolve, a new spelling of a city, and a test account, so those need checking by hand. One thing can't be fixed: we don't know when those two backwards tickets really closed, so their closing times are worked out from the time each one took, not taken from a record. Because of the repairs, we now count 40 customers instead of 43 and 915 tickets instead of 925, and the average time to resolve a closed ticket is now about 3,652 minutes, roughly two and a half days, where before the repairs it read about 3,571 minutes, because it now counts every closed ticket.

## Reproducing this

To build a fresh copy of this database, run these three steps in order:

```
CREATE DATABASE cloudbyte_fresh OWNER <user>
  ENCODING 'UTF8' LOCALE_PROVIDER builtin BUILTIN_LOCALE 'C.UTF-8' TEMPLATE template0;
psql -h <host> -U <user> -d cloudbyte_fresh -v ON_ERROR_STOP=1 -f load.sql
psql -h <host> -U <user> -d cloudbyte_fresh -v ON_ERROR_STOP=1 -f changes.sql
```

Put your instance's endpoint in place of `<host>` and your role's name in place of `<user>`. psql asks for the password.

Where each step runs. Run the `CREATE DATABASE` statement in a psql session connected to `cloudbyte`, and stay connected there, because PostgreSQL won't drop a database your session is connected to. Run the `load.sql` command from the folder `cloudbyte-database`, the one that holds `load.sql`, `schema.sql` and the CSV files: `load.sql` reads them from the folder the terminal is in, and anywhere else it stops before it makes a table. Run the `changes.sql` command from this repository's folder.

Where the files come from. `changes.sql` is in this repository. `load.sql` isn't: it is in the `cloudbyte-database` zip from the course's Section 1 handout, downloaded from https://wbscodingschool.github.io/cloud-courses/sql-project/downloads/cloudbyte-database.zip and unpacked to `~/cloudbyte-sql/cloudbyte-database/`, the same files `cloudbyte` was first loaded from.

What the proof compared. On both `cloudbyte` and the fresh copy I ran one file of checks: the row count and the `\d` description (columns, `not null`, indexes and constraints) of each of the eleven inherited tables, and the check query of every entry under `## Corrections`. I saved each output to a file, and `diff` of the two files printed nothing.

What it doesn't prove. The proof compares counts, constraints and indexes, not the values in the rows, so a repair that set the right number of rows to a wrong value would still match.

The one expected difference. `cloudbyte` has a twelfth table, `billing_export`, which the copy doesn't have. I made it in Section 1 from the six monthly spreadsheet exports; `load.sql` builds only the eleven inherited tables, and `changes.sql` never touches `billing_export`. A copy without it has not failed.
