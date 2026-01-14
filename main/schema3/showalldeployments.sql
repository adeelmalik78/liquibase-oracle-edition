--liquibase formatted sql

--changeset amalik:showInserts runAlways:true
-- testing comments by Adeel
-- testing globalStripComments
select * from employees;
--rollback empty
