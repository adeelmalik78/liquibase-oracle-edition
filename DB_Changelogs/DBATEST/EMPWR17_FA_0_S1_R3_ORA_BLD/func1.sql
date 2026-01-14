--liquibase formatted sql

--changeset adeel:function1 stripComments:false

-- ## 
-- ## Testing ...
-- ##
CREATE OR REPLACE FUNCTION text_length(a CLOB) 
   RETURN NUMBER DETERMINISTIC IS
BEGIN 
  RETURN DBMS_LOB.GETLENGTH(a);
END;

--rollback empty