USE uoft_student_db;  -- or whichever schema contains your table

INSERT INTO faculty (faculty_name, administrator, phone, email) VALUES
('Faculty of Arts and Science', 'Dr. Amelia Clarke', '416-123-4567', 'artsci@uoft.ca'),
('Faculty of Engineering', 'Dr. Robert Langdon', '416-234-5678', 'engineering@uoft.ca'),
('Faculty of Medicine', 'Dr. Susan Park', '416-345-6789', 'medicine@uoft.ca'),
('Faculty of Information', 'Dr. Kelvin Ng', '416-456-7890', 'info@uoft.ca'),
('Rotman School of Management', 'Dr. Anna Belle', '416-567-8901', 'rotman@uoft.ca'),
('Faculty of Law', 'Dr. Jordan Miles', '416-678-9012', 'law@uoft.ca'),
('Faculty of Music', 'Dr. Chloe Hart', '416-789-0123', 'music@uoft.ca'),
('Faculty of Dentistry', 'Dr. Isaac Wu', '416-890-1234', 'dentistry@uoft.ca'),
('Faculty of Nursing', 'Dr. Megan Zhou', '416-901-2345', 'nursing@uoft.ca'),
('Ontario Institute for Studies in Education', 'Dr. Leo James', '416-012-3456', 'oise@uoft.ca');

INSERT INTO program (program_name, degree_type, credits_required, offered_by) VALUES
('Bachelor of Computer Science', 'bachelor', 20, 'Faculty of Arts and Science'),
('Bachelor of Music', 'bachelor', 18, 'Faculty of Music'),
('Bachelor of Nursing', 'bachelor', 22, 'Faculty of Nursing'),
('Master of Information', 'master', 10, 'Faculty of Information'),
('Master of Business Administration', 'master', 12, 'Rotman School of Management'),
('Master of Engineering', 'master', 11, 'Faculty of Engineering'),
('PhD in Law', 'phd', 16, 'Faculty of Law'),
('PhD in Computer Science', 'phd', 18, 'Faculty of Arts and Science'),
('PhD in Education', 'phd', 15, 'Ontario Institute for Studies in Education'),
('PhD in Biomedical Engineering', 'phd', 20, 'Faculty of Medicine');

INSERT INTO teaching_staff (staff_id, faculty_name, first_name, last_name, email, phone, employment_type, position) VALUES
('TS10000001', 'Faculty of Arts and Science', 'Alice', 'Nguyen', 'alice.nguyen@uoft.ca', '416-100-0001', 'full-time', 'professor'),
('TS10000002', 'Faculty of Engineering', 'Bob', 'Chen', 'bob.chen@uoft.ca', '416-100-0002', 'full-time', 'professor'),
('TS10000003', 'Faculty of Medicine', 'Carol', 'Smith', 'carol.smith@uoft.ca', '416-100-0003', 'part-time', 'teaching_assistant'),
('TS10000004', 'Faculty of Law', 'David', 'Lee', 'david.lee@uoft.ca', '416-100-0004', 'full-time', 'professor'),
('TS10000005', 'Faculty of Information', 'Eva', 'Patel', 'eva.patel@uoft.ca', '416-100-0005', 'part-time', 'teaching_assistant'),
('TS10000006', 'Rotman School of Management', 'Frank', 'Kim', 'frank.kim@uoft.ca', '416-100-0006', 'full-time', 'professor'),
('TS10000007', 'Faculty of Music', 'Grace', 'Tang', 'grace.tang@uoft.ca', '416-100-0007', 'full-time', 'professor'),
('TS10000008', 'Faculty of Dentistry', 'Henry', 'Zhou', 'henry.zhou@uoft.ca', '416-100-0008', 'part-time', 'teaching_assistant'),
('TS10000009', 'Faculty of Nursing', 'Isabel', 'Ali', 'isabel.ali@uoft.ca', '416-100-0009', 'full-time', 'professor'),
('TS10000010', 'Ontario Institute for Studies in Education', 'Jack', 'Wong', 'jack.wong@uoft.ca', '416-100-0010', 'part-time', 'teaching_assistant');

INSERT INTO bachelor (program_name, specialization) VALUES
('Bachelor of Computer Science', 'Artificial Intelligence'),
('Bachelor of Computer Science', 'Software Engineering'),
('Bachelor of Computer Science', 'Data Science'),
('Bachelor of Music', 'Piano Performance'),
('Bachelor of Music', 'Music Theory'),
('Bachelor of Nursing', 'General Nursing'),
('Bachelor of Nursing', 'Pediatric Nursing'),
('Bachelor of Nursing', 'Mental Health'),
('Bachelor of Computer Science', 'Cybersecurity'),
('Bachelor of Music', 'Vocal Performance');

INSERT INTO master (program_name, master_type) VALUES
('Master of Information', 'course-based'),
('Master of Information', 'thesis-based'),
('Master of Business Administration', 'MBA'),
('Master of Engineering', 'project-based'),
('Master of Engineering', 'course-based'),
('Master of Business Administration', 'course-based'),
('Master of Information', 'project-based'),
('Master of Engineering', 'thesis-based'),
('Master of Business Administration', 'project-based'),
('Master of Information', 'MBA');

INSERT INTO phd (program_name, research_area) VALUES
('PhD in Law', 'Constitutional Law'),
('PhD in Law', 'International Law'),
('PhD in Computer Science', 'Machine Learning'),
('PhD in Computer Science', 'Systems'),
('PhD in Education', 'Curriculum Studies'),
('PhD in Education', 'Education Policy'),
('PhD in Biomedical Engineering', 'Neuroengineering'),
('PhD in Biomedical Engineering', 'Biomaterials'),
('PhD in Biomedical Engineering', 'Imaging'),
('PhD in Computer Science', 'Human-Computer Interaction');

INSERT INTO applicant (first_name, last_name, email, phone, date_of_birth) VALUES
('Liam', 'Wong', 'liam.wong@mail.com', '647-111-0001', '2002-03-12'),
('Emma', 'Chen', 'emma.chen@mail.com', '647-111-0002', '2001-11-08'),
('Noah', 'Singh', 'noah.singh@mail.com', '647-111-0003', '2000-07-20'),
('Olivia', 'Nguyen', 'olivia.nguyen@mail.com', '647-111-0004', '1999-05-01'),
('Elijah', 'Patel', 'elijah.patel@mail.com', '647-111-0005', '1998-09-15'),
('Sophia', 'Brown', 'sophia.brown@mail.com', '647-111-0006', '1997-01-22'),
('William', 'Ali', 'william.ali@mail.com', '647-111-0007', '2001-04-17'),
('Ava', 'Zhou', 'ava.zhou@mail.com', '647-111-0008', '2000-12-03'),
('James', 'Kim', 'james.kim@mail.com', '647-111-0009', '2002-02-25'),
('Isabella', 'Lee', 'isabella.lee@mail.com', '647-111-0010', '2003-06-30');

INSERT INTO application (applicant_id, applied_program, application_status, application_date, decision_date) VALUES
(1, 'Bachelor of Computer Science', 'admitted', '2023-01-10', '2023-02-15'),
(2, 'Bachelor of Music', 'rejected', '2023-01-11', '2023-03-01'),
(3, 'Master of Information', 'admitted', '2023-02-01', '2023-03-10'),
(4, 'PhD in Education', 'admitted', '2023-02-15', '2023-04-20'),
(5, 'PhD in Biomedical Engineering', 'submitted-pending', '2023-03-12', NULL),
(6, 'Bachelor of Nursing', 'admitted', '2023-03-25', '2023-04-30'),
(7, 'Master of Engineering', 'rejected', '2023-03-20', '2023-04-28'),
(8, 'Master of Business Administration', 'admitted', '2023-04-05', '2023-05-10'),
(9, 'PhD in Computer Science', 'admitted', '2023-04-18', '2023-05-20'),
(10, 'Bachelor of Computer Science', 'submitted-pending', '2023-04-30', NULL);

INSERT INTO admission_offer (application_id, applicant_decision_deadline, applicant_decision) VALUES
(1, '2023-03-15', 'accepted'),
(3, '2023-04-15', 'accepted'),
(4, '2023-05-15', 'accepted'),
(6, '2023-05-30', 'declined'),
(8, '2023-06-01', 'pending'),
(9, '2023-06-05', 'accepted');

INSERT INTO supporting_document (application_id, document_name, file_path) VALUES
(1, 'Transcript', '/files/app1/transcript.pdf'),
(1, 'Resume', '/files/app1/resume.pdf'),
(3, 'Transcript', '/files/app3/transcript.pdf'),
(3, 'Reference Letter', '/files/app3/reference.pdf'),
(4, 'Research Proposal', '/files/app4/proposal.pdf'),
(6, 'Transcript', '/files/app6/transcript.pdf'),
(8, 'Resume', '/files/app8/resume.pdf'),
(9, 'Transcript', '/files/app9/transcript.pdf'),
(9, 'Cover Letter', '/files/app9/cover.pdf'),
(10, 'Transcript', '/files/app10/transcript.pdf');

INSERT INTO course (year, term, course_code, course_name, course_level, credits, offered_by) VALUES
(2024, 'fall-winter', 'INF7203', 'Anything ability million', 'undergraduate', 0.25, 'Faculty of Arts and Science'),
(2025, 'winter', 'INF1114', 'Reality matter', 'undergraduate', 1.00, 'Faculty of Arts and Science'),
(2024, 'fall-winter', 'INF4869', 'Tree tell fast', 'graduate', 0.50, 'Faculty of Information'),
(2024, 'fall-winter', 'INF1668', 'Eight near', 'undergraduate', 1.00, 'Faculty of Arts and Science'),
(2023, 'fall', 'INF5103', 'Now', 'graduate', 1.00, 'Faculty of Information'),
(2025, 'summer', 'INF2159', 'Cloud coding data', 'undergraduate', 0.50, 'Faculty of Engineering'),
(2023, 'winter', 'INF3344', 'Design logic interface', 'graduate', 1.00, 'Faculty of Information'),
(2025, 'fall', 'INF8001', 'AI decision systems', 'graduate', 0.25, 'Faculty of Information'),
(2024, 'fall', 'INF1204', 'Statistics for Info', 'undergraduate', 0.50, 'Faculty of Arts and Science'),
(2023, 'fall-winter', 'INF4420', 'Digital platforms UX', 'graduate', 1.00, 'Faculty of Information');

INSERT INTO section (course_id, section_code, schedule, capacity, instructor_id) VALUES
(1, 1, '{"Monday":["10:00-11:30"],"Wednesday":["10:00-11:30"]}', 40, 'TS10000001'),
(2, 1, '{"Tuesday":["09:00-10:30"],"Thursday":["09:00-10:30"]}', 35, 'TS10000002'),
(3, 1, '{"Monday":["14:00-15:30"],"Friday":["14:00-15:30"]}', 30, 'TS10000005'),
(4, 1, '{"Wednesday":["13:00-14:30"]}', 25, 'TS10000001'),
(5, 1, '{"Tuesday":["10:00-11:30"],"Thursday":["10:00-11:30"]}', 40, 'TS10000005'),
(6, 1, '{"Monday":["16:00-17:30"],"Wednesday":["16:00-17:30"]}', 20, 'TS10000002'),
(7, 1, '{"Friday":["09:00-12:00"]}', 15, 'TS10000005'),
(8, 1, '{"Thursday":["14:00-17:00"]}', 20, 'TS10000006'),
(9, 1, '{"Monday":["10:00-11:30"]}', 30, 'TS10000001'),
(10, 1, '{"Wednesday":["15:00-17:00"]}', 25, 'TS10000005');

INSERT INTO tutorial (course_id, tutorial_code, schedule, capacity, instructor_id) VALUES
(1, 1, '{"Friday":["10:00-11:00"]}', 20, 'TS10000003'),
(2, 1, '{"Friday":["11:00-12:00"]}', 25, 'TS10000003'),
(3, 1, '{"Thursday":["14:00-15:00"]}', 15, 'TS10000005'),
(4, 1, '{"Tuesday":["13:00-14:00"]}', 18, 'TS10000005'),
(5, 1, '{"Monday":["09:00-10:00"]}', 20, 'TS10000005'),
(6, 1, '{"Wednesday":["12:00-13:00"]}', 20, 'TS10000003'),
(7, 1, '{"Thursday":["10:00-11:00"]}', 20, 'TS10000008'),
(8, 1, '{"Friday":["15:00-16:00"]}', 20, 'TS10000005'),
(9, 1, '{"Monday":["14:00-15:00"]}', 20, 'TS10000003'),
(10, 1, '{"Wednesday":["09:00-10:00"]}', 20, 'TS10000008');

INSERT INTO student (
    student_number, application_id, first_name, last_name, email, phone, date_of_birth,
    entry_year, is_domestic, is_full_time, degree_type, program_name
) VALUES
('S20230001', 1, 'Liam', 'Wong', 'liam@student.uoft.ca', '647-111-0001', '2002-03-12', 2023, TRUE, TRUE, 'bachelor', 'Bachelor of Computer Science'),
('S20230002', 3, 'Noah', 'Singh', 'noah@student.uoft.ca', '647-111-0003', '2000-07-20', 2023, TRUE, FALSE, 'master', 'Master of Information'),
('S20230003', 4, 'Olivia', 'Nguyen', 'olivia@student.uoft.ca', '647-111-0004', '1999-05-01', 2023, FALSE, TRUE, 'phd', 'PhD in Education'),
('S20230004', 6, 'Sophia', 'Brown', 'sophia@student.uoft.ca', '647-111-0006', '1997-01-22', 2023, TRUE, TRUE, 'bachelor', 'Bachelor of Nursing'),
('S20230005', 8, 'Ava', 'Zhou', 'ava@student.uoft.ca', '647-111-0008', '2000-12-03', 2023, FALSE, TRUE, 'master', 'Master of Business Administration'),
('S20230006', 9, 'James', 'Kim', 'james@student.uoft.ca', '647-111-0009', '2002-02-25', 2023, TRUE, TRUE, 'phd', 'PhD in Computer Science');

INSERT INTO enrollment (student_number, course_id, section_code, tutorial_code) VALUES
('S20230001', 1, 1, 1),
('S20230001', 2, 1, 1),
('S20230002', 3, 1, 1),
('S20230003', 4, 1, 1),
('S20230004', 5, 1, 1),
('S20230005', 6, 1, 1),
('S20230006', 7, 1, 1),
('S20230001', 8, 1, 1),
('S20230002', 9, 1, 1),
('S20230003', 10, 1, 1);






