# AI Database

## Overview

The `urbanlease_ai` database is responsible for managing AI-generated requests, responses, recommendations, conversations, and model execution history within the UrbanLease platform.

It serves as the persistence layer for all AI interactions while keeping the actual AI models independent from the application.

---

## Responsibilities

The AI database is responsible for:

- Managing AI conversations
- Storing AI prompts
- Storing AI responses
- Managing AI recommendations
- Recording AI execution history
- Tracking AI model usage
---

## Business Rules

- Every AI conversation belongs to one user identified by `user_uuid`.
- One conversation can contain multiple prompts and responses.
- AI recommendations are linked to a conversation.
- AI execution history is immutable.
- Actual AI models are external to this database.
- Cross-database foreign keys are not used.

---

## Database Information

| Property | Value |
|----------|-------|
| Database Name | `urbanlease_ai` |
| Storage Engine | InnoDB |
| Character Set | utf8mb4 |
| Collation | utf8mb4_unicode_ci |
| Primary Key Strategy | BIGINT AUTO_INCREMENT |
| Public Identifier | UUID (CHAR(36)) |
| Linked Services | User, Property, Booking, Payment, Maintenance, Document |
