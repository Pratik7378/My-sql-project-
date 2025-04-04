create database trigg ;

use trigg ;

-- after/ before, insert, update, delete

# After Insert

create table trigger1 (
c1 varchar(50),
c2 date,
c3 int);

create table trigger2 (
c11 varchar(50),
c12 date,
c13 int);

insert into trigger1 value ("java2", "2000-12-12", 500) ;
 

select * from trigger1 ;
select * from trigger2 ;


delimiter //
create trigger t1_to_t2
after insert on trigger1 for each row 
begin
	insert into trigger2(c11,c12,c13) values ("xyz", sysdate(), rand());
end; //


insert into trigger1 value ("java4", "2000-12-12", 57) ;

--------------------------------------------


# after update

create table u1 (
c1 varchar(50),
c2 date,
c3 int);


create table u2 (
c11 varchar(50),
c12 date,
c13 int);

insert into u1 value ("java4", "2000-12-12", 44) ;


select * from u1 ;
select * from u2 ;


delimiter //
create trigger u1_to_u2
before update on u1 for each row 
begin
	insert into u2(c11,c12,c13) values (user(), sysdate(), old.c3);
end; //


update u1 set c3 = 50 where c1 = 'java1' ;

select * from u1 ;
select * from u2 ;


---------------------------------------------------------------


# before delete


create table d1 (
c1 varchar(50),
c2 date,
c3 int);


create table d2 (
c11 varchar(50),
c12 date,
c13 int);

insert into d1 value ("java3", "2000-12-12", 88) ;



select * from d1 ;
select * from d2 ;


delimiter //
create trigger d1_to_d2
before delete on d1 for each row 
begin
	insert into d2(c11,c12,c13) values (old.c1, old.c2 , old.c3);
end; //


delete from d1 where c1 = "java2" ;

select * from d1 ;
select * from d2 ;

-------------------------------


create table table1 (
c1 varchar(50),
c2 date,
c3 int);

create table table2 (
c11 varchar(50),
c12 date,
c13 int);

create table table3 (
c21 varchar(50),
c22 date,
c23 int);

create table table4 (
c31 varchar(50),
c32 date,
c33 int);



delimiter //
create trigger trigger_insert
after insert on table1 for each row 
begin
	insert into table2(c11,c12,c13) values (new.c1, new.c2, new.c3);
end; //


delimiter //
create trigger trigger_update
after update on table1 for each row 
begin
	insert into table3(c21,c22,c23) values (user(), sysdate(), old.c3);
end; //


delimiter //
create trigger trigger_delete
after delete on table1 for each row 
begin
	insert into table4(c31,c32,c33) values (old.c1, old.c2, old.c3);
end; //


select * from table1 ;
select * from table2 ;
select * from table3 ; 
select  * from table4 ;


insert into table1 values("KKR", "2010-05-01", 5) ;

update table1 set c1 = "RCB" where c3 = 2 ;

update table1 set c3 = 1 where c1 = "MI" ;

delete from table1 where c1 = "RCB" ;

---------------------------------


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2),
    LastUpdated DATETIME
);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, LastUpdated)
VALUES 
(1, 'John', 'Doe', 50000.00, sysdate()),
(2, 'Jane', 'Smith1', 60000.00, sysdate()),
(3, 'Jane1', 'Smith2', 70000.00, sysdate()),
(4, 'Jane2', 'Smith3', 80000.00, sysdate());

select * from employees ;

CREATE TABLE SalaryHistory (
    EmployeeID INT,
    OldSalary DECIMAL(10, 2),
    NewSalary DECIMAL(10, 2),
    ChangeDate DATETIME
);


Delimiter //
CREATE TRIGGER trg_UpdateSalary
after update ON Employees for each row
BEGIN
    -- Insert the old and new salary into the SalaryHistory table
    INSERT INTO SalaryHistory (EmployeeID, OldSalary, NewSalary, ChangeDate) values
    (old.EmployeeID, old.salary,  new.Salary, sysdate()) ;
END;


update employees
set Salary = 76000 where EmployeeID = 2 ;

select * from salaryhistory ;



CREATE TRIGGER before_insert_products
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    INSERT INTO inventory_log (product_id, `action`, action_timestamp)
    VALUES (NEW.product_id, new.producttable, NOW());
END;



CREATE TRIGGER before_insert_products
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    -- Check if the quantity_in_stock is not negative
    IF NEW.quantity_in_stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity in stock cannot be negative';
    END IF;

    -- Log the insertion into inventory_log
    INSERT INTO inventory_log (table_name, record_id, action, action_timestamp, user_id)
    VALUES ('products', NEW.product_id, 'INSERT', NOW(), @current_user);
END;


-------------------------------------------------


CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    quantity_in_stock INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);


CREATE TABLE inventory_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(255) NOT NULL,
    record_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    action_timestamp TIMESTAMP NOT NULL,
    user_id INT NOT NULL
);


DELIMITER $$

CREATE TRIGGER before_insert_products
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    -- Check if the quantity_in_stock is not negative
    IF NEW.quantity_in_stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity in stock cannot be negative';
    END IF;

    -- Log the insertion into inventory_log
    INSERT INTO inventory_log (table_name, record_id, action, action_timestamp, user_id)
    VALUES ('products', NEW.product_id, 'INSERT', NOW(), USER());
END$$

DELIMITER ;



-- Inserting data that should pass the trigger
INSERT INTO products (product_name, quantity_in_stock, price)
VALUES ('Laptop', 10, 999.99),
       ('Smartphone', 50, 599.99),
       ('Headphones', 100, 99.99);


-- Inserting data that should fail the trigger due to negative quantity_in_stock
INSERT INTO products (product_name, quantity_in_stock, price)
VALUES ('Tablet', -5, 299.99);  -- This will trigger an error










