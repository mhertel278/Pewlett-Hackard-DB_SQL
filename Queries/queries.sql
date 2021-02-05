DROP TABLE dept_emp;

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no,dept_no)
);

SELECT * FROM dept_emp;

DROP TABLE titles;

CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1988-01-01' AND '1988-12-31')

;

-- Number of Employees Eligible for Retirement
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

;

-- Retirement Eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

;

DROP TABLE retirement_info;

-- Retirement Eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

;

SELECT * FROM retirement_info;

-- Recreate retirement_info table with employee numbers
DROP TABLE retirement_info;


SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

;
--Check the table

SELECT * FROM retirement_info;

-- Join departments and dept_manager tables

SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Recreate retirement_info including to_date

SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Practice aliasing with retirement_info join

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- More aliasing practice
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- continue retirement info with to_date for current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')
;

-- added 2.3.21
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_per_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no
;

SELECT * FROM emp_per_dept;

SELECT * FROM retirement_info;

SELECT * FROM salaries
ORDER BY to_date DESC;


-- Join Employees, salaries, and dept_emp 
--to get table with current emploees filtered to retirement eligible and
-- emp #, first and last name, gender, salary
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND de.to_date = ('9999-01-01');


DROP TABLE emp_info;

SELECT * FROM emp_info;

-- Create table of managers retiring

SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.first_name,
	ce.last_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);	

-- Create table of current employees with department name

SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON ce.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no;
	
-- Create list of current employees in Sales 
SELECT * 
INTO dept_info_sales

FROM dept_info
WHERE dept_name = 'Sales';

-- Create list of current employees in either Sales or Depevelopment

SELECT * 
INTO dept_info_sales_dev

FROM dept_info
WHERE dept_name IN('Sales', 'Development');
	