-- ANALYSIS queries

-- total number of retiring employees
SELECT count(emp_no)
FROM retirement_titles AS rt
WHERE rt.to_date = '9999-01-01';
-- 72458

--total number of current employees
SELECT COUNT(emp_no)
FROM dept_emp
WHERE to_date = '9999-01-01';
--240124

-- retiring by dept
SELECT COUNT (ut.title), d.dept_name
-- INTO retiring_depts
FROM unique_titles AS ut
	INNER JOIN dept_emp as de
		ON (ut.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
GROUP BY d.dept_name
ORDER BY COUNT(ut.title) DESC;

-- mentoring by dept
SELECT COUNT (me.emp_no), d.dept_name
-- INTO mentorship_by_dept
FROM mentorship_eligibilty AS me
	INNER JOIN dept_emp as de
		ON (me.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
GROUP BY d.dept_name
ORDER BY COUNT(me.emp_no) DESC;

--eligible for mentorship:
--1549

-- retirement titles
SELECT COUNT(emp_no), title
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT(emp_no) DESC;