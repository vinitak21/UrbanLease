/*
===============================================================================
 Project      : UrbanLease
 Module       : Booking Service
 Database     : urbanlease_booking
 Script       : V1__create_schema.sql

 Description:
 Creates the Booking database schema.
===============================================================================
*/
-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_booking
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_booking;

-- =============================================================================
-- TABLE : bookings
-- Description :
-- Stores booking information between tenants and property owners.
-- =============================================================================

CREATE TABLE bookings
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service References
    property_uuid CHAR(36) NOT NULL,
    owner_uuid CHAR(36) NOT NULL,
    tenant_uuid CHAR(36) NOT NULL,

    -- Booking Details
    booking_reference VARCHAR(30) NOT NULL,

    booking_status ENUM(
        'PENDING',
        'CONFIRMED',
        'REJECTED',
        'CANCELLED',
        'COMPLETED'
    ) NOT NULL DEFAULT 'PENDING',

    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    move_in_date DATE NOT NULL,
    move_out_date DATE,

    -- Financial Details
    monthly_rent DECIMAL(12,2) NOT NULL,
    security_deposit DECIMAL(12,2) NOT NULL,

    -- Occupancy
    number_of_occupants INT NOT NULL DEFAULT 1,

    -- Additional Information
    special_request TEXT,

    cancellation_reason VARCHAR(255),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_bookings
        PRIMARY KEY (id),

    CONSTRAINT uk_bookings_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_bookings_reference
        UNIQUE (booking_reference)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores property booking information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_bookings_uuid
    ON bookings(uuid);

CREATE INDEX idx_bookings_property_uuid
    ON bookings(property_uuid);

CREATE INDEX idx_bookings_owner_uuid
    ON bookings(owner_uuid);

CREATE INDEX idx_bookings_tenant_uuid
    ON bookings(tenant_uuid);

CREATE INDEX idx_bookings_status
    ON bookings(booking_status);

CREATE INDEX idx_bookings_booking_date
    ON bookings(booking_date);

CREATE INDEX idx_bookings_move_in_date
    ON bookings(move_in_date);

CREATE INDEX idx_bookings_move_out_date
    ON bookings(move_out_date);

CREATE INDEX idx_bookings_is_active
    ON bookings(is_active);

-- =============================================================================
-- TABLE : booking_status_history
-- Description :
-- Stores complete booking status transition history.
-- =============================================================================

CREATE TABLE booking_status_history
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    booking_id BIGINT NOT NULL,

    -- Status Information
    previous_status ENUM(
        'PENDING',
        'CONFIRMED',
        'REJECTED',
        'CANCELLED',
        'COMPLETED'
    ),

    current_status ENUM(
        'PENDING',
        'CONFIRMED',
        'REJECTED',
        'CANCELLED',
        'COMPLETED'
    ) NOT NULL,

    status_changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    remarks VARCHAR(255),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_booking_status_history
        PRIMARY KEY (id),

    CONSTRAINT uk_booking_status_history_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_booking_status_history_booking_id
        FOREIGN KEY (booking_id)
        REFERENCES bookings(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Stores booking status history';

-- =============================================================================
-- TABLE : rental_agreements
-- Description :
-- Stores rental agreement information associated with bookings.
-- =============================================================================

CREATE TABLE rental_agreements
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    booking_id BIGINT NOT NULL,

    -- Agreement Details
    agreement_number VARCHAR(50) NOT NULL,

    agreement_start_date DATE NOT NULL,

    agreement_end_date DATE NOT NULL,

    agreement_status ENUM(
        'DRAFT',
        'ACTIVE',
        'EXPIRED',
        'TERMINATED'
    ) NOT NULL DEFAULT 'DRAFT',

    agreement_document_url VARCHAR(500),

    remarks VARCHAR(255),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_rental_agreements
        PRIMARY KEY (id),

    CONSTRAINT uk_rental_agreements_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_rental_agreements_booking_id
        UNIQUE (booking_id),

    CONSTRAINT uk_rental_agreements_number
        UNIQUE (agreement_number),

    CONSTRAINT fk_rental_agreements_booking_id
        FOREIGN KEY (booking_id)
        REFERENCES bookings(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Stores rental agreement details';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_booking_status_history_booking_id
    ON booking_status_history(booking_id);

CREATE INDEX idx_booking_status_history_current_status
    ON booking_status_history(current_status);

CREATE INDEX idx_booking_status_history_changed_at
    ON booking_status_history(status_changed_at);

CREATE INDEX idx_rental_agreements_booking_id
    ON rental_agreements(booking_id);

CREATE INDEX idx_rental_agreements_number
    ON rental_agreements(agreement_number);

CREATE INDEX idx_rental_agreements_status
    ON rental_agreements(agreement_status);

CREATE INDEX idx_rental_agreements_start_date
    ON rental_agreements(agreement_start_date);

CREATE INDEX idx_rental_agreements_end_date
    ON rental_agreements(agreement_end_date);

CREATE INDEX idx_rental_agreements_is_active
    ON rental_agreements(is_active);

-- =============================================================================
-- TABLE : booking_documents
-- Description :
-- Stores metadata of documents associated with bookings.
-- =============================================================================

CREATE TABLE booking_documents
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    booking_id BIGINT NOT NULL,

    -- Document Information
    document_name VARCHAR(150) NOT NULL,

    document_type ENUM(
        'BOOKING_CONFIRMATION',
        'RENTAL_AGREEMENT',
        'IDENTITY_PROOF',
        'PAYMENT_RECEIPT',
        'OTHER'
    ) NOT NULL,

    document_url VARCHAR(500) NOT NULL,

    verification_status ENUM(
        'PENDING',
        'VERIFIED',
        'REJECTED'
    ) NOT NULL DEFAULT 'PENDING',

    remarks VARCHAR(255),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_booking_documents
        PRIMARY KEY (id),

    CONSTRAINT uk_booking_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_booking_documents_booking_id
        FOREIGN KEY (booking_id)
        REFERENCES bookings(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores booking document metadata';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_booking_documents_booking_id
    ON booking_documents(booking_id);

CREATE INDEX idx_booking_documents_document_type
    ON booking_documents(document_type);

CREATE INDEX idx_booking_documents_verification_status
    ON booking_documents(verification_status);

CREATE INDEX idx_booking_documents_is_active
    ON booking_documents(is_active);
