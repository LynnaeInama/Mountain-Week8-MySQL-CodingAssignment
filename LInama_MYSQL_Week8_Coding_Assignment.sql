-- Use the employees database.
Use employees;

-- 1) How many employees with each title were born after 1965-01-01.
SELECT t.title AS "Job Title", count(t.emp_no) AS "Number of Current Employees" FROM titles t
	INNER JOIN employees e
	ON t.emp_no = e.emp_no
		AND t.to_date = '9999-01-01'
WHERE e.birth_date > '1965-01-01'
GROUP BY t.title;

-- 2) Average salary per job title. Since it didn't specify current salary I included all historical information.
--    If I wanted only avg salary of current jobs only I would add below line 15 (ON t.emp_no = s.emp_no) the following-->   AND t.to_date = '9999-01-01'.
SELECT t.title AS "Job Title", AVG(s.salary) AS "Average Salary" FROM titles t
	INNER JOIN salaries s
	ON t.emp_no = s.emp_no
GROUP BY t.title;


-- 3) Sum the salaries spent on Marketing department between the years 1990 and 1992.  
--    This is a very crude estimate as the salaries pull by the salary to_date 1990 through 1992.
SELECT d.dept_name AS "Department", sum(s.salary) AS "Total Salaries" FROM departments d
	INNER JOIN dept_emp de ON de.dept_no = d.dept_no
	INNER JOIN salaries s ON s.emp_no = de.emp_no
WHERE d.dept_name = 'Marketing' AND
	s.to_date BETWEEN '1990-01-01' AND '1992-12-31';

-- 3 BONUS) This is my take on a better estimate than #3 above.  
--          Since salary is paid more frequently than annually, if the salary from_date was in 1989 or the salary to_date was in 1993 I calculated the number of days of salary in 1990 and 1992. 
--          Othewise I just pulled over the salary amount if the to_date hit 1990, 1991 or 1992.
SELECT departments.dept_name, sum(
	IF(salaries.from_date BETWEEN '1989-01-01' AND '1989-12-31', salaries.salary / (1+DATEDIFF(salaries.to_date, salaries.from_date)) * (1+DATEDIFF(salaries.to_date, '1990-01-01')),
		IF(salaries.from_date BETWEEN '1992-01-01' AND '1992-12-31' 
			AND salaries.to_date BETWEEN '1992-01-01' AND '1992-12-31', salaries.salary,
		IF(salaries.from_date BETWEEN '1992-01-01' AND '1992-12-31', salaries.salary / (1+DATEDIFF(salaries.to_date, salaries.from_date)) * (1+DATEDIFF('1992-12-31', salaries.from_date)), salaries.salary)))) 
        AS 'Total Salaries Paid'
FROM departments 
	INNER JOIN dept_emp ON dept_emp.dept_no = departments.dept_no
	INNER JOIN salaries ON salaries.emp_no = dept_emp.emp_no
WHERE departments.dept_name = 'Marketing' 
	AND salaries.to_date BETWEEN '1990-01-01' AND '1993-12-31' 
	AND salaries.from_date<'1993-01-01';






