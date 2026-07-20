/*
===============================================================================
 Project      : UrbanLease
 Module       : Maintenance Service
 Database     : urbanlease_maintenance
 Script       : V1__create_schema.sql
 
 Description:
 Creates the Maintenance database schema.

===============================================================================
*/
-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_maintenance
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_maintenance;

-- =============================================================================
-- TABLE : maintenance_requests
-- Description :
-- Stores maintenance requests raised by tenants.
-- =============================================================================

CREATE TABLE maintenance_requests
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service References
    property_uuid CHAR(36) NOT NULL,

    tenant_uuid CHAR(36) NOT NULL,

    owner_uuid CHAR(36) NOT NULL,

    assigned_to_uuid CHAR(36),

    -- Request Information
    request_reference VARCHAR(50) NOT NULL,

    issue_category ENUM(
        'PLUMBING',
        'ELECTRICAL',
        'CARPENTRY',
        'PAINTING',
        'CLEANING',
        'APPLIANCE',
        'PEST_CONTROL',
        'SECURITY',
        'HVAC',
        'OTHER'
    ) NOT NULL,

    priority ENUM(
        'LOW',
        'MEDIUM',
        'HIGH',
        'URGENT'
    ) NOT NULL DEFAULT 'MEDIUM',

    request_status ENUM(
        'OPEN',
        'ASSIGNED',
        'IN_PROGRESS',
        'ON_HOLD',
        'COMPLETED',
        'CANCELLED',
        'REJECTED'
    ) NOT NULL DEFAULT 'OPEN',

    issue_title VARCHAR(150) NOT NULL,

    issue_description TEXT NOT NULL,

    reported_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    scheduled_date DATE,

    completed_date DATE,

    estimated_cost DECIMAL(12,2) DEFAULT 0.00,

    actual_cost DECIMAL(12,2) DEFAULT 0.00,

    tenant_rating TINYINT,

    tenant_feedback VARCHAR(500),

    owner_notes VARCHAR(500),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_maintenance_requests
        PRIMARY KEY (id),

    CONSTRAINT uk_maintenance_requests_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_maintenance_requests_reference
        UNIQUE (request_reference)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores maintenance requests';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_maintenance_requests_uuid
    ON maintenance_requests(uuid);

CREATE INDEX idx_maintenance_requests_property_uuid
    ON maintenance_requests(property_uuid);

CREATE INDEX idx_maintenance_requests_tenant_uuid
    ON maintenance_requests(tenant_uuid);

CREATE INDEX idx_maintenance_requests_owner_uuid
    ON maintenance_requests(owner_uuid);

CREATE INDEX idx_maintenance_requests_assigned_to_uuid
    ON maintenance_requests(assigned_to_uuid);

CREATE INDEX idx_maintenance_requests_reference
    ON maintenance_requests(request_reference);

CREATE INDEX idx_maintenance_requests_category
    ON maintenance_requests(issue_category);

CREATE INDEX idx_maintenance_requests_priority
    ON maintenance_requests(priority);

CREATE INDEX idx_maintenance_requests_status
    ON maintenance_requests(request_status);

CREATE INDEX idx_maintenance_requests_reported_at
    ON maintenance_requests(reported_at);

CREATE INDEX idx_maintenance_requests_scheduled_date
    ON maintenance_requests(scheduled_date);

CREATE INDEX idx_maintenance_requests_completed_date
    ON maintenance_requests(completed_date);

CREATE INDEX idx_maintenance_requests_is_active
    ON maintenance_requests(is_active);

-- =============================================================================
-- TABLE : maintenance_status_history
-- Description :
-- Stores the complete lifecycle history of maintenance requests.
-- =============================================================================

CREATE TABLE maintenance_status_history
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    maintenance_request_id BIGINT NOT NULL,

    -- Status Information
    previous_status ENUM(
        'OPEN',
        'ASSIGNED',
        'IN_PROGRESS',
        'ON_HOLD',
        'COMPLETED',
        'CANCELLED',
        'REJECTED'
    ),

    current_status ENUM(
        'OPEN',
        'ASSIGNED',
        'IN_PROGRESS',
        'ON_HOLD',
        'COMPLETED',
        'CANCELLED',
        'REJECTED'
    ) NOT NULL,

    status_changed_by_uuid CHAR(36) NOT NULL,

    status_changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    remarks VARCHAR(500),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_maintenance_status_history
        PRIMARY KEY (id),

    CONSTRAINT uk_maintenance_status_history_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_maintenance_status_history_request_id
        FOREIGN KEY (maintenance_request_id)
        REFERENCES maintenance_requests(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores maintenance request status history';

-- =============================================================================
-- TABLE : maintenance_assignments
-- Description :
-- Stores assignment history of maintenance requests.
-- =============================================================================

CREATE TABLE maintenance_assignments
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    maintenance_request_id BIGINT NOT NULL,

    -- Assignment Details
    assigned_to_uuid CHAR(36) NOT NULL,

    assigned_by_uuid CHAR(36) NOT NULL,

    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    assignment_status ENUM(
        'ASSIGNED',
        'ACCEPTED',
        'REJECTED',
        'REASSIGNED',
        'COMPLETED'
    ) NOT NULL DEFAULT 'ASSIGNED',

    remarks VARCHAR(500),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_maintenance_assignments
        PRIMARY KEY (id),

    CONSTRAINT uk_maintenance_assignments_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_maintenance_assignments_request_id
        FOREIGN KEY (maintenance_request_id)
        REFERENCES maintenance_requests(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores maintenance assignment history';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_maintenance_status_history_request_id
    ON maintenance_status_history(maintenance_request_id);

CREATE INDEX idx_maintenance_status_history_current_status
    ON maintenance_status_history(current_status);

CREATE INDEX idx_maintenance_status_history_changed_by
    ON maintenance_status_history(status_changed_by_uuid);

CREATE INDEX idx_maintenance_status_history_changed_at
    ON maintenance_status_history(status_changed_at);

CREATE INDEX idx_maintenance_assignments_request_id
    ON maintenance_assignments(maintenance_request_id);

CREATE INDEX idx_maintenance_assignments_assigned_to
    ON maintenance_assignments(assigned_to_uuid);

CREATE INDEX idx_maintenance_assignments_assigned_by
    ON maintenance_assignments(assigned_by_uuid);

CREATE INDEX idx_maintenance_assignments_status
    ON maintenance_assignments(assignment_status);

CREATE INDEX idx_maintenance_assignments_assigned_at
    ON maintenance_assignments(assigned_at);

CREATE INDEX idx_maintenance_assignments_is_active
    ON maintenance_assignments(is_active);

-- =============================================================================
-- TABLE : maintenance_attachments
-- Description :
-- Stores metadata of attachments associated with maintenance requests.
-- =============================================================================

CREATE TABLE maintenance_attachments
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    maintenance_request_id BIGINT NOT NULL,

    -- Attachment Information
    attachment_name VARCHAR(150) NOT NULL,

    attachment_type ENUM(
        'IMAGE',
        'VIDEO',
        'DOCUMENT',
        'AUDIO',
        'OTHER'
    ) NOT NULL,

    attachment_url VARCHAR(500) NOT NULL,

    uploaded_by_uuid CHAR(36) NOT NULL,

    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

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
    CONSTRAINT pk_maintenance_attachments
        PRIMARY KEY (id),

    CONSTRAINT uk_maintenance_attachments_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_maintenance_attachments_request_id
        FOREIGN KEY (maintenance_request_id)
        REFERENCES maintenance_requests(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores maintenance attachment metadata';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_maintenance_attachments_request_id
    ON maintenance_attachments(maintenance_request_id);

CREATE INDEX idx_maintenance_attachments_type
    ON maintenance_attachments(attachment_type);

CREATE INDEX idx_maintenance_attachments_uploaded_by
    ON maintenance_attachments(uploaded_by_uuid);

CREATE INDEX idx_maintenance_attachments_uploaded_at
    ON maintenance_attachments(uploaded_at);

CREATE INDEX idx_maintenance_attachments_is_active
    ON maintenance_attachments(is_active);

