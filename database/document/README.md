# Document Database

## Overview

The `urbanlease_document` database is responsible for managing document metadata across the UrbanLease platform.

It stores metadata for uploaded documents, document versions, document sharing information, and document access history. The actual document files are stored in external object storage, while this database maintains references and audit information.

---

## Responsibilities

The Document database is responsible for:

- Managing uploaded document metadata
- Tracking document versions
- Managing document sharing
- Recording document access history
- Maintaining document lifecycle information

These responsibilities belong to their respective microservices.

---

## Business Rules

- Every document belongs to one entity using entity UUID references.
- Documents may belong to any service.
- Multiple versions of a document are supported.
- Every document has a unique document reference.
- Actual files are stored outside the database.
- Every document access is logged.
- Cross-database foreign keys are not used.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_document` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | Auth, User, Property, Booking, Payment, Maintenance, AI |
