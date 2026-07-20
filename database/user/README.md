# User Database

## Overview

The `urbanlease_user` database is responsible for managing user profile information for the UrbanLease platform.

It stores personal details, contact information, addresses, emergency contacts, and user preferences. This database is independent of authentication and authorization, which are managed by the Auth database. It serves as the central repository for user-related business information across the platform.

---

## Responsibilities

The User database is responsible for:

- Managing user profiles
- Storing personal information
- Managing contact details
- Managing user addresses
- Storing emergency contact information
- Managing user preferences
- Supporting profile updates

It is **not** responsible for:

- User authentication
- Password management
- Role and permission management
- JWT or Refresh Token storage
- Login history
- Password reset or email verification

These responsibilities belong to the **Auth Database**.

---

## Business Rules

- Every user profile is associated with exactly one authenticated account.
- The Auth database remains the source of truth for authentication and authorization.
- User profiles are linked using the `credential_uuid` received from the Auth Service.
- Cross-database foreign keys are not used to maintain microservice independence.
- A user can have multiple addresses.
- A user can have multiple emergency contacts.
- A user has one preference record.
- User records are managed using soft deletion through an `is_active` flag.
- Profile information can be updated without affecting authentication data.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_user` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Service | Auth Service |
