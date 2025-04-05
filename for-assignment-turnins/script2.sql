-- SECTION 1.4.1: TESTING SQL SCHEMA CONSTRAINTS

-- =====================================
-- TEST 1: PRIMARY KEY VIOLATION
-- Purpose: Attempt to insert a student with a duplicate primary key
-- =====================================
INSERT INTO student (
    student_number, application_id, first_name, last_name, email, phone, date_of_birth,
    entry_year, is_domestic, is_full_time, degree_type, program_name
)
VALUES (
    'S20251100', 11, 'Duplicate', 'Student', 'duplicate@uoft.ca', '416-999-9999', '1995-01-01',
    2025, TRUE, TRUE, 'master', 'Master of Information'
);

-- =====================================
-- TEST 2: FOREIGN KEY VIOLATION
-- Purpose: Apply to a program that does not exist
-- =====================================
INSERT INTO application (applicant_id, applied_program, application_status, application_date)
VALUES (11, 'Fake Program', 'admitted', '2025-03-20');

-- =====================================
-- TEST 3: ENUM CONSTRAINT VIOLATION
-- Purpose: Use an invalid ENUM value for application_status
-- =====================================
INSERT INTO application (applicant_id, applied_program, application_status)
VALUES (11, 'Master of Information', 'in-review');

-- =====================================
-- TEST 4: NOT NULL VIOLATION
-- Purpose: Insert applicant without a required NOT NULL field (email)
-- =====================================
INSERT INTO applicant (first_name, last_name, phone, date_of_birth)
VALUES ('NoEmail', 'Person', '416-000-0000', '2002-10-10');

-- =====================================
-- TEST 5: UNIQUE CONSTRAINT VIOLATION
-- Purpose: Use an email address that already exists
-- =====================================
INSERT INTO applicant (first_name, last_name, email, phone, date_of_birth)
VALUES ('Another', 'Morgan', 'alex.morgan@uoft.ca', '416-321-4321', '1999-05-05');

-- =====================================
-- TEST 6: VALID ENUM CASE (SHOULD SUCCEED)
-- Purpose: Use a correct ENUM value for application_status
-- =====================================
INSERT INTO application (applicant_id, applied_program, application_status)
VALUES (11, 'Master of Information', 'submitted-pending');

-- =====================================
-- TEST 7: DELETE PROTECTED BY FOREIGN KEY
-- Purpose: Attempt to delete a course still referenced by section/tutorial
-- =====================================
DELETE FROM course WHERE course_id = 11;

-- =====================================
-- TEST 8: CHECK CONSTRAINT VIOLATION
-- Purpose: Insert a tutorial with a negative capacity
-- =====================================
INSERT INTO tutorial (course_id, tutorial_code, schedule, capacity, instructor_id)
VALUES (1, 101, '{"day": "Monday", "time": "10:00 AM"}', -10, 'T12345');

-- =====================================
-- TEST 9: NULLABLE FOREIGN KEY
-- Purpose: Insert an enrollment record with a NULL tutorial_code
-- =====================================
INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code)
VALUES ('S20251100', 1, 101, NULL);

-- =====================================
-- TEST 10: MULTIPLE FOREIGN KEY VIOLATIONS
-- Purpose: Insert an enrollment record with invalid student_number and course_id
-- =====================================
INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code)
VALUES ('INVALID123', 999, 101, 201);


------OUTPUT------

-- 16:39:20	USE uoft_student_db	0 row(s) affected	0.0082 sec

-- 16:39:23	INSERT INTO student (     student_number, application_id, first_name, last_name, email, phone, date_of_birth,     entry_year, is_domestic, is_full_time, degree_type, program_name ) VALUES (     'S20251100', 11, 'Duplicate', 'Student', 'duplicate@uoft.ca', '416-999-9999', '1995-01-01',     2025, TRUE, TRUE, 'master', 'Master of Information' )	Error Code: 1062. Duplicate entry 'S20251100' for key 'student.PRIMARY'	0.0070 sec

-- 16:39:27	INSERT INTO student (     student_number, application_id, first_name, last_name, email, phone, date_of_birth,     entry_year, is_domestic, is_full_time, degree_type, program_name ) VALUES (     'S20251100', 11, 'Duplicate', 'Student', 'duplicate@uoft.ca', '416-999-9999', '1995-01-01',     2025, TRUE, TRUE, 'master', 'Master of Information' )	Error Code: 1062. Duplicate entry 'S20251100' for key 'student.PRIMARY'	0.0075 sec

-- 16:39:31	INSERT INTO application (applicant_id, applied_program, application_status, application_date) VALUES (11, 'Fake Program', 'admitted', '2025-03-20')	Error Code: 1216. Cannot add or update a child row: a foreign key constraint fails	0.017 sec

-- 16:39:40	INSERT INTO application (applicant_id, applied_program, application_status) VALUES (11, 'Master of Information', 'in-review')	Error Code: 1265. Data truncated for column 'application_status' at row 1	0.0084 sec

-- 16:39:43	INSERT INTO applicant (first_name, last_name, phone, date_of_birth) VALUES ('NoEmail', 'Person', '416-000-0000', '2002-10-10')	Error Code: 1364. Field 'email' doesn't have a default value	0.0078 sec

-- 16:41:52	INSERT INTO application (applicant_id, applied_program, application_status) VALUES (11, 'Master of Information', 'in-review')	Error Code: 1265. Data truncated for column 'application_status' at row 1	0.0091 sec

-- 16:41:58	INSERT INTO applicant (first_name, last_name, phone, date_of_birth) VALUES ('NoEmail', 'Person', '416-000-0000', '2002-10-10')	Error Code: 1364. Field 'email' doesn't have a default value	0.0069 sec

-- 16:42:10	INSERT INTO applicant (first_name, last_name, email, phone, date_of_birth) VALUES ('Another', 'Morgan', 'alex.morgan@uoft.ca', '416-321-4321', '1999-05-05')	Error Code: 1062. Duplicate entry 'alex.morgan@uoft.ca' for key 'applicant.email'	0.015 sec

-- 16:42:15	INSERT INTO application (applicant_id, applied_program, application_status) VALUES (11, 'Master of Information', 'submitted-pending')	1 row(s) affected	0.018 sec

-- 16:42:22	DELETE FROM course WHERE course_id = 11	Error Code: 1217. Cannot delete or update a parent row: a foreign key constraint fails	0.016 sec

-- 16:42:28	INSERT INTO tutorial (course_id, tutorial_code, schedule, capacity, instructor_id) VALUES (1, 101, '{"day": "Monday", "time": "10:00 AM"}', -10, 'T12345')	Error Code: 1216. Cannot add or update a child row: a foreign key constraint fails	0.011 sec

-- 16:42:32	INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code) VALUES ('S20251100', 1, 101, NULL)	Error Code: 1216. Cannot add or update a child row: a foreign key constraint fails	0.012 sec

-- 16:42:38	INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code) VALUES ('INVALID123', 999, 101, 201)	Error Code: 1216. Cannot add or update a child row: a foreign key constraint fails	0.0076 sec