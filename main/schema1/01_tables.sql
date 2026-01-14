--liquibase formatted sql

--changeset adeel:employees
create table employees (
    id int primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)
--rollback drop table employees

--changeset adeel:customers
create table customers (
    id int primary key,
    name varchar(50) not null,
    address1 varchar(50),
    address2 varchar(50),
    city varchar(30)
)
--rollback drop table customers

--changeset adeel:contractors
CREATE TABLE contractors
( id int primary key,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL
)
--rollback drop table contractors