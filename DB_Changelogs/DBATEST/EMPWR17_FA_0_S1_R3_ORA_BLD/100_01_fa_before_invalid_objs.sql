--liquibase formatted sql

--changeset Nyamana:cordata_7311.1 labels:after_invalid_objs,LIQTEST context:LIQTEST runAlways:true
--comment After invalid objects script to addresse and fix the invalid objects in schema CP and CORPPROD.

-- SET LINES 200 PAGES 100

SELECT owner,
       object_name,
       object_type,
       created,
       last_DDL_TIME,
       STATUS
  FROM ALL_OBJECTS
WHERE status = 'INVALID' AND owner IN ('LIQUIBASE_USER','CMS_DEV');

  -- # of changes = 2

--rollback empty



