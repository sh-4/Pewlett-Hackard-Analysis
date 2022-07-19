-- verifying data imports
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM dept_emp;
SELECT * FROM salaries;
SELECT * FROM titles;

-- determining retirement eligibility: bd 1952-1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- 90398 affected

-- refining results: 1952 only
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
-- 21209 affected

-- refining results: 1953 only
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
-- 22857 affected

-- refining results: 1954 only
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
-- 23228 affected

-- refining results: 1955 only
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
-- 23104 affected

-- results too large still; refine more
-- bd 1952-1955, hired 1985-1988
-- () for order of operations, like pemdas
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- 41380 affected

-- count function to get # of employees
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- 41380

-- view new retirement info table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
    INNER JOIN dept_manager
        ON departments.dept_no = dept_manager.dept_no;
-- ^^^ shortened names below for smoother code
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
    INNER JOIN dept_manager as dm
        ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
    LEFT JOIN dept_emp
        ON retirement_info.emp_no = dept_emp.emp_no;
-- ^^^ shortened names below for smoother code
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
    LEFT JOIN dept_emp as de
        ON ri.emp_no = de.emp_no;

-- retire-eligible employee count by department number
-- ordered by dept number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
    LEFT JOIN dept_emp as de
        ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- check dates in salary table by most recent
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Employee Information: A list of employees containing their emp#, last name, first name, gender, and salary
-- emp table info only:
SELECT emp_no,
    first_name,
	last_name,
    gender
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

