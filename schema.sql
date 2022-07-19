-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- create new table for joined retirement info/dept_emp
-- only emps still employed are included (WHERE)
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp	
FROM retirement_info as ri
    LEFT JOIN dept_emp as de
        ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- retire-eligible employee count by department number
-- create new table
SELECT COUNT(ce.emp_no), de.dept_no
INTO eligible_retirement_emp_count_by_dept
FROM current_emp as ce
    LEFT JOIN dept_emp as de
        ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee Information: A list of employees containing their emp#, last name, first name, gender, and salary
-- join employees, salaries, dept_emp tables into new table
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
        AND (de.to_date = '9999-01-01');

-- Management: A list of managers for each dept, including: dept #, name, manager's employee number, last name, first name, starting and ending employment dates
-- join departments, dept_managers, current_emp tables into new table
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- Department Retirees: An updated current_emp list that includes everything it currently has, but also the employee's depts
-- join current_emp, departments, dept_emp tables to create new table
-- need key from dept_emp, but not any columns
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- retiring employees on the sales team
-- join current_emp, dept_emp, departments tables
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO sales_emp_retiring_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE de.dept_no = 'd007';