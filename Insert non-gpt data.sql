INSERT INTO course (year, term, course_code, course_name, course_level, credits, offered_by) VALUES
(2025, 'fall', 'INF1343', 'Data Modeling and Database Design', 'graduate', 0.5, 'Faculty of Information');

INSERT INTO teaching_staff (staff_id, faculty_name, first_name, last_name, email, phone, employment_type, position) VALUES
('TS10000011', 'Faculty of Information', 'Periklis', 'Andritsos', 'periklis.andritsos@utoronto.ca', '416-978-1773', 'full-time', 'professor');

INSERT INTO section (course_id, section_code, schedule, capacity, instructor_id)
VALUES (
    11,
    101,
    '{"Monday":["13:00-15:00"], "Wednesday":["13:00-15:00"]}',
    50,
    'TS10000011'
);

INSERT INTO tutorial (course_id, tutorial_code, schedule, capacity, instructor_id)
VALUES (
    11,
    101,
    '{"Friday":["11:00-12:00"]}',
    25,
    'TS10000011'
);

-- creating test data
-- STEP 1: Create Applicant
INSERT INTO applicant (first_name, last_name, email, phone, date_of_birth)
VALUES ('Alex', 'Morgan', 'alex.morgan@uoft.ca', '416-555-1010', '2000-08-12');

-- STEP 2: Submit Application for "Master of Information"
INSERT INTO application (applicant_id, applied_program, application_status, application_date)
VALUES (11, 'Master of Information', 'admitted', '2025-03-20');

-- Add supporting documents to Alex's application (assumes application_id = 11)
-- Adjust if needed with a SELECT to confirm the ID

INSERT INTO supporting_document (application_id, document_name, file_path) VALUES
(11, 'Transcript', '/files/app11/transcript.pdf'),
(11, 'Resume', '/files/app11/resume.pdf'),
(11, 'Statement of Purpose', '/files/app11/statement.pdf'),
(11, 'Reference Letter - 1', '/files/app11/reference1.pdf'),
(11, 'Reference Letter - 2', '/files/app11/reference2.pdf');


-- STEP 3: Create Admission Offer (accepted)
INSERT INTO admission_offer (application_id, applicant_decision_deadline, applicant_decision)
VALUES (11, '2025-04-15', 'accepted');

-- STEP 4: Create Student (linking to latest application_id)
INSERT INTO student (
    student_number, application_id, first_name, last_name, email, phone, date_of_birth,
    entry_year, is_domestic, is_full_time, degree_type, program_name
)
VALUES (
    'S20251100',
    (SELECT application_id FROM application WHERE applicant_id = (SELECT applicant_id FROM applicant WHERE email = 'alex.morgan@uoft.ca') ORDER BY application_id DESC LIMIT 1),
    'Alex', 'Morgan', 'alex.morgan@uoft.ca', '416-555-1010', '2000-08-12',
    2025, TRUE, TRUE, 'master', 'Master of Information'
);

-- STEP 5: Enroll in Course (course_id=11, section_code=101, tutorial_code=101)
INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code)
VALUES ('S20251100', 11, 101, 101);



