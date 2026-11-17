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

*43 rows.* `SELECT count(*) FROM customers;`

| column | what it holds | the query that proved it |
|---|---|---|
| `customer_id` | the customer's number, from `1` to `43` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `company_name` | the customer company's name written out, such as `Acme GmbH` | `SELECT * FROM customers ORDER BY customer_id LIMIT 3;` |
| `city` | the customer's city, 28 distinct spellings; Berlin appears as `Berlin` 7, `Berlín` 1 and `berlin` 2 | `SELECT city, count(*) FROM customers GROUP BY city ORDER BY city;` |
| `country` | a two-letter country code: `AT` 1, `CH` 1, `DE` 40, `SE` 1 | `SELECT country, count(*) FROM customers GROUP BY country ORDER BY country;` |
| `signed_on` | the day the customer signed, from `2023-01-17` to `2025-04-08` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `plan` | one of three plans: `basic` 16, `enterprise` 9, `standard` 18 | `SELECT plan, count(*) FROM customers GROUP BY plan ORDER BY plan;` |
| `status` | `active` 38 or `churned` 5 | `SELECT status, count(*) FROM customers GROUP BY status ORDER BY status;` |
| `contact_1_email` | the customer's first contact's email address, filled on 41 of the 43 customers | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_2_email` | a second contact's email address, filled on 29 of the 43 | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_3_email` | a third contact's email address, filled on 2 of the 43. A fourth contact has nowhere to go: no column holds one, and finding a customer by a contact's email means searching all three columns | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |

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

*87 rows.* `SELECT count(*) FROM contacts;`

| column | what it holds | the query that proved it |
|---|---|---|
| `contact_id` | the contact's number, from `701` to `787` | `SELECT min(contact_id), max(contact_id), min(customer_ref), max(customer_ref), count(*) FROM contacts;` |
| `customer_ref` | a customer number, from `1` to `41` | `SELECT min(contact_id), max(contact_id), min(customer_ref), max(customer_ref), count(*) FROM contacts;` |
| `full_name` | a person's first and last name, such as `Jörg Baumgart` | `SELECT * FROM contacts ORDER BY contact_id LIMIT 3;` |
| `email` | the person's email address, `first.last@company.example` | `SELECT * FROM contacts ORDER BY contact_id LIMIT 3;` |
| `role` | one of three roles, 29 each: `admin`, `billing`, `technical` | `SELECT role, count(*) FROM contacts GROUP BY role ORDER BY role;` |

## tickets

*925 rows.* `SELECT count(*) FROM tickets;`

| column | what it holds | the query that proved it |
|---|---|---|
| `ticket_id` | the ticket's number, from `3001` to `3925` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `customer_ref` | a customer number, from `1` to `46` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `category` | one of five words: `access` 182, `billing` 203, `network` 192, `performance` 162, `storage` 186 | `SELECT category, count(*) FROM tickets GROUP BY category ORDER BY category;` |
| `st_flag_2` | **Not proved:** a number from 1 to 4 that looks like how slow a ticket was to resolve. Per value, `resolved_minutes` runs: `1` 235 tickets, 20 to 239; `2` 225, 129 to 1440; `3` 249, 604 to 7157; `4` 216, 1496 to 20045. The ranges overlap, so no rule sets it | `SELECT st_flag_2, count(*), min(resolved_minutes), max(resolved_minutes) FROM tickets GROUP BY st_flag_2 ORDER BY st_flag_2;` |
| `opened_at` | when the ticket was opened, from `2024-01-02 11:14` to `2025-12-31 08:07` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `closed_at` | when the ticket was closed, from `2024-01-03 13:19` to `2025-12-29 07:25` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `resolved_minutes` | minutes to resolve, from `20` to `20045` | `SELECT min(ticket_id), max(ticket_id), min(customer_ref), max(customer_ref), min(opened_at), max(opened_at), min(closed_at), max(closed_at), min(resolved_minutes), max(resolved_minutes), count(*) FROM tickets;` |
| `assigned_to` | a staff username, 12 names from `alice` 83 to `leo` 74 | `SELECT assigned_to, count(*) FROM tickets GROUP BY assigned_to ORDER BY assigned_to;` |

## ticket_notes

*3246 rows.* `SELECT count(*) FROM ticket_notes;`

| column | what it holds | the query that proved it |
|---|---|---|
| `note_id` | the note's number, from `40001` to `43246` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `ticket_id` | a ticket number, from `3001` to `3925` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `author` | a staff username, the same 12 names as `tickets.assigned_to`, `alice` 238 to `leo` 261 | `SELECT author, count(*) FROM ticket_notes GROUP BY author ORDER BY author;` |
| `note_at` | when the note was written, from `2024-01-03 09:14` to `2026-01-02 13:22` | `SELECT min(note_id), max(note_id), min(ticket_id), max(ticket_id), min(note_at), max(note_at), count(*) FROM ticket_notes;` |
| `body` | one of eight stock sentences, such as `Waiting on the customer.` 390 and `Escalated to engineering.` 372 | `SELECT body, count(*) FROM ticket_notes GROUP BY body ORDER BY body;` |

## portal_hits

*135877 rows.* `SELECT count(*) FROM portal_hits;`

| column | what it holds | the query that proved it |
|---|---|---|
| `hit_id` | the hit's number, from `1` to `135877` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `customer_ref` | a customer number, from `1` to `41` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `contact_ref` | a contact number, from `701` to `787` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `hit_at` | when the page was requested, from `2024-01-01 06:02:53` to `2025-11-28 20:57:12` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |
| `path` | one of ten portal pages, `/account` 13388 to `/support/new` 13515 | `SELECT path, count(*) FROM portal_hits GROUP BY path ORDER BY path;` |
| `status_code` | an HTTP status: `200` 122419, `404` 6636, `500` 6822 | `SELECT status_code, count(*) FROM portal_hits GROUP BY status_code ORDER BY status_code;` |
| `duration_ms` | how long the request took in milliseconds, from `12` to `2400` | `SELECT min(hit_id), max(hit_id), min(customer_ref), max(customer_ref), min(contact_ref), max(contact_ref), min(hit_at), max(hit_at), min(duration_ms), max(duration_ms), count(*) FROM portal_hits;` |

`portal_hits` stopped being filled early: its last visit is at `2025-11-28 20:57:12`, while the support desk's last ticket was opened at `2025-12-31 08:07:00`, so the portal's visits from 29 November 2025 on are missing. Found with `SELECT max(hit_at) AS last_hit FROM portal_hits;` and `SELECT max(opened_at) AS last_ticket FROM tickets;`
