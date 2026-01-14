--liquibase formatted sql

--changeset amalik:insert_adeel
INSERT INTO employees (id,first_name,last_name)
	VALUES (1,'Adeel','Malik');
--rollback DELETE FROM employees WHERE id=1;

--changeset amalik:insert_amy
INSERT INTO employees (id,first_name,last_name)
	VALUES (2,'Amy','Smith');
--rollback DELETE FROM employees WHERE id=2;

--changeset amalik:insert_roderick
INSERT INTO employees (id,first_name,last_name)
	VALUES (3,'Roderick','Bowser');
--rollback DELETE FROM employees WHERE id=3;

--changeset amalik:update_adeel
UPDATE employees
	SET first_name='Ryan', last_name='Campbell'
	WHERE id=1;
--rollback UPDATE employees SET first_name='Adeel', last_name='Malik' WHERE id=1;