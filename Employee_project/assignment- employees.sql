# 2a. Database structure -- The employees database tables
select * from employees;
select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;

# 2b. Sample Queries to explore database
# List of all employees
SELECT
	first_name,
    last_name
FROM
	employees;

# List all of departments
SELECT
	dept_name
FROM
	employees.departments;
    
# List of all employees and their current titles
SELECT
	employees.first_name,
    employees.last_name,
    titles.title as Title
FROM
	employees
INNER JOIN
	titles ON employees.emp_no = titles.emp_no
GROUP BY
	employees.first_name,
    employees.last_name,
    titles.title;
    
# 3. Database using SQL 
# a. Basic Queries
# Total number of employees
SELECT
	Count(employees.emp_no) as NumEmployees
FROM 
	employees;

# Average Salary by Department
SELECT
    departments.dept_no,
    departments.dept_name AS Department,
    AVG(salaries.salary) AS avgSalaries
FROM
    departments
INNER JOIN
    dept_emp ON departments.dept_no = dept_emp.dept_no
INNER JOIN
    salaries ON dept_emp.emp_no = salaries.emp_no
GROUP BY
    departments.dept_no,
    departments.dept_name
ORDER BY
    avgSalaries DESC;
    
# Top 10 Highest Paid Employees
SELECT 
	employees.emp_no,
	employees.first_name,
    employees.last_name,
    salaries.salary
FROM 	
	employees
INNER JOIN 
	salaries ON employees.emp_no = salaries.emp_no
GROUP BY 
	employees.emp_no,
	employees.first_name,
    employees.last_name,
    salaries.salary
ORDER BY 
	salaries.salary desc
LIMIT 10;

# b. Advanced Queries
# •	Employee Count by Department:
SELECT 
	departments.dept_name,
    COUNT(employees.emp_no) As NumEmployees
From 
	departments
Inner Join
	dept_emp ON departments.dept_no = dept_emp.dept_no
Inner Join
	employees ON dept_emp.emp_no = employees.emp_no
GROUP BY
	dept_name ORDER BY NumEmployees desc;

# Salary Trend Over Time:
SELECT
	Distinct salaries.from_date,
	salaries.to_date,
    sum(salaries.salary) as Salary
From
	employees.salaries
Group by
	salaries.from_date,
    salaries.to_date
ORDER BY salaries.from_date, salaries.to_date desc;

#Gender Distribution by Department
SELECT
	departments.dept_name, 
    employees.gender,
    Count(employees.gender) AS GenderCount
FROM
	employees.departments
INNER JOIN
	employees.dept_emp ON departments.dept_no = dept_emp.dept_no
INNER JOIN
	employees.employees ON dept_emp.emp_no = employees.emp_no
GROUP BY
	departments.dept_name,
    employees.gender
ORDER BY
	GenderCount;