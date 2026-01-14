--liquibase formatted sql

--changeset adeel:11
-- ## Is this a problem?
CREATE TABLE ADEEL1 (
	ID INTEGER NULL
)

--rollback drop table adeel1;
