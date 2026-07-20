/*
===============================================================================
 Project      : UrbanLease
 Module       : Authentication Service
 Database     : urbanlease_auth
 Script       : V2__seed_data.sql
 
 Description:
 Inserts default master data required by the Authentication Service.

 Seed Data
 ---------
 1. Roles
 2. Permissions
 3. Role-Permission Mapping
 4. Default Super Admin

===============================================================================
*/

USE urbanlease_auth;

-- =============================================================================
-- ROLES
-- =============================================================================

INSERT INTO roles
(
    uuid,
    role_name,
    description,
    is_active,
    created_by
)
VALUES
(UUID(), 'SUPER_ADMIN', 'System Super Administrator', TRUE, 'SYSTEM'),
(UUID(), 'ADMIN',        'Application Administrator', TRUE, 'SYSTEM'),
(UUID(), 'OWNER',        'Property Owner',            TRUE, 'SYSTEM'),
(UUID(), 'TENANT',       'Property Tenant',           TRUE, 'SYSTEM');

-- =============================================================================
-- PERMISSIONS
-- =============================================================================

INSERT INTO permissions
(
    uuid,
    permission_name,
    module_name,
    description,
    is_active,
    created_by
)
VALUES

-- AUTH MODULE
(UUID(),'AUTH_LOGIN','AUTH','User Login',TRUE,'SYSTEM'),
(UUID(),'AUTH_LOGOUT','AUTH','User Logout',TRUE,'SYSTEM'),
(UUID(),'AUTH_REFRESH_TOKEN','AUTH','Refresh JWT Token',TRUE,'SYSTEM'),
(UUID(),'AUTH_RESET_PASSWORD','AUTH','Reset Password',TRUE,'SYSTEM'),

-- USER MODULE
(UUID(),'USER_CREATE','USER','Create User',TRUE,'SYSTEM'),
(UUID(),'USER_READ','USER','View User',TRUE,'SYSTEM'),
(UUID(),'USER_UPDATE','USER','Update User',TRUE,'SYSTEM'),
(UUID(),'USER_DELETE','USER','Delete User',TRUE,'SYSTEM'),

-- PROPERTY MODULE
(UUID(),'PROPERTY_CREATE','PROPERTY','Create Property',TRUE,'SYSTEM'),
(UUID(),'PROPERTY_READ','PROPERTY','View Property',TRUE,'SYSTEM'),
(UUID(),'PROPERTY_UPDATE','PROPERTY','Update Property',TRUE,'SYSTEM'),
(UUID(),'PROPERTY_DELETE','PROPERTY','Delete Property',TRUE,'SYSTEM'),

-- BOOKING MODULE
(UUID(),'BOOKING_CREATE','BOOKING','Create Booking',TRUE,'SYSTEM'),
(UUID(),'BOOKING_READ','BOOKING','View Booking',TRUE,'SYSTEM'),
(UUID(),'BOOKING_UPDATE','BOOKING','Update Booking',TRUE,'SYSTEM'),
(UUID(),'BOOKING_CANCEL','BOOKING','Cancel Booking',TRUE,'SYSTEM'),

-- PAYMENT MODULE
(UUID(),'PAYMENT_CREATE','PAYMENT','Create Payment',TRUE,'SYSTEM'),
(UUID(),'PAYMENT_READ','PAYMENT','View Payment',TRUE,'SYSTEM'),
(UUID(),'PAYMENT_REFUND','PAYMENT','Refund Payment',TRUE,'SYSTEM'),

-- MAINTENANCE MODULE
(UUID(),'MAINTENANCE_CREATE','MAINTENANCE','Create Maintenance Request',TRUE,'SYSTEM'),
(UUID(),'MAINTENANCE_UPDATE','MAINTENANCE','Update Maintenance Request',TRUE,'SYSTEM'),
(UUID(),'MAINTENANCE_CLOSE','MAINTENANCE','Close Maintenance Request',TRUE,'SYSTEM');

-- =============================================================================
-- ROLE - PERMISSION MAPPING
-- SUPER_ADMIN gets all permissions.
-- =============================================================================

INSERT INTO role_permissions
(
    uuid,
    role_id,
    permission_id,
    created_by
)
SELECT
    UUID(),
    r.id,
    p.id,
    'SYSTEM'
FROM roles r
CROSS JOIN permissions p
WHERE r.role_name='SUPER_ADMIN';

-- =============================================================================
-- DEFAULT SUPER ADMIN ACCOUNT
-- Email    : admin@urbanlease.com
-- Password : Replace BCrypt hash before first login.
-- =============================================================================

INSERT INTO credentials
(
    uuid,
    email,
    password_hash,
    role_id,
    is_active,
    email_verified,
    account_locked,
    account_expired,
    credentials_expired,
    failed_login_attempts,
    created_by
)
SELECT
    UUID(),
    'admin@urbanlease.com',

    '$2a$10$REPLACE_WITH_BCRYPT_HASH',

    id,

    TRUE,
    TRUE,
    FALSE,
    FALSE,
    FALSE,

    0,

    'SYSTEM'

FROM roles
WHERE role_name='SUPER_ADMIN';

