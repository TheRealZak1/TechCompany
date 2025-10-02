USE tech_company;
/*
        OBLIGATORISK OPGAVE - TECH COMPANY
        AF: Zakariya Berrhili
*/


-- SINGLE TABLE ASSIGNMENTS--


-- Finder medarbejder_id for MARTIN
SELECT employee_number
FROM employees
WHERE employee_name = 'MARTIN';


-- Ansatte med mere end 1500 i lon
SELECT employee_name, salary
FROM employees
WHERE salary > 1500;

-- Lister hvis man er saelger og lon > 1300
SELECT employee_name, salary
FROM employees
WHERE job_title = 'SALESMAN' AND salary > 1300;


-- Lister ansatte som ikke er saelgere
SELECT employee_name
FROM employees
WHERE job_title <> 'SALESMAN';

-- Viser clerks med lon -10%
SELECT employee_name, salary, salary * 0.9 AS ny_lon
FROM employees
WHERE job_title = 'CLERK';

-- Ansatte foer maj 1981
SELECT employee_name, hire_date
FROM employees
WHERE hire_date < '1981-05-01';

-- Sorter ansatte efter lon (stoerst foerst)
SELECT employee_name, salary
FROM employees
ORDER BY salary DESC;

-- Sorter afdelinger efter lokation
SELECT department_name, office_location
FROM departments
ORDER BY office_location;

-- Find department i New York
SELECT department_name
FROM departments
WHERE office_location = 'NEW YORK';

-- Find ansatte som starter med J og slutter med S
SELECT employee_name
FROM employees
WHERE employee_name LIKE 'J%S';

-- Find ansatte som starter med J og slutter med S og er manager
SELECT employee_name
FROM employees
WHERE employee_name LIKE 'J%S'
  AND job_title = 'MANAGER';

-- Antal ansatte pr. afdeling
SELECT department_number, COUNT(*) AS antal_ansatte
FROM employees
GROUP BY department_number;


-- AGGREGATE FUNCTIONS--


-- Antal ansatte i alt
SELECT COUNT(*) AS total_ansatte
FROM employees;

-- Sum af alle lonninger (uden commission)
SELECT SUM(salary) AS total_lon
FROM employees;

-- Gennemsnitslon i department 20
SELECT AVG(salary) AS gennemsnit
FROM employees
WHERE department_number = 20;

-- Unikke jobtitler i firmaet
SELECT DISTINCT job_title
FROM employees;

-- Antal ansatte pr. afdeling
SELECT department_number, COUNT(*) AS antal
FROM employees
GROUP BY department_number;

-- Maks. lon pr. afdeling, sorteret faldende
SELECT department_number, MAX(salary) AS max_lon
FROM employees
GROUP BY department_number
ORDER BY max_lon DESC;

-- Total sum af lon + provision
SELECT SUM(salary + IFNULL(commission, 0)) AS total_indkomst
FROM employees;


-- JOIN ASSIGNMENTS
-- Inner join employees og departments
SELECT *
FROM employees e
         INNER JOIN departments d
                    ON e.department_number = d.department_number;

-- Employee_name og department_name, sorteret A-Z
SELECT e.employee_name, d.department_name
FROM employees e
         INNER JOIN departments d
                    ON e.department_number = d.department_number
ORDER BY e.employee_name;

-- Left join employees og departments
SELECT e.employee_name, d.department_name
FROM employees e
         LEFT JOIN departments d
                   ON e.department_number = d.department_number;

-- Hvilken afdeling mangler i count-query? OPERATIONS (40)
-- fordi der ikke er nogen ansatte i den.

-- Brug RIGHT JOIN for at faa alle departments med
SELECT d.department_name, COUNT(e.employee_number) AS antal
FROM employees e
         RIGHT JOIN departments d
                    ON e.department_number = d.department_number
GROUP BY d.department_name;

-- SCOTTs query: join employees med deres managers
SELECT *
FROM employees employee
         JOIN employees manager
              ON employee.manager_id = manager.employee_number
ORDER BY employee.employee_name;

-- To kolonner: ansatte og deres manager
SELECT e.employee_name AS medarbejder, m.employee_name AS manager
FROM employees e
         JOIN employees m
              ON e.manager_id = m.employee_number;

-- Afdelinger med mere end 3 ansatte (HAVING)
SELECT department_number, COUNT(*) AS antal
FROM employees
GROUP BY department_number
HAVING COUNT(*) > 3;

-- Ansatte med lon over gennemsnittet
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-- MANY-TO-MANY RELATION
-- Opret leaders tabel
CREATE TABLE leaders (
                         leader_id INT PRIMARY KEY AUTO_INCREMENT,
                         leader_name VARCHAR(30)
);

-- Opret join tabel employees_leaders
CREATE TABLE employees_leaders (
                                   employee_number INT,
                                   leader_id INT,
                                   PRIMARY KEY (employee_number, leader_id),
                                   FOREIGN KEY (employee_number) REFERENCES employees(employee_number),
                                   FOREIGN KEY (leader_id) REFERENCES leaders(leader_id)
);

-- Indsaet leaders
INSERT INTO leaders (leader_name) VALUES ('Alice'), ('Bob');

-- Link employees til leaders
INSERT INTO employees_leaders (employee_number, leader_id) VALUES (7369, 1), (7499, 1), (7521, 2);

-- Many-to-many query: ansatte og leaders
SELECT e.employee_name, l.leader_name
FROM employees e
         JOIN employees_leaders el ON e.employee_number = el.employee_number
         JOIN leaders l ON el.leader_id = l.leader_id;
