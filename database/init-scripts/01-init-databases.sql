-- Database initialization for SynthAI Platform

-- Create Keycloak database
CREATE DATABASE keycloak_db;

-- Create users for Keycloak
CREATE USER keycloak_user WITH PASSWORD 'keycloak123';
GRANT ALL PRIVILEGES ON DATABASE keycloak_db TO keycloak_user;

-- Connect to main application database
\c synthai_db;

-- Initialization completed message
DO $$
BEGIN
    RAISE NOTICE 'SynthAI database initialization completed successfully!';
    RAISE NOTICE 'Database is ready for application setup.';
END $$;