/*
===============================================================================
 Project      : UrbanLease
 Module       : Authentication Service
 Database     : urbanlease_auth
 Script       : V1__create_schema.sql

 Description:
 Creates the Authentication database schema.
===============================================================================
*/
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_auth
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_auth;

-- =============================================================================
-- TABLE : roles
-- Description :
-- Stores all application roles.
-- =============================================================================

CREATE TABLE roles
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Business Columns
    role_name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_roles
        PRIMARY KEY (id),

    CONSTRAINT uk_roles_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_roles_role_name
        UNIQUE (role_name)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores application roles';

-- =============================================================================
-- TABLE : permissions
-- Description :
-- Stores all permissions available in the system.
-- =============================================================================

CREATE TABLE permissions
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Business Columns
    permission_name VARCHAR(100) NOT NULL,
    module_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_permissions
        PRIMARY KEY (id),

    CONSTRAINT uk_permissions_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_permissions_permission_name
        UNIQUE (permission_name)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores system permissions';

-- =============================================================================
-- TABLE : role_permissions
-- Description :
-- Maps Roles to Permissions.

-- One Role        → Multiple Permissions
-- One Permission  → Multiple Roles
-- =============================================================================

CREATE TABLE role_permissions
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Keys
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_role_permissions
        PRIMARY KEY (id),

    CONSTRAINT uk_role_permissions_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_role_permissions_role_permission
        UNIQUE (role_id, permission_id),

    CONSTRAINT fk_role_permissions_role_id
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_role_permissions_permission_id
        FOREIGN KEY (permission_id)
        REFERENCES permissions(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Maps roles to permissions';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_roles_uuid
    ON roles (uuid);

CREATE INDEX idx_roles_is_active
    ON roles (is_active);

CREATE INDEX idx_permissions_uuid
    ON permissions (uuid);

CREATE INDEX idx_permissions_module_name
    ON permissions (module_name);

CREATE INDEX idx_permissions_is_active
    ON permissions (is_active);

CREATE INDEX idx_role_permissions_role_id
    ON role_permissions (role_id);

CREATE INDEX idx_role_permissions_permission_id
    ON role_permissions (permission_id);

-- =============================================================================
-- TABLE : credentials
-- Description :
-- Stores user authentication credentials and account status.
-- =============================================================================

CREATE TABLE credentials
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Authentication Details
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    -- Authorization
    role_id BIGINT NOT NULL,

    -- Account Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    account_locked BOOLEAN NOT NULL DEFAULT FALSE,
    account_expired BOOLEAN NOT NULL DEFAULT FALSE,
    credentials_expired BOOLEAN NOT NULL DEFAULT FALSE,

    -- Security Information
    failed_login_attempts INT NOT NULL DEFAULT 0,
    last_login_at DATETIME NULL,
    last_password_changed_at DATETIME NULL,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_credentials
        PRIMARY KEY (id),

    CONSTRAINT uk_credentials_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_credentials_email
        UNIQUE (email),

    CONSTRAINT fk_credentials_role_id
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores user authentication credentials';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_credentials_uuid
    ON credentials (uuid);

CREATE INDEX idx_credentials_role_id
    ON credentials (role_id);

CREATE INDEX idx_credentials_is_active
    ON credentials (is_active);

CREATE INDEX idx_credentials_email_verified
    ON credentials (email_verified);

CREATE INDEX idx_credentials_account_locked
    ON credentials (account_locked);

CREATE INDEX idx_credentials_last_login_at
    ON credentials (last_login_at);

-- =============================================================================
-- TABLE : refresh_tokens
-- Description :
-- Stores refresh tokens issued after successful authentication.
-- =============================================================================

CREATE TABLE refresh_tokens
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    credential_id BIGINT NOT NULL,

    -- Token Information
    token VARCHAR(512) NOT NULL,
    expires_at DATETIME NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    revoked_at DATETIME NULL,

    -- Device Information
    device_name VARCHAR(150),
    device_ip VARCHAR(45),
    user_agent VARCHAR(500),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_refresh_tokens
        PRIMARY KEY (id),

    CONSTRAINT uk_refresh_tokens_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_refresh_tokens_token
        UNIQUE (token),

    CONSTRAINT fk_refresh_tokens_credential_id
        FOREIGN KEY (credential_id)
        REFERENCES credentials(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores JWT refresh tokens';

-- =============================================================================
-- TABLE : password_reset_tokens
-- Description :
-- Stores password reset tokens.
-- =============================================================================

CREATE TABLE password_reset_tokens
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    credential_id BIGINT NOT NULL,

    -- Token Information
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    used_at DATETIME NULL,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_password_reset_tokens
        PRIMARY KEY (id),

    CONSTRAINT uk_password_reset_tokens_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_password_reset_tokens_token
        UNIQUE (token),

    CONSTRAINT fk_password_reset_tokens_credential_id
        FOREIGN KEY (credential_id)
        REFERENCES credentials(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores password reset tokens';

-- =============================================================================
-- TABLE : email_verification_tokens
-- Description :
-- Stores email verification tokens.
-- =============================================================================

CREATE TABLE email_verification_tokens
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    credential_id BIGINT NOT NULL,

    -- Token Information
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    used_at DATETIME NULL,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_email_verification_tokens
        PRIMARY KEY (id),

    CONSTRAINT uk_email_verification_tokens_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_email_verification_tokens_token
        UNIQUE (token),

    CONSTRAINT fk_email_verification_tokens_credential_id
        FOREIGN KEY (credential_id)
        REFERENCES credentials(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores email verification tokens';

-- =============================================================================
-- TABLE : login_audit
-- Description :
-- Stores login history for auditing and security monitoring.
-- =============================================================================

CREATE TABLE login_audit
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    credential_id BIGINT NOT NULL,

    -- Login Details
    login_time DATETIME NOT NULL,
    logout_time DATETIME NULL,

    login_status VARCHAR(20) NOT NULL,

    failure_reason VARCHAR(255),

    device_name VARCHAR(150),

    ip_address VARCHAR(45),

    user_agent VARCHAR(500),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_login_audit
        PRIMARY KEY (id),

    CONSTRAINT uk_login_audit_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_login_audit_credential_id
        FOREIGN KEY (credential_id)
        REFERENCES credentials(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores login audit history';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_refresh_tokens_credential_id
    ON refresh_tokens (credential_id);

CREATE INDEX idx_refresh_tokens_expires_at
    ON refresh_tokens (expires_at);

CREATE INDEX idx_refresh_tokens_revoked
    ON refresh_tokens (revoked);

CREATE INDEX idx_password_reset_tokens_credential_id
    ON password_reset_tokens (credential_id);

CREATE INDEX idx_password_reset_tokens_expires_at
    ON password_reset_tokens (expires_at);

CREATE INDEX idx_password_reset_tokens_used
    ON password_reset_tokens (used);

CREATE INDEX idx_email_verification_tokens_credential_id
    ON email_verification_tokens (credential_id);

CREATE INDEX idx_email_verification_tokens_expires_at
    ON email_verification_tokens (expires_at);

CREATE INDEX idx_email_verification_tokens_used
    ON email_verification_tokens (used);

CREATE INDEX idx_login_audit_credential_id
    ON login_audit (credential_id);

CREATE INDEX idx_login_audit_login_time
    ON login_audit (login_time);

CREATE INDEX idx_login_audit_login_status
    ON login_audit (login_status);

