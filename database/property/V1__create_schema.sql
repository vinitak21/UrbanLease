/*
===============================================================================
 Project      : UrbanLease
 Module       : Property Service
 Database     : urbanlease_property
 Script       : V1__create_schema.sql
 
 Description:
 Creates the Property database schema.
===============================================================================
*/

-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_property
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_property;

-- =============================================================================
-- TABLE : properties
-- Description :
-- Stores rental property information.
-- =============================================================================

CREATE TABLE properties
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service Reference
    owner_uuid CHAR(36) NOT NULL,

    -- Property Information
    property_title VARCHAR(150) NOT NULL,
    property_description TEXT,

    property_type ENUM(
        'APARTMENT',
        'HOUSE',
        'VILLA',
        'PG',
        'HOSTEL',
        'COMMERCIAL',
        'OTHER'
    ) NOT NULL,

    furnishing_type ENUM(
        'UNFURNISHED',
        'SEMI_FURNISHED',
        'FULLY_FURNISHED'
    ) NOT NULL,

    property_status ENUM(
        'AVAILABLE',
        'OCCUPIED',
        'UNDER_MAINTENANCE',
        'INACTIVE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    -- Property Specifications
    bedrooms INT NOT NULL DEFAULT 0,
    bathrooms INT NOT NULL DEFAULT 0,
    balconies INT NOT NULL DEFAULT 0,

    carpet_area DECIMAL(10,2) NOT NULL,
    builtup_area DECIMAL(10,2),

    floor_number INT,
    total_floors INT,

    -- Pricing
    monthly_rent DECIMAL(12,2) NOT NULL,
    security_deposit DECIMAL(12,2) NOT NULL,
    maintenance_charge DECIMAL(12,2) DEFAULT 0.00,

    -- Availability
    available_from DATE,

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_properties
        PRIMARY KEY (id),

    CONSTRAINT uk_properties_uuid
        UNIQUE (uuid)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores rental property information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_properties_uuid
    ON properties(uuid);

CREATE INDEX idx_properties_owner_uuid
    ON properties(owner_uuid);

CREATE INDEX idx_properties_property_type
    ON properties(property_type);

CREATE INDEX idx_properties_property_status
    ON properties(property_status);

CREATE INDEX idx_properties_monthly_rent
    ON properties(monthly_rent);

CREATE INDEX idx_properties_available_from
    ON properties(available_from);

CREATE INDEX idx_properties_is_active
    ON properties(is_active);

-- =============================================================================
-- TABLE : property_images
-- Description :
-- Stores image metadata for rental properties.
-- =============================================================================

CREATE TABLE property_images
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    property_id BIGINT NOT NULL,

    -- Image Details
    image_url VARCHAR(500) NOT NULL,

    image_title VARCHAR(150),

    display_order INT NOT NULL DEFAULT 1,

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_property_images
        PRIMARY KEY (id),

    CONSTRAINT uk_property_images_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_property_images_property_id
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores property image metadata';

-- =============================================================================
-- TABLE : property_amenities
-- Description :
-- Stores amenities available in a property.
-- =============================================================================

CREATE TABLE property_amenities
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    property_id BIGINT NOT NULL,

    -- Amenity Details
    amenity_name VARCHAR(100) NOT NULL,

    description VARCHAR(255),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_property_amenities
        PRIMARY KEY (id),

    CONSTRAINT uk_property_amenities_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_property_amenities_property_amenity
        UNIQUE (property_id, amenity_name),

    CONSTRAINT fk_property_amenities_property_id
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores property amenities';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_property_images_property_id
    ON property_images(property_id);

CREATE INDEX idx_property_images_display_order
    ON property_images(display_order);

CREATE INDEX idx_property_images_is_primary
    ON property_images(is_primary);

CREATE INDEX idx_property_images_is_active
    ON property_images(is_active);

CREATE INDEX idx_property_amenities_property_id
    ON property_amenities(property_id);

CREATE INDEX idx_property_amenities_amenity_name
    ON property_amenities(amenity_name);

CREATE INDEX idx_property_amenities_is_active
    ON property_amenities(is_active);

-- =============================================================================
-- TABLE : property_documents
-- Description :
-- Stores document metadata associated with a property.
-- =============================================================================

CREATE TABLE property_documents
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    property_id BIGINT NOT NULL,

    -- Document Information
    document_name VARCHAR(150) NOT NULL,

    document_type ENUM(
        'OWNERSHIP_PROOF',
        'IDENTITY_PROOF',
        'PROPERTY_TAX_RECEIPT',
        'ELECTRICITY_BILL',
        'RENT_AGREEMENT',
        'OTHER'
    ) NOT NULL,

    document_url VARCHAR(500) NOT NULL,

    verification_status ENUM(
        'PENDING',
        'VERIFIED',
        'REJECTED'
    ) NOT NULL DEFAULT 'PENDING',

    remarks VARCHAR(255),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_property_documents
        PRIMARY KEY (id),

    CONSTRAINT uk_property_documents_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_property_documents_property_id
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores property document metadata';

-- =============================================================================
-- TABLE : property_availability
-- Description :
-- Stores current availability information of a property.
-- =============================================================================

CREATE TABLE property_availability
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    property_id BIGINT NOT NULL,

    -- Availability Details
    availability_status ENUM(
        'AVAILABLE',
        'BOOKED',
        'BLOCKED',
        'UNDER_MAINTENANCE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    available_from DATE,

    available_to DATE,

    remarks VARCHAR(255),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_property_availability
        PRIMARY KEY (id),

    CONSTRAINT uk_property_availability_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_property_availability_property_id
        UNIQUE (property_id),

    CONSTRAINT fk_property_availability_property_id
        FOREIGN KEY (property_id)
        REFERENCES properties(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores property availability information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_property_documents_property_id
    ON property_documents(property_id);

CREATE INDEX idx_property_documents_document_type
    ON property_documents(document_type);

CREATE INDEX idx_property_documents_verification_status
    ON property_documents(verification_status);

CREATE INDEX idx_property_documents_is_active
    ON property_documents(is_active);

CREATE INDEX idx_property_availability_property_id
    ON property_availability(property_id);

CREATE INDEX idx_property_availability_status
    ON property_availability(availability_status);

CREATE INDEX idx_property_availability_available_from
    ON property_availability(available_from);

CREATE INDEX idx_property_availability_available_to
    ON property_availability(available_to);

CREATE INDEX idx_property_availability_is_active
    ON property_availability(is_active);

