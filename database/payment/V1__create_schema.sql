/*
===============================================================================
 Project      : UrbanLease
 Module       : Payment Service
 Database     : urbanlease_payment
 Script       : V1__create_schema.sql
 
 Description:
 Creates the Payment database schema.
===============================================================================
*/
-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_payment
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_payment;

-- =============================================================================
-- TABLE : payments
-- Description :
-- Stores payment information for property bookings.
-- =============================================================================

CREATE TABLE payments
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service References
    booking_uuid CHAR(36) NOT NULL,
    tenant_uuid CHAR(36) NOT NULL,

    -- Payment Details
    payment_reference VARCHAR(50) NOT NULL,

    payment_type ENUM(
        'RENT',
        'SECURITY_DEPOSIT',
        'MAINTENANCE',
        'LATE_FEE',
        'REFUND',
        'OTHER'
    ) NOT NULL,

    payment_method ENUM(
        'UPI',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'NET_BANKING',
        'BANK_TRANSFER',
        'WALLET',
        'CASH'
    ) NOT NULL,

    payment_status ENUM(
        'PENDING',
        'PROCESSING',
        'SUCCESS',
        'FAILED',
        'REFUNDED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',

    -- Financial Information
    amount DECIMAL(12,2) NOT NULL,

    currency VARCHAR(10) NOT NULL DEFAULT 'INR',

    payment_date DATETIME,

    due_date DATE,

    description VARCHAR(255),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_payments
        PRIMARY KEY (id),

    CONSTRAINT uk_payments_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_payments_reference
        UNIQUE (payment_reference)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores payment information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_payments_uuid
    ON payments(uuid);

CREATE INDEX idx_payments_booking_uuid
    ON payments(booking_uuid);

CREATE INDEX idx_payments_tenant_uuid
    ON payments(tenant_uuid);

CREATE INDEX idx_payments_reference
    ON payments(payment_reference);

CREATE INDEX idx_payments_type
    ON payments(payment_type);

CREATE INDEX idx_payments_method
    ON payments(payment_method);

CREATE INDEX idx_payments_status
    ON payments(payment_status);

CREATE INDEX idx_payments_amount
    ON payments(amount);

CREATE INDEX idx_payments_payment_date
    ON payments(payment_date);

CREATE INDEX idx_payments_due_date
    ON payments(due_date);

CREATE INDEX idx_payments_is_active
    ON payments(is_active);

-- =============================================================================
-- TABLE : payment_transactions
-- Description :
-- Stores payment gateway transaction details.
-- =============================================================================

CREATE TABLE payment_transactions
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    payment_id BIGINT NOT NULL,

    -- Gateway Information
    transaction_reference VARCHAR(100) NOT NULL,

    gateway_name ENUM(
        'RAZORPAY',
        'STRIPE',
        'PAYPAL',
        'PHONEPE',
        'PAYTM',
        'OTHER'
    ) NOT NULL,

    gateway_payment_id VARCHAR(150),

    gateway_order_id VARCHAR(150),

    gateway_signature VARCHAR(255),

    -- Transaction Details
    transaction_status ENUM(
        'INITIATED',
        'SUCCESS',
        'FAILED',
        'CANCELLED'
    ) NOT NULL,

    transaction_amount DECIMAL(12,2) NOT NULL,

    transaction_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    gateway_response TEXT,

    failure_reason VARCHAR(255),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_payment_transactions
        PRIMARY KEY (id),

    CONSTRAINT uk_payment_transactions_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_payment_transactions_reference
        UNIQUE (transaction_reference),

    CONSTRAINT fk_payment_transactions_payment_id
        FOREIGN KEY (payment_id)
        REFERENCES payments(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores payment gateway transaction details';

-- =============================================================================
-- TABLE : payment_refunds
-- Description :
-- Stores refund information for completed payments.
-- =============================================================================

CREATE TABLE payment_refunds
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    payment_id BIGINT NOT NULL,

    -- Refund Information
    refund_reference VARCHAR(100) NOT NULL,

    refund_amount DECIMAL(12,2) NOT NULL,

    refund_reason VARCHAR(255) NOT NULL,

    refund_status ENUM(
        'PENDING',
        'PROCESSING',
        'SUCCESS',
        'FAILED'
    ) NOT NULL DEFAULT 'PENDING',

    refund_date DATETIME,

    gateway_refund_id VARCHAR(150),

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
    CONSTRAINT pk_payment_refunds
        PRIMARY KEY (id),

    CONSTRAINT uk_payment_refunds_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_payment_refunds_reference
        UNIQUE (refund_reference),

    CONSTRAINT fk_payment_refunds_payment_id
        FOREIGN KEY (payment_id)
        REFERENCES payments(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores payment refund information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_payment_transactions_payment_id
    ON payment_transactions(payment_id);

CREATE INDEX idx_payment_transactions_gateway_name
    ON payment_transactions(gateway_name);

CREATE INDEX idx_payment_transactions_status
    ON payment_transactions(transaction_status);

CREATE INDEX idx_payment_transactions_time
    ON payment_transactions(transaction_time);

CREATE INDEX idx_payment_refunds_payment_id
    ON payment_refunds(payment_id);

CREATE INDEX idx_payment_refunds_reference
    ON payment_refunds(refund_reference);

CREATE INDEX idx_payment_refunds_status
    ON payment_refunds(refund_status);

CREATE INDEX idx_payment_refunds_date
    ON payment_refunds(refund_date);

CREATE INDEX idx_payment_refunds_is_active
    ON payment_refunds(is_active);

-- =============================================================================
-- TABLE : payment_invoices
-- Description :
-- Stores invoice information generated for payments.
-- =============================================================================

CREATE TABLE payment_invoices
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    payment_id BIGINT NOT NULL,

    -- Invoice Information
    invoice_number VARCHAR(50) NOT NULL,

    invoice_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    invoice_amount DECIMAL(12,2) NOT NULL,

    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    total_amount DECIMAL(12,2) NOT NULL,

    invoice_status ENUM(
        'GENERATED',
        'SENT',
        'PAID',
        'CANCELLED'
    ) NOT NULL DEFAULT 'GENERATED',

    invoice_url VARCHAR(500),

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
    CONSTRAINT pk_payment_invoices
        PRIMARY KEY (id),

    CONSTRAINT uk_payment_invoices_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_payment_invoices_number
        UNIQUE (invoice_number),

    CONSTRAINT uk_payment_invoices_payment_id
        UNIQUE (payment_id),

    CONSTRAINT fk_payment_invoices_payment_id
        FOREIGN KEY (payment_id)
        REFERENCES payments(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores payment invoice metadata';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_payment_invoices_payment_id
    ON payment_invoices(payment_id);

CREATE INDEX idx_payment_invoices_invoice_number
    ON payment_invoices(invoice_number);

CREATE INDEX idx_payment_invoices_invoice_status
    ON payment_invoices(invoice_status);

CREATE INDEX idx_payment_invoices_invoice_date
    ON payment_invoices(invoice_date);

CREATE INDEX idx_payment_invoices_is_active
    ON payment_invoices(is_active);
