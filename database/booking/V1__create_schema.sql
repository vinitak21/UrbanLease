-- =============================================================================
-- TABLE : booking_documents
-- Description :
-- Stores metadata of documents associated with bookings.
--
-- Business Rules
-- ----------------
-- • A booking can have multiple documents.
-- • Only document metadata is stored.
-- • Actual document files are managed by the Document Service.
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

-- =============================================================================
-- END OF SCHEMA
--
-- Tables Created
-- -----------------------------------------------------------------------------
-- ✔ bookings
-- ✔ booking_status_history
-- ✔ rental_agreements
-- ✔ booking_documents
--
-- Total Tables : 4
--
-- Database Status : COMPLETE
-- =============================================================================