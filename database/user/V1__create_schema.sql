/*
===============================================================================
 Project      : UrbanLease
 Module       : User Service
 Database     : urbanlease_user
 Script       : V1__create_schema.sql
 
 Description:
 Creates the User database schema.
===============================================================================
*/

-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_user
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_user;

-- =============================================================================
-- TABLE : users
-- Description :
-- Stores user profile information.
-- =============================================================================

CREATE TABLE users
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Reference to Auth Service
    credential_uuid CHAR(36) NOT NULL,

    -- Personal Information
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,

    gender ENUM('MALE','FEMALE','OTHER') NOT NULL,

    date_of_birth DATE,

    profile_image_url VARCHAR(500),

    -- Contact Information
    phone_number VARCHAR(20) NOT NULL,
    alternate_phone_number VARCHAR(20),

    -- Profile Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    profile_completed BOOLEAN NOT NULL DEFAULT FALSE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_users
        PRIMARY KEY (id),

    CONSTRAINT uk_users_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_users_credential_uuid
        UNIQUE (credential_uuid),

    CONSTRAINT uk_users_phone_number
        UNIQUE (phone_number)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores user profile information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_users_uuid
    ON users (uuid);

CREATE INDEX idx_users_credential_uuid
    ON users (credential_uuid);

CREATE INDEX idx_users_first_name
    ON users (first_name);

CREATE INDEX idx_users_last_name
    ON users (last_name);

CREATE INDEX idx_users_phone_number
    ON users (phone_number);

CREATE INDEX idx_users_is_active
    ON users (is_active);

CREATE INDEX idx_users_profile_completed
    ON users (profile_completed);

-- =============================================================================
-- TABLE : addresses
-- Description :
-- Stores address information for users.
-- =============================================================================

CREATE TABLE addresses
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    user_id BIGINT NOT NULL,

    -- Address Details
    address_type ENUM('PERMANENT','CURRENT','OFFICE','OTHER') NOT NULL,

    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),

    landmark VARCHAR(150),

    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,

    postal_code VARCHAR(20) NOT NULL,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_addresses
        PRIMARY KEY (id),

    CONSTRAINT uk_addresses_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_addresses_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores user addresses';

-- =============================================================================
-- TABLE : emergency_contacts
-- Description :
-- Stores emergency contact information for users.
-- =============================================================================

CREATE TABLE emergency_contacts
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    user_id BIGINT NOT NULL,

    -- Contact Information
    full_name VARCHAR(150) NOT NULL,

    relationship VARCHAR(100) NOT NULL,

    phone_number VARCHAR(20) NOT NULL,

    email VARCHAR(255),

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_emergency_contacts
        PRIMARY KEY (id),

    CONSTRAINT uk_emergency_contacts_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_emergency_contacts_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores emergency contact information';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_addresses_user_id
    ON addresses(user_id);

CREATE INDEX idx_addresses_address_type
    ON addresses(address_type);

CREATE INDEX idx_addresses_city
    ON addresses(city);

CREATE INDEX idx_addresses_state
    ON addresses(state);

CREATE INDEX idx_addresses_country
    ON addresses(country);

CREATE INDEX idx_addresses_postal_code
    ON addresses(postal_code);

CREATE INDEX idx_addresses_is_default
    ON addresses(is_default);

CREATE INDEX idx_addresses_is_active
    ON addresses(is_active);

CREATE INDEX idx_emergency_contacts_user_id
    ON emergency_contacts(user_id);

CREATE INDEX idx_emergency_contacts_phone_number
    ON emergency_contacts(phone_number);

CREATE INDEX idx_emergency_contacts_relationship
    ON emergency_contacts(relationship);

CREATE INDEX idx_emergency_contacts_is_primary
    ON emergency_contacts(is_primary);

CREATE INDEX idx_emergency_contacts_is_active
    ON emergency_contacts(is_active);

-- =============================================================================
-- TABLE : user_preferences
-- Description :
-- Stores application preferences and settings for users.
-- =============================================================================

CREATE TABLE user_preferences
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    user_id BIGINT NOT NULL,

    -- Language & Time Zone
    language VARCHAR(20) NOT NULL DEFAULT 'en',
    timezone VARCHAR(100) NOT NULL DEFAULT 'Asia/Kolkata',

    -- Notification Preferences
    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    sms_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    push_notifications BOOLEAN NOT NULL DEFAULT TRUE,

    -- Application Preferences
    dark_mode BOOLEAN NOT NULL DEFAULT FALSE,

    -- Profile Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_user_preferences
        PRIMARY KEY (id),

    CONSTRAINT uk_user_preferences_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_user_preferences_user_id
        UNIQUE (user_id),

    CONSTRAINT fk_user_preferences_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores user preferences';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_user_preferences_user_id
    ON user_preferences(user_id);

CREATE INDEX idx_user_preferences_language
    ON user_preferences(language);

CREATE INDEX idx_user_preferences_timezone
    ON user_preferences(timezone);

CREATE INDEX idx_user_preferences_is_active
    ON user_preferences(is_active);

