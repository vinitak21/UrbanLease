# Property Database

## Overview

The `urbanlease_property` database is responsible for managing all property-related information within the UrbanLease platform.

It stores property details, property images, amenities, document references, and availability information. This database acts as the central source of truth for rental properties and is independent of user authentication, bookings, payments, and maintenance operations.

---

## Responsibilities

The Property database is responsible for:

- Managing property information
- Storing property specifications
- Managing property images
- Managing property amenities
- Storing property document references
- Managing property availability
- Tracking property status

---

## Business Rules

- Every property belongs to a single property owner identified by `owner_uuid`.
- Cross-database foreign keys are not used to maintain microservice independence.
- A property can have multiple images.
- A property can have multiple amenities.
- A property can have multiple document references.
- A property has one availability record that is updated based on booking status.
- Only active properties are available for booking.
- Document metadata is stored in this database, while the actual files are managed by the Document Service.
- Property information can be updated without affecting bookings or payments.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_property` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Service | User Service |
| Version | 1.0 |
| Status | Approved (Frozen) |