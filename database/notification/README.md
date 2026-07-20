# Notification Database

## Overview

The `urbanlease_notification` database is responsible for managing all notifications generated within the UrbanLease platform.

It stores notification templates, notification requests, delivery status, notification history, and user notification preferences. It serves as the centralized communication service for email, SMS, push notifications, and in-app notifications.

---

## Responsibilities

The Notification database is responsible for:

- Managing notification requests
- Delivering notifications
- Storing notification templates
- Tracking notification delivery status
- Maintaining notification history
- Managing user notification preferences
---

## Business Rules

- Every notification belongs to one recipient identified by `recipient_uuid`.
- Notifications may originate from any microservice.
- Notifications can be delivered through multiple channels.
- Notification delivery attempts are recorded.
- Notification templates can be reused.
- Notification history is never deleted.
- Cross-database foreign keys are not used.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_notification` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | All Microservices |
