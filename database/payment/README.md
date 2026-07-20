# Payment Database

## Overview

The `urbanlease_payment` database is responsible for managing all financial transactions within the UrbanLease platform.

It stores rent payments, security deposit transactions, refunds, invoices, and payment history. This database acts as the financial source of truth while remaining independent of booking management, user management, and property management.

---

## Responsibilities

The Payment database is responsible for:

- Processing rent payments
- Managing security deposit transactions
- Recording payment transactions
- Managing invoices
- Processing refunds
- Maintaining payment history
- Tracking payment status

---

## Business Rules

- Every payment belongs to one booking identified by `booking_uuid`.
- Every payment is made by one tenant identified by `tenant_uuid`.
- Cross-database foreign keys are not used.
- Every payment receives a unique transaction reference.
- One booking can have multiple payments.
- Refunds are linked to their original payment.
- Every invoice belongs to one payment.
- Payment history is never deleted.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_payment` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | Booking Service, User Service |
