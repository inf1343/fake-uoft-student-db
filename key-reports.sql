Use uoft_student_db;

-- ANALYSIS I. Admission Analysis:
-- 1. Calculate the total percentage of applications that have been admitted out of all applications received.
--    (Note: "applications received" -> should not contain application_status = 'not-submitted')
-- 2. For all admitted applications, determine the ratio of those that were accepted, declined, or pending.
-- 3. Verify that every admitted application also exists in the 'admission_offer' table; if not , return the missing applications id.  

SELECT 
  ROUND(100.0 * 
    SUM(application_status = 'admitted') / 
    COUNT(*), 2
  ) AS admitted_percentage
FROM application
WHERE application_status IN ('submitted-pending', 'admitted', 'rejected');

SELECT 
  applicant_decision,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM admission_offer), 2) AS percentage
FROM admission_offer
GROUP BY applicant_decision;

SELECT 
  CASE 
    WHEN COUNT(*) = 0 THEN 'All admitted applications exist in admission_offer'
    ELSE CONCAT('Missing application_id(s): ', GROUP_CONCAT(application_id))
  END AS result
FROM (
  SELECT a.application_id
  FROM application a
  WHERE a.application_status = 'admitted'
    AND NOT EXISTS (
      SELECT 1
      FROM admission_offer ao 
      WHERE ao.application_id = a.application_id
    )
) AS missing_apps;



-- ANALYSIS II. INF Teaching Staff Workload details in 2024:
-- Find all the INF courses (sections and tutorials) in 2024 
-- and list out all the teaching staff responsible for them. 
-- The returned table should include information of the teaching staff (id, first and last name),
-- their position (professor/teaching_assistant), the course code and course name, 
-- the term it takes place, and the type (section/tutorial) they are responsible for.

SELECT 
  ts.staff_id,
  ts.first_name,
  ts.last_name,
  ts.position,
  c.course_code,
  c.course_name,
  c.term,
  'section' AS type
FROM section s
JOIN course c ON s.course_id = c.course_id
JOIN teaching_staff ts ON s.instructor_id = ts.staff_id
WHERE c.year = 2024 AND c.course_code LIKE 'INF%'
UNION
SELECT 
  ts.staff_id,
  ts.first_name,
  ts.last_name,
  ts.position,
  c.course_code,
  c.course_name,
  c.term,
  'tutorial' AS type
FROM tutorial t
JOIN course c ON t.course_id = c.course_id
JOIN teaching_staff ts ON t.instructor_id = ts.staff_id
WHERE c.year = 2024 AND c.course_code LIKE 'INF%'
ORDER BY staff_id, course_code, type;



-- ANALYSIS III. Enrollment Analysis:
-- 1. For a specific student (William Chen, student number: S20240001), calculate the total number of credits earned each year.
-- 2. Analyze the distribution of his enrolled credits across the various faculties offering the courses, per year.
-- Note: William began his studies in 2023, even though his student number contains '2024'—the reason for this discrepancy is outside the scope of this project.

WITH year_credit_sum AS (
	SELECT c.year, SUM(c.credits) AS total_credit
    FROM enrollment e
	LEFT JOIN course c ON e.course_id = c.course_id
    WHERE e.student_number = 'S20240001' 
	GROUP BY c.year 
),
faculty_credit_distribution AS (
	SELECT c.year, c.offered_by, SUM(c.credits) AS faculty_credit
    FROM enrollment e
	LEFT JOIN course c ON e.course_id = c.course_id
    WHERE e.student_number = 'S20240001' 
	GROUP BY c.year, c.offered_by
)
SELECT 
	ycs.year, 
	ycs.total_credit, 
	fcd.offered_by, 
	fcd.faculty_credit, 
	ROUND(100 * fcd.faculty_credit / ycs.total_credit, 2) AS faculty_credit_percent
FROM year_credit_sum ycs
JOIN faculty_credit_distribution fcd ON ycs.year = fcd.year
ORDER BY ycs.year, fcd.offered_by;


