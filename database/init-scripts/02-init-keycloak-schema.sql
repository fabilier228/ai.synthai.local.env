-- Adding full rights to create tables in the database for Keycloak
-- Creating a dedicated schema and setting the owner
-- We are working in the Keycloak database
\connect keycloak_db

-- Schema belonging to the Keycloak user
CREATE SCHEMA IF NOT EXISTS keycloak AUTHORIZATION keycloak_user;