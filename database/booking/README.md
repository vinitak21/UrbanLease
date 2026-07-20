# Booking Database

## Overview

The `urbanlease_booking` database is responsible for managing property bookings within the UrbanLease platform.

It stores booking requests, booking details, rental agreements, and booking history. This database coordinates the rental lifecycle between tenants and property owners while remaining independent of authentication, property management, and payment processing.

---

## Responsibilities

The Booking database is responsible for:

- Managing booking requests
- Managing confirmed bookings
- Tracking booking status
- Storing rental agreement information
- Managing check-in and check-out dates
- Maintaining booking history
---

## Business Rules

- Every booking belongs to one property.
- Every booking is created by one tenant identified using `tenant_uuid`.
- Every booking references one property using `property_uuid`.
- Cross-database foreign keys are not used to maintain microservice independence.
- A property cannot have overlapping confirmed bookings.
- Every booking follows a defined lifecycle (Pending → Confirmed → Completed / Cancelled).
- Booking cancellation does not delete booking history.
- Rental agreement information is linked to the booking.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_booking` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | User Service, Property Service |
