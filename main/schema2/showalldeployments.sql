--liquibase formatted sql

--changeset amalik:showInserts runAlways:true 
select * from employees;
--rollback empty
