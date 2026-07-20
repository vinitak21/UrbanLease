# Maintenance Database

## Overview

The `urbanlease_maintenance` database is responsible for managing maintenance requests, work assignments, inspections, service updates, and maintenance history for rental properties.

It enables tenants to report issues, owners to monitor progress, and service personnel to resolve maintenance requests while maintaining a complete audit trail.

---

## Responsibilities

The Maintenance database is responsible for:

- Managing maintenance requests
- Tracking request status
- Assigning service personnel
- Recording inspections
- Maintaining service history
- Storing maintenance attachments metadata

---

## Business Rules

- Every maintenance request belongs to one property identified by `property_uuid`.
- Every maintenance request is created by one tenant identified by `tenant_uuid`.
- Every request belongs to one property owner identified by `owner_uuid`.
- A maintenance request may be assigned to one service person.
- A maintenance request maintains complete status history.
- Multiple attachments can be associated with a request.
- Actual attachment files are stored by the Document Service.
- Cross-database foreign keys are not used.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_maintenance` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | User Service, Property Service, Document Service |
