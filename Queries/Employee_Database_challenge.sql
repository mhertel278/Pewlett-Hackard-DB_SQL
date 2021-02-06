-- Get the names, titles and dates for title heald for employees eligible for retirement

SELECT 
	e.emp_no
	, e.first_name
	, e.last_name
	, t.title
	, t.from_date
	, t.to_date
INTO retirement_titles
FROM employees as e
JOIN titles as t
	ON e.emp_no = t.emp_no
-- JOIN the dept_emp to filter on to_date for current emp
JOIN dept_emp as de
	ON e.emp_no = de.emp_no
-- Filter for retirement eligible ages
WHERE e.birth_date BETWEEN ('1952-01-01') AND ('1955-12-31') 
 	-- filter to only current employees
	AND	de.to_date = ('9999-01-01')	
ORDER BY e.emp_no
	-- show most recent position first
 	, t.to_date DESC

;


-- Get only the most recent position for each person in the retirement_titles table

SELECT DISTINCT ON (rt.emp_no)
	rt.emp_no
	,rt.first_name
	,rt.last_name
	,rt.title
INTO unique_titles
FROM retirement_titles AS rt
ORDER BY rt.emp_no
	, rt.to_date DESC
;

-- Get count of retirement eligible employees by title
SELECT COUNT(ut.emp_no) AS "count"
	,ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY count DESC
;

-- get emp_no, name, birth date, employement dates, and title of current employees
-- born in 1965
SELECT DISTINCT ON (e.emp_no) e.emp_no
	,e.first_name
	,e.last_name
	,e.birth_date
	,de.from_date
	,de.to_date
	,t.title
INTO mentorship_eligibility
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN titles t
	ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
	AND de.to_date = '9999-01-01'
ORDER BY e.emp_no

;