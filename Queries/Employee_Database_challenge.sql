-- Get the names, titles and dates for title heald for employees eligible for retirement

SELECT --DISTINCT ON (e.emp_no)
	e.emp_no
	, e.first_name
	, e.last_name
	, t.title
	, t.from_date
	, t.to_date
-- INTO retirement_titles
FROM employees as e
JOIN titles as t
	ON e.emp_no = t.emp_no
-- Filter for retirement eligible ages
WHERE e.birth_date BETWEEN ('1952-01-01') AND ('1955-12-31') 
 	-- filter to only current employees
	--AND	t.to_date = ('9999-01-01')	
ORDER BY e.emp_no
	-- show most recent position first
	, t.to_date DESC
;


-- Get only the most recent position for each person in the retirement_titles table

SELECT DISTINCT ON (r.emp_no)
	r.emp_no
	,r.first_name
	,r.last_name
	,r.title
-- INTO unique_titles
FROM retirement_titles r
ORDER BY r.emp_no
	, r.to_date DESC
;

-- Get count of retirement eligible employees by title
SELECT COUNT(r.emp_no) AS "count"
	,r.title
--INTO retiring_titles
FROM retirement_titles r
ORDER BY count DESC
;