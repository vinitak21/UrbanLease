/*
===============================================================================
 Project      : UrbanLease
 Module       : Document Service
 Database     : urbanlease_document
 Script       : V1__create_schema.sql

 Description:
 Creates the Document database schema.
===============================================================================
*/
-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_document
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_document;

-- =============================================================================
-- TABLE : documents
-- Description :
-- Stores metadata of uploaded documents.
-- =============================================================================

CREATE TABLE documents
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service References
    owner_uuid CHAR(36) NOT NULL,

    entity_uuid CHAR(36) NOT NULL,

    entity_type ENUM(
        'USER',
        'PROPERTY',
        'BOOKING',
        'PAYMENT',
        'MAINTENANCE',
        'AI'
    ) NOT NULL,

    -- Document Information
    document_reference VARCHAR(50) NOT NULL,

    document_category ENUM(
        'PROFILE_IMAGE',
        'PROPERTY_IMAGE',
        'PROPERTY_DOCUMENT',
        'IDENTITY_PROOF',
        'RENTAL_AGREEMENT',
        'PAYMENT_RECEIPT',
        'MAINTENANCE_IMAGE',
        'AI_REPORT',
        'OTHER'
    ) NOT NULL,

    document_name VARCHAR(255) NOT NULL,

    original_file_name VARCHAR(255) NOT NULL,

    mime_type VARCHAR(100) NOT NULL,

    file_extension VARCHAR(20) NOT NULL,

    file_size BIGINT NOT NULL,

    storage_provider ENUM(
        'LOCAL',
        'MINIO',
        'AWS_S3',
        'AZURE_BLOB',
        'GOOGLE_CLOUD_STORAGE'
    ) NOT NULL DEFAULT 'LOCAL',

    storage_path VARCHAR(500) NOT NULL,

    checksum VARCHAR(128),

    document_status ENUM(
        'UPLOADED',
        'ACTIVE',
        'ARCHIVED',
        'DELETED'
    ) NOT NULL DEFAULT 'UPLOADED',

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
    CONSTRAINT pk_documents
        PRIMARY KEY (id),

    CONSTRAINT uk_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_documents_reference
        UNIQUE (document_reference)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores uploaded document metadata';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_documents_uuid
    ON documents(uuid);

CREATE INDEX idx_documents_owner_uuid
    ON documents(owner_uuid);

CREATE INDEX idx_documents_entity_uuid
    ON documents(entity_uuid);

CREATE INDEX idx_documents_entity_type
    ON documents(entity_type);

CREATE INDEX idx_documents_reference
    ON documents(document_reference);

CREATE INDEX idx_documents_category
    ON documents(document_category);

CREATE INDEX idx_documents_storage_provider
    ON documents(storage_provider);

CREATE INDEX idx_documents_status
    ON documents(document_status);

CREATE INDEX idx_documents_created_at
    ON documents(created_at);

CREATE INDEX idx_documents_is_active
    ON documents(is_active);

-- =============================================================================
-- TABLE : document_versions
-- Description :
-- Stores version history of uploaded documents.
-- =============================================================================

CREATE TABLE document_versions
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    document_id BIGINT NOT NULL,

    -- Version Information
    version_number INT NOT NULL,

    file_name VARCHAR(255) NOT NULL,

    storage_path VARCHAR(500) NOT NULL,

    file_size BIGINT NOT NULL,

    checksum VARCHAR(128),

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
    CONSTRAINT pk_document_versions
        PRIMARY KEY (id),

    CONSTRAINT uk_document_versions_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_document_versions_document_version
        UNIQUE (document_id, version_number),

    CONSTRAINT fk_document_versions_document_id
        FOREIGN KEY (document_id)
        REFERENCES documents(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Stores document version history';

-- =============================================================================
-- TABLE : document_shares
-- Description :
-- Stores document sharing information.
-- =============================================================================

CREATE TABLE document_shares
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    document_id BIGINT NOT NULL,

    -- Sharing Information
    shared_by_uuid CHAR(36) NOT NULL,

    shared_with_uuid CHAR(36) NOT NULL,

    permission ENUM(
        'VIEW',
        'DOWNLOAD',
        'EDIT'
    ) NOT NULL DEFAULT 'VIEW',

    shared_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expiry_date DATETIME,

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
    CONSTRAINT pk_document_shares
        PRIMARY KEY (id),

    CONSTRAINT uk_document_shares_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_document_shares_document_id
        FOREIGN KEY (document_id)
        REFERENCES documents(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Stores document sharing information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_document_versions_document_id
    ON document_versions(document_id);

CREATE INDEX idx_document_versions_version_number
    ON document_versions(version_number);

CREATE INDEX idx_document_versions_uploaded_by
    ON document_versions(uploaded_by_uuid);

CREATE INDEX idx_document_versions_uploaded_at
    ON document_versions(uploaded_at);

CREATE INDEX idx_document_versions_is_active
    ON document_versions(is_active);

CREATE INDEX idx_document_shares_document_id
    ON document_shares(document_id);

CREATE INDEX idx_document_shares_shared_by
    ON document_shares(shared_by_uuid);

CREATE INDEX idx_document_shares_shared_with
    ON document_shares(shared_with_uuid);

CREATE INDEX idx_document_shares_permission
    ON document_shares(permission);

CREATE INDEX idx_document_shares_expiry_date
    ON document_shares(expiry_date);

CREATE INDEX idx_document_shares_is_active
    ON document_shares(is_active);

-- =============================================================================
-- TABLE : document_access_history
-- Description :
-- Stores audit history of every document access.
-- =============================================================================

CREATE TABLE document_access_history
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    document_id BIGINT NOT NULL,

    -- User Information
    user_uuid CHAR(36) NOT NULL,

    -- Access Information
    access_action ENUM(
        'VIEW',
        'DOWNLOAD',
        'UPLOAD',
        'UPDATE',
        'DELETE',
        'RESTORE',
        'SHARE'
    ) NOT NULL,

    access_status ENUM(
        'SUCCESS',
        'FAILED'
    ) NOT NULL DEFAULT 'SUCCESS',

    ip_address VARCHAR(45),

    user_agent VARCHAR(500),

    accessed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    remarks VARCHAR(255),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_document_access_history
        PRIMARY KEY (id),

    CONSTRAINT uk_document_access_history_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_document_access_history_document_id
        FOREIGN KEY (document_id)
        REFERENCES documents(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores document access history';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_document_access_history_document_id
    ON document_access_history(document_id);

CREATE INDEX idx_document_access_history_user_uuid
    ON document_access_history(user_uuid);

CREATE INDEX idx_document_access_history_action
    ON document_access_history(access_action);

CREATE INDEX idx_document_access_history_status
    ON document_access_history(access_status);

CREATE INDEX idx_document_access_history_accessed_at
    ON document_access_history(accessed_at);
    
CREATE INDEX idx_document_access_history_created_at
    ON document_access_history(created_at);
