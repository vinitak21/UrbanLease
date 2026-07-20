# Auth Database

## Overview

The `urbanlease_auth` database is responsible for managing authentication and authorization for the UrbanLease platform.

It stores user credentials, roles, permissions, refresh tokens, password reset requests, email verification requests, and login audit records.

---

## Responsibilities

The Auth database is responsible for:

- User Registration
- User Authentication
- Role-Based Access Control (RBAC)
- Refresh Token Management
- Password Reset
- Email Verification
- Login Audit
- Account Status Management

It is **not** responsible for storing user profile information such as name, address, phone number, profile image, or personal preferences.

---

## Business Rules

- One email address can be registered only once.
- One user is assigned exactly one role.
- Passwords are stored using BCrypt hashing.
- JWT access tokens are never stored in the database.
- Only refresh tokens are persisted.
- Email verification is required before login.
- Password reset tokens are single-use.
- Email verification tokens are single-use.
- Locked or disabled accounts cannot authenticate.
- Expired tokens are periodically removed by scheduled jobs.

---

## Database Information

| Property             | Value                 |
|--------------------- |-----------------------|
| Database Name        | `urbanlease_auth`     |
| Storage Engine       | InnoDB                |
| Character Set        | utf8mb4               |
| Collation            | utf8mb4_unicode_ci    |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier    | UUID (CHAR(36))       |
| Password Encryption  | BCrypt                |
