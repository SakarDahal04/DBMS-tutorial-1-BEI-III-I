CREATE DATABASE company_employee

-------------------------------------------------Tuorial 1 Question 1---------------------------------------------------
CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
    );
 
 
CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
		FOREIGN KEY(employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
    );
 
 CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
    );
 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Patrick',
        'Pongyang Corporation',
        500000
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );
 
INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );
 
INSERT INTO
    tbl_Manages(employee_name, manager_name)
VALUES (
	'Mark Thompson', 'Emily Williams'),
    ('Sara Davis', 'Jane Doe'),		--There was no John Smith
    ('Alice Williams', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Patrick', 'Jane Doe');
 
SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Manages;
SELECT * FROM tbl_Company;

 --------------------------------Tutorial 1 Question 2---------------------------------------------------------

--Question a
--Name of all employees who work for First Bank Cooperation
SELECT employee_name FROM tbl_Works
WHERE company_name = 'First Bank Corporation';

--Question b------------------------------------------------------------------------------------------------------

--Name and city of residence of all employees who work for Small Bank Cooperation
--Process 1
SELECT tbl_Employee.employee_name, city FROM tbl_Employee, tbl_Works
WHERE company_name = 'Small Bank Corporation' AND tbl_Works.employee_name = tbl_Employee.employee_name;

--Process 2(using subquery)
SELECT employee_name, city FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works WHERE company_name = 'Small Bank Corporation');


--Question c------------------------------------------------------------------------------------------------------
--names, street addresses, and cities of residence of all employees who work for Small Bank Corporation and earn more than $10,000
SELECT employee_name, street, city FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works WHERE salary > 10000 AND company_name = 'Small Bank Corporation');

--Question d-----------------------------------------------------------------------------------------------------
--name of all employees in the database who live in the same cities as the companies for which they work
--Using sub-queries
SELECT employee_name FROM tbl_Employee
WHERE city IN (SELECT city FROM tbl_Company WHERE tbl_Company.company_name IN
(SELECT company_name FROM tbl_Works WHERE tbl_Works.employee_name = tbl_Employee.employee_name));

--Using AND
SELECT tbl_Employee.employee_name FROM tbl_Employee, tbl_Company, tbl_Works
WHERE tbl_Employee.employee_name = tbl_Works.employee_name
AND tbl_Works.company_name = tbl_Company.company_name
AND tbl_Employee.city = tbl_Company.city;

--Question e----------------------------------------------------------------------------------------------------
--name of all employees in the database who live in the same cities and on the same streets as do their managers
--(address of the manager not given)

--At first the address of the manager has to be inserted
DROP TABLE tbl_Manages;
 --Creating the table along with address 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255),
		manager_address VARCHAR(255) NOT NULL, 
		manager_street VARCHAR(255),
    );

--Inserting the data to the table
INSERT INTO
    tbl_Manages(employee_name, manager_name, manager_address, manager_street)
VALUES 
    ('Mark Thompson', 'Emily Williams', 'Chicago', '111 Second St'),
    ('Michael Brown', 'Jane Doe', 'New York', '235 Fifth Ave'),
    ('Alice Williams', 'Emily Williams', 'Houston', '321 Maple St'),
    ('Samantha Smith', 'Sara Davis', 'Los Angles', '741 First St'),
    ('Patrick', 'Jane Doe', 'Las Vegas', '876 Market St');

 --Code for the question where manager and employee has same city and street as their manager
 SELECT tbl_Manages.employee_name, tbl_Manages.manager_name FROM tbl_Manages, tbl_Employee
 WHERE tbl_Employee.employee_name = tbl_Manages.employee_name
 AND tbl_Manages.manager_address = tbl_Employee.city
 AND tbl_Manages.manager_street = tbl_Employee.street;

--Question f--------------------------------------------------------------------------------------------------------
--name of all employees in the database who do not work for First Bank Corporation
--Using Sub Query
SELECT employee_name FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works WHERE company_name != 'First Bank Corporation');

--Using AND(taking Small Bank Corporation)
SELECT tbl_Employee.employee_name FROM tbl_Employee, tbl_Works
WHERE company_name != 'Small Bank Corporation' AND tbl_Employee.employee_name = tbl_Works.employee_name;

--Question g---------------------------------------------------------------------------------------------------------
--name of employees in the database who earn more than each employee of Small Bank Corporation
SELECT employee_name FROM tbl_Works 
WHERE (
		(salary > (SELECT salary FROM tbl_Works 
				WHERE salary = (SELECT MAX(salary) FROM tbl_Works 
								WHERE company_name = 'Small Bank Corporation'))
		)
		AND 
		(company_name != 'Small Bank Corporation')
	);

--Question h-----------------------------------------------------------------------------------------------------
--Assume that the companies may be located in several cities. Find all companies located in every city in which
--Small Bank Corporation is located.
SELECT company_name FROM tbl_Company
WHERE city IN (SELECT city FROM tbl_Company WHERE company_name = 'Small Bank Corporation');

--Question i-----------------------------------------------------------------------------------------------------
--Find all employees who earn more than the average salary of all employees of their company
SELECT employee_name FROM tbl_Works
WHERE salary > (SELECT AVG(salary) from tbl_Works);

--Question j-----------------------------------------------------------------------------------------------------
--Find the company that has the most employees.

SELECT company_name, COUNT(*) AS noOfEmployees
FROM tbl_Works
GROUP BY company_name
ORDER BY noOfEmployees DESC;

--Question k-----------------------------------------------------------------------------------------------------
-- Find the company that has the smallest payroll

SELECT company_name, sum(salary) AS smallestPayroll FROM tbl_Works
GROUP BY company_name
HAVING SUM(salary) <= ALL(SELECT SUM(salary)
FROM tbl_Works
GROUP BY company_name
);

--Question l-----------------------------------------------------------------------------------------------------
-- Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.
SELECT employee_name,Company_name FROM tbl_Works
WHERE Salary > (SELECT AVG(SALARY) FROM tbl_Works WHERE company_name='First Bank Corporation');
-----------------------------------------------------------------------------------------------------------------