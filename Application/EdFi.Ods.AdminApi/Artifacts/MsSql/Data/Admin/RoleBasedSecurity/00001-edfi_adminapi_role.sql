IF NOT EXISTS (SELECT TOP 1 1 FROM sys.database_principals WHERE name = 'edfi_adminapi_role' AND type = 'R')
    CREATE ROLE [edfi_adminapi_role] AUTHORIZATION [dbo]

GRANT INSERT, SELECT, UPDATE, DELETE ON SCHEMA::[adminapi] TO [edfi_adminapi_role]
GRANT INSERT, SELECT, UPDATE, DELETE ON SCHEMA::[dbo] TO [edfi_adminapi_role]
