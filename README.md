# Oracle Edition-Based Redefinition (EBR) Testing Guide

This document describes how to test Liquibase's `--driver-properties-file` functionality with Oracle Edition-Based Redefinition.

## Background

Oracle Edition-Based Redefinition (EBR) allows you to upgrade database objects while the application is online. Customers may need to connect to a specific edition when running Liquibase commands.

The Oracle JDBC driver supports connecting to a specific edition via the `oracle.jdbc.editionName` connection property.

## Prerequisites

### 1. Oracle Database with Editions Configured

Run the following as a DBA (e.g., SYSTEM user):

```sql
-- Create editions
CREATE EDITION V1 AS CHILD OF ORA$BASE;
CREATE EDITION V2 AS CHILD OF V1;

-- Create a test user
CREATE USER EDITION_USER IDENTIFIED BY EDITION_USER
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

-- Grant basic privileges
GRANT CONNECT, RESOURCE TO EDITION_USER;
GRANT CREATE SESSION TO EDITION_USER;

-- Enable the user for editions
ALTER USER EDITION_USER ENABLE EDITIONS;

-- Grant USE on editions to the user
GRANT USE ON EDITION V1 TO EDITION_USER;
GRANT USE ON EDITION V2 TO EDITION_USER;
```

### 2. Verify Edition Setup

```sql
-- Check available editions
SELECT edition_name FROM all_editions ORDER BY edition_name;

-- Should show:
-- ORA$BASE
-- V1
-- V2
```

## Test Files

### liquibase.properties (Liquibase defaults file)

```properties
classpath: ojdbc8-21.jar
driver: oracle.jdbc.OracleDriver
url: jdbc:oracle:thin:@localhost:1521/BUCKET_01
username: EDITION_USER
password: EDITION_USER
```

### oracle-edition-v1.properties (Driver properties for V1)

```properties
oracle.jdbc.editionName=V1
```

### oracle-edition-v2.properties (Driver properties for V2)

```properties
oracle.jdbc.editionName=V2
```

## Test Execution

### Test 1: Connect to V1 Edition

```bash
liquibase --defaults-file=liquibase.properties \
          --driver-properties-file=oracle-edition-v1.properties \
          execute-sql --sql="SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL"
```

**Expected Output:**
```
Output of SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL:
EDITION |
V1 |
```

### Test 2: Connect to V2 Edition

```bash
liquibase --defaults-file=liquibase.properties \
          --driver-properties-file=oracle-edition-v2.properties \
          execute-sql --sql="SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL"
```

**Expected Output:**
```
Output of SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL:
EDITION |
V2 |
```

### Test 3: Default Edition (no driver-properties-file)

```bash
liquibase --defaults-file=liquibase.properties \
          execute-sql --sql="SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL"
```

**Expected Output:**
```
Output of SELECT SYS_CONTEXT('USERENV', 'CURRENT_EDITION_NAME') AS EDITION FROM DUAL:
EDITION |
ORA$BASE |
```

## Key Points

1. **Property Name**: The correct Oracle JDBC property is `oracle.jdbc.editionName` (not `oracle.editionName`)

2. **URL Parameters Don't Work**: Setting the edition via URL parameter (`?oracle.jdbc.editionName=V1`) does NOT work reliably. Use `--driver-properties-file` instead.

3. **Driver Properties File**: All properties in this file are passed directly to the JDBC driver's `connect()` method.

4. **Error Handling**: If the edition doesn't exist, Oracle JDBC throws "edition does not exist" error.

5. **Liquibase Pro Required**: The `--driver-properties-file` argument is available in Liquibase Pro. 
    1. Properties file (defaults file): `driverPropertiesFile=oracle-edition-v1.properties`
    1. Environment variable: `LIQUIBASE_COMMAND_DRIVER_PROPERTIES_FILE=oracle-edition-v1.properties`

## Troubleshooting

### Edition Not Changing

- Verify the user has USE privilege on the edition: `GRANT USE ON EDITION V1 TO username;`
- Verify the user is enabled for editions: `ALTER USER username ENABLE EDITIONS;`
- Check the property file has the correct property name: `oracle.jdbc.editionName`

### Connection Errors

- Ensure the Oracle JDBC driver version is compatible with your Oracle server
- Check that the service name in the URL is correct

## References

- [Oracle JDBC Developer's Guide - Data Sources and URLs](https://docs.oracle.com/en/database/oracle/oracle-database/26/jjdbc/data-sources-and-URLs.html)
- [Oracle Edition-Based Redefinition](https://docs.oracle.com/en/database/oracle/oracle-database/19/adfns/editions.html)
- [Edition name as a property for JDBC thin client](https://timurakhmadeev.wordpress.com/2010/02/08/jdbc-editions/)
