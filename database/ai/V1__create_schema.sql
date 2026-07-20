/*
===============================================================================
 Project      : UrbanLease
 Module       : AI Service
 Database     : urbanlease_ai
 Script       : V1__create_schema.sql

 Description:
 Creates the AI database schema.
===============================================================================
*/
-- =============================================================================
-- Create Database
-- =============================================================================

CREATE DATABASE urbanlease_ai
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE urbanlease_ai;

-- =============================================================================
-- TABLE : ai_conversations
-- Description :
-- Stores AI conversation sessions.
-- =============================================================================

CREATE TABLE ai_conversations
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Cross-Service Reference
    user_uuid CHAR(36) NOT NULL,

    -- Conversation Information
    conversation_title VARCHAR(255),

    conversation_type ENUM(
        'PROPERTY_ASSISTANT',
        'BOOKING_ASSISTANT',
        'PAYMENT_ASSISTANT',
        'MAINTENANCE_ASSISTANT',
        'LEASE_ASSISTANT',
        'GENERAL_ASSISTANT'
    ) NOT NULL DEFAULT 'GENERAL_ASSISTANT',

    conversation_status ENUM(
        'ACTIVE',
        'ARCHIVED',
        'CLOSED'
    ) NOT NULL DEFAULT 'ACTIVE',

    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    ended_at DATETIME,

    total_messages INT NOT NULL DEFAULT 0,

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_ai_conversations
        PRIMARY KEY (id),

    CONSTRAINT uk_ai_conversations_uuid
        UNIQUE (uuid)

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores AI conversation sessions';

-- =============================================================================
-- TABLE : ai_messages
-- Description :
-- Stores every prompt and AI response exchanged during a conversation.
-- =============================================================================

CREATE TABLE ai_messages
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    conversation_id BIGINT NOT NULL,

    -- Message Information
    message_sequence INT NOT NULL,

    sender_type ENUM(
        'USER',
        'AI'
    ) NOT NULL,

    message_type ENUM(
        'TEXT',
        'IMAGE',
        'DOCUMENT',
        'SYSTEM'
    ) NOT NULL DEFAULT 'TEXT',

    message_content LONGTEXT NOT NULL,

    ai_model VARCHAR(100),

    prompt_tokens INT DEFAULT 0,

    completion_tokens INT DEFAULT 0,

    total_tokens INT DEFAULT 0,

    response_time_ms BIGINT,

    message_status ENUM(
        'SUCCESS',
        'FAILED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'SUCCESS',

    error_message VARCHAR(500),

    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_ai_messages
        PRIMARY KEY (id),

    CONSTRAINT uk_ai_messages_uuid
        UNIQUE (uuid),

    CONSTRAINT uk_ai_messages_sequence
        UNIQUE (conversation_id, message_sequence),

    CONSTRAINT fk_ai_messages_conversation_id
        FOREIGN KEY (conversation_id)
        REFERENCES ai_conversations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores AI conversation messages';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_ai_conversations_user_uuid
    ON ai_conversations(user_uuid);

CREATE INDEX idx_ai_conversations_type
    ON ai_conversations(conversation_type);

CREATE INDEX idx_ai_conversations_status
    ON ai_conversations(conversation_status);

CREATE INDEX idx_ai_conversations_started_at
    ON ai_conversations(started_at);

CREATE INDEX idx_ai_conversations_is_active
    ON ai_conversations(is_active);

CREATE INDEX idx_ai_messages_conversation_id
    ON ai_messages(conversation_id);

CREATE INDEX idx_ai_messages_sender_type
    ON ai_messages(sender_type);

CREATE INDEX idx_ai_messages_message_type
    ON ai_messages(message_type);

CREATE INDEX idx_ai_messages_status
    ON ai_messages(message_status);

CREATE INDEX idx_ai_messages_generated_at
    ON ai_messages(generated_at);

-- =============================================================================
-- TABLE : ai_recommendations
-- Description :
-- Stores AI-generated recommendations for users.
-- =============================================================================

CREATE TABLE ai_recommendations
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    conversation_id BIGINT NOT NULL,

    -- Recommendation Information
    recommendation_type ENUM(
        'PROPERTY',
        'BOOKING',
        'PAYMENT',
        'MAINTENANCE',
        'LEASE',
        'GENERAL'
    ) NOT NULL,

    recommendation_title VARCHAR(255) NOT NULL,

    recommendation_details TEXT NOT NULL,

    confidence_score DECIMAL(5,2),

    recommendation_status ENUM(
        'GENERATED',
        'ACCEPTED',
        'REJECTED',
        'EXPIRED'
    ) NOT NULL DEFAULT 'GENERATED',

    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expires_at DATETIME,

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
    CONSTRAINT pk_ai_recommendations
        PRIMARY KEY (id),

    CONSTRAINT uk_ai_recommendations_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_ai_recommendations_conversation_id
        FOREIGN KEY (conversation_id)
        REFERENCES ai_conversations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores AI-generated recommendations';

-- =============================================================================
-- TABLE : ai_execution_history
-- Description :
-- Stores AI model execution history.
-- =============================================================================

CREATE TABLE ai_execution_history
(
    -- Primary Key
    id BIGINT AUTO_INCREMENT,

    -- Public Identifier
    uuid CHAR(36) NOT NULL,

    -- Foreign Key
    conversation_id BIGINT NOT NULL,

    -- Execution Information
    model_name VARCHAR(100) NOT NULL,

    model_version VARCHAR(50),

    provider ENUM(
        'OPENAI',
        'AZURE_OPENAI',
        'OLLAMA',
        'GEMINI',
        'CLAUDE',
        'OTHER'
    ) NOT NULL,

    execution_status ENUM(
        'SUCCESS',
        'FAILED',
        'TIMEOUT',
        'CANCELLED'
    ) NOT NULL,

    prompt_tokens INT NOT NULL DEFAULT 0,

    completion_tokens INT NOT NULL DEFAULT 0,

    total_tokens INT NOT NULL DEFAULT 0,

    execution_time_ms BIGINT,

    request_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    response_timestamp DATETIME,

    error_message VARCHAR(500),

    -- Audit Columns
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100),

    updated_by VARCHAR(100),

    -- Constraints
    CONSTRAINT pk_ai_execution_history
        PRIMARY KEY (id),

    CONSTRAINT uk_ai_execution_history_uuid
        UNIQUE (uuid),

    CONSTRAINT fk_ai_execution_history_conversation_id
        FOREIGN KEY (conversation_id)
        REFERENCES ai_conversations(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci
COMMENT = 'Stores AI execution history';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX idx_ai_recommendations_conversation_id
    ON ai_recommendations(conversation_id);

CREATE INDEX idx_ai_recommendations_type
    ON ai_recommendations(recommendation_type);

CREATE INDEX idx_ai_recommendations_status
    ON ai_recommendations(recommendation_status);

CREATE INDEX idx_ai_recommendations_generated_at
    ON ai_recommendations(generated_at);

CREATE INDEX idx_ai_recommendations_is_active
    ON ai_recommendations(is_active);

CREATE INDEX idx_ai_execution_history_conversation_id
    ON ai_execution_history(conversation_id);

CREATE INDEX idx_ai_execution_history_model_name
    ON ai_execution_history(model_name);

CREATE INDEX idx_ai_execution_history_provider
    ON ai_execution_history(provider);

CREATE INDEX idx_ai_execution_history_status
    ON ai_execution_history(execution_status);

CREATE INDEX idx_ai_execution_history_request_timestamp
    ON ai_execution_history(request_timestamp);
