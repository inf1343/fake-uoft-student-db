CREATE DATABASE uoft_student_db;
USE uoft_student_db; 

CREATE TABLE faculty(
    faculty_name VARCHAR(50) PRIMARY KEY NOT NULL,
    administrator VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE program(
    program_name VARCHAR(50) PRIMARY KEY NOT NULL, -- e.g. 'bachelor of information', 'master of science'
    degree_type ENUM('bachelor','master','phd') NOT NULL,
    credits_required INT NOT NULL, 
    offered_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_name)
);

CREATE TABLE teaching_staff(
    staff_id CHAR(10) PRIMARY KEY,
    faculty_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    employment_type ENUM('full-time','part-time') NOT NULL, 
    position ENUM('professor','teaching_assistant') NOT NULL,
    FOREIGN KEY (faculty_name) REFERENCES faculty(faculty_name)
);


-- a list of possible options for bachelor/master/phd programs
CREATE TABLE bachelor(
    program_name VARCHAR(50),
    specialization VARCHAR(50),
    PRIMARY KEY (program_name, specialization),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);

CREATE TABLE master(
    program_name VARCHAR(50),
    master_type ENUM('course-based','thesis-based','project-based','MBA') NOT NULL,
    PRIMARY KEY (program_name, master_type),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);

CREATE TABLE phd(
    program_name VARCHAR(50) NOT NULL,
    research_area VARCHAR(50) NOT NULL,
    PRIMARY KEY (program_name, research_area),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);


-- applicant, application, admission

CREATE TABLE applicant(
	applicant_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE NOT NULL
);

CREATE TABLE application(
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id INT NOT NULL,
    applied_program VARCHAR(50) NOT NULL,
    application_status ENUM('not-submitted','submitted-pending','admitted','rejected') NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    decision_date TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id),
    FOREIGN KEY (applied_program) REFERENCES program(program_name)
);

-- admission: program sends out all admissions to qualified applicants
-- whenever an application has application_status = 'accepted', an admission is created here 
-- an applicant can have multiple admissions, but only one is accepted.
-- it should be a subtype of application, so it inherit the attribures of application 
CREATE TABLE admission_offer(
    application_id INT PRIMARY KEY,
    applicant_decision_deadline DATE NOT NULL,
    applicant_decision ENUM ('pending','accepted','declined') NOT NULL,
    FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);

CREATE TABLE supporting_document( -- weak entity
    application_id INT NOT NULL,
    document_name VARCHAR(50) NOT NULL,
    -- document can be transcript, resume, cover letter, reference letter, or others
    file_path VARCHAR(500) NOT NULL, -- assume after upload, the file is stored in the school's server
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (application_id, document_name),
    FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);


-- COURSE AND STUDENT

CREATE TABLE course(
    course_id INT AUTO_INCREMENT PRIMARY KEY, 
    year YEAR NOT NULL,
    term ENUM('fall','winter','summer','fall-winter') NOT NULL,
    course_code VARCHAR(10) NOT NULL, -- e.g. CSC2515 
    course_name VARCHAR(50) NOT NULL, -- e.g. 'Intro to ML'
    course_level ENUM('undergraduate','graduate') NOT NULL, -- where course_level = 'undergraduate'
    credits DECIMAL(4,2) NOT NULL, -- 0.25, 0.5, 1, etc.
    offered_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_name)
);

-- prerequisite: not directly related to course (a separate entity)
-- only for referencing/checking when a student wants to enroll in a course
-- other reasons: 
-- flexibility (e.g., allowing placeholder prerequisites for future courses).
-- can manually manage prerequisite courses outside the database constraints.
-- don't need to deal with cascading deletes (e.g., a course deletion would require removing its prerequisite records).
CREATE TABLE prerequisite( 
     course_code VARCHAR(10) NOT NULL,
     prerequisite_course_code VARCHAR(10) NOT NULL,
     PRIMARY KEY (course_code, prerequisite_course_code)
);

CREATE TABLE section( -- weak entity with composite key
    course_id INT NOT NULL, -- reference 
    section_code INT NOT NULL, -- e.g. 01, 02, 03
    schedule JSON NOT NULL, 
        -- e.g. {
        --     "Monday": ["10:00-11:30", "14:00-15:30"],
        --     "Wednesday": ["10:00-11:30"],
        --     "Friday": ["14:00-15:30"]
        -- }
    capacity INT NOT NULL,
    instructor_id CHAR(10) NOT NULL, -- only include one main instructor here
    PRIMARY KEY (course_id, section_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES teaching_staff(staff_id)
);

CREATE TABLE tutorial( -- weak entity 
    course_id INT NOT NULL,
    tutorial_code INT NOT NULL,
    schedule JSON NOT NULL,
    capacity INT NOT NULL,
    instructor_id CHAR(10) NOT NULL,
    PRIMARY KEY (course_id, tutorial_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES teaching_staff(staff_id)
);

CREATE TABLE student( 
    -- make sure applicant data can be transferred here directly 
    -- only include current students (no alumni); 
    -- if a student turns from an undergrad to a grad, 
    -- should use update instead of creating a new entry
    
    student_number CHAR(10) PRIMARY KEY,
    application_id INT NOT NULL, -- reference to application_id so that we can retrive the applicants' data
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    entry_year YEAR NOT NULL, 
    is_domestic BOOLEAN NOT NULL,
    is_full_time BOOLEAN NOT NULL,
    degree_type ENUM('bachelor','master','phd') NOT NULL,
    program_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (application_id) REFERENCES application(application_id),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);

CREATE TABLE enrollment( -- junction table
    student_number CHAR(10) NOT NULL,
    course_id INT NOT NULL,
    section_code INT NOT NULL,
    tutorial_code INT NULL, -- nullable
    PRIMARY KEY (student_number, course_id),
    FOREIGN KEY (student_number) REFERENCES student(student_number),
    -- FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (course_id, section_code) REFERENCES section(course_id, section_code),
    FOREIGN KEY (course_id, tutorial_code) REFERENCES tutorial(course_id, tutorial_code)
);

------BELOW: DATA POPULATION------
INSERT INTO faculty(faculty_name,administrator,phone,email) VALUES
    ('Faculty of Arts and Science','Dr. Amelia Clarke','416-123-4567','artsci@uoft.ca'),
    ('Faculty of Dentistry','Dr. Isaac Wu','416-890-1234','dentistry@uoft.ca'),
    ('Faculty of Engineering','Dr. Robert Langdon','416-234-5678','engineering@uoft.ca'),
    ('Faculty of Information','Dr. Kelvin Ng','416-456-7890','info@uoft.ca'),
    ('Faculty of Kinesiology','Dr. Steve Choi','416-555-2222','kin@uoft.ca'),
    ('Faculty of Law','Dr. Jordan Miles','416-678-9012','law@uoft.ca'),
    ('Faculty of Medicine','Dr. Susan Park','416-345-6789','medicine@uoft.ca'),
    ('Faculty of Music','Dr. Chloe Hart','416-789-0123','music@uoft.ca'),
    ('Faculty of Nursing','Dr. Megan Zhou','416-901-2345','nursing@uoft.ca'),
    ('Ontario Institute for Studies in Education','Dr. Leo James','416-012-3456','oise@uoft.ca'),
    ('Rotman School of Management','Dr. Anna Belle','416-567-8901','rotman@uoft.ca');

INSERT INTO program(program_name,degree_type,credits_required,offered_by) VALUES
    ('Bachelor of Computer Science','bachelor',20,'Faculty of Arts and Science'),
    ('Bachelor of Kinesiology','bachelor',16,'Faculty of Kinesiology'),
    ('Bachelor of Music','bachelor',18,'Faculty of Music'),
    ('Bachelor of Nursing','bachelor',22,'Faculty of Nursing'),
    ('Master of Business Administration','master',12,'Rotman School of Management'),
    ('Master of Engineering','master',11,'Faculty of Engineering'),
    ('Master of Information','master',10,'Faculty of Information'),
    ('PhD in Biomedical Engineering','phd',20,'Faculty of Medicine'),
    ('PhD in Computer Science','phd',18,'Faculty of Arts and Science'),
    ('PhD in Education','phd',15,'Ontario Institute for Studies in Education'),
    ('PhD in Law','phd',16,'Faculty of Law');

INSERT INTO teaching_staff(staff_id,faculty_name,first_name,last_name,email,phone,employment_type,position) VALUES
    ('TS10000001','Faculty of Arts and Science','Alice','Nguyen','alice.nguyen@uoft.ca','416-100-0001','full-time','professor'),
    ('TS10000002','Faculty of Engineering','Bob','Chen','bob.chen@uoft.ca','416-100-0002','full-time','professor'),
    ('TS10000003','Faculty of Medicine','Carol','Smith','carol.smith@uoft.ca','416-100-0003','part-time','teaching_assistant'),
    ('TS10000004','Faculty of Law','David','Lee','david.lee@uoft.ca','416-100-0004','full-time','professor'),
    ('TS10000005','Faculty of Information','Eva','Patel','eva.patel@uoft.ca','416-100-0005','part-time','teaching_assistant'),
    ('TS10000006','Rotman School of Management','Frank','Kim','frank.kim@uoft.ca','416-100-0006','full-time','professor'),
    ('TS10000007','Faculty of Music','Grace','Tang','grace.tang@uoft.ca','416-100-0007','full-time','professor'),
    ('TS10000008','Faculty of Dentistry','Henry','Zhou','henry.zhou@uoft.ca','416-100-0008','part-time','teaching_assistant'),
    ('TS10000009','Faculty of Nursing','Isabel','Ali','isabel.ali@uoft.ca','416-100-0009','full-time','professor'),
    ('TS10000010','Ontario Institute for Studies in Education','Jack','Wong','jack.wong@uoft.ca','416-100-0010','part-time','teaching_assistant'),
    ('TS10000011','Faculty of Information','Periklis','Andritsos','periklis.andritsos@utoronto.ca','416-978-1773','full-time','professor'),
    ('TS10000120','Faculty of Arts and Science','Kevin','Li','kevin.li@uoft.ca','416-555-1001','full-time','professor'),
    ('TS10000121','Faculty of Arts and Science','Linda','Zhao','linda.zhao@uoft.ca','416-555-1002','full-time','professor'),
    ('TS10000122','Faculty of Arts and Science','Michael','Green','michael.green@uoft.ca','416-555-1003','full-time','professor'),
    ('TS10000123','Faculty of Arts and Science','Natalie','Chan','natalie.chan@uoft.ca','416-555-1004','full-time','professor'),
    ('TS10000124','Faculty of Arts and Science','Owen','Park','owen.park@uoft.ca','416-555-1005','full-time','professor'),
    ('TS10000125','Faculty of Arts and Science','Rachel','Kim','rachel.kim@uoft.ca','416-555-1006','full-time','professor'),
    ('TS10000126','Faculty of Arts and Science','Victor','Patel','victor.patel@uoft.ca','416-555-1007','full-time','professor'),
    ('TS10000130','Faculty of Arts and Science','Karen','Wong','karen.wong@uoft.ca','416-555-1010','part-time','teaching_assistant'),
    ('TS10000131','Faculty of Arts and Science','Leo','Tan','leo.tan@uoft.ca','416-555-1011','part-time','teaching_assistant'),
    ('TS10000132','Faculty of Arts and Science','Monica','Singh','monica.singh@uoft.ca','416-555-1012','part-time','teaching_assistant'),
    ('TS10000133','Faculty of Arts and Science','Nina','Patel','nina.patel@uoft.ca','416-555-1013','part-time','teaching_assistant'),
    ('TS10000134','Faculty of Arts and Science','Quentin','Lam','quentin.lam@uoft.ca','416-555-1014','part-time','teaching_assistant'),
    ('TS10000135','Faculty of Arts and Science','Ryan','Lee','ryan.lee@uoft.ca','416-555-1015','part-time','teaching_assistant'),
    ('TS10000136','Faculty of Arts and Science','Sophia','Nair','sophia.nair@uoft.ca','416-555-1016','part-time','teaching_assistant'),
    ('TS10000140','Faculty of Kinesiology','Kyle','Zhang','kyle.zhang@uoft.ca','416-555-1020','full-time','professor'),
    ('TS10000141','Faculty of Kinesiology','Nina','Brooks','nina.brooks@uoft.ca','416-555-1021','full-time','professor'),
    ('TS10000142','Faculty of Kinesiology','Peter','James','peter.james@uoft.ca','416-555-1022','full-time','professor'),
    ('TS10000143','Faculty of Kinesiology','Tiffany','Choi','tiffany.choi@uoft.ca','416-555-1023','full-time','professor'),
    ('TS10000150','Faculty of Kinesiology','Rachel','Lin','rachel.lin@uoft.ca','416-555-1030','part-time','teaching_assistant'),
    ('TS10000151','Faculty of Kinesiology','Steven','Yu','steven.yu@uoft.ca','416-555-1031','part-time','teaching_assistant'),
    ('TS10000152','Faculty of Kinesiology','Vanessa','Ho','vanessa.ho@uoft.ca','416-555-1032','part-time','teaching_assistant'),
    ('TS10000153','Faculty of Kinesiology','William','Sun','william.sun@uoft.ca','416-555-1033','part-time','teaching_assistant');

INSERT INTO bachelor(program_name,specialization) VALUES
    ('Bachelor of Computer Science','Artificial Intelligence'),
    ('Bachelor of Computer Science','Cybersecurity'),
    ('Bachelor of Computer Science','Data Science'),
    ('Bachelor of Computer Science','Software Engineering'),
    ('Bachelor of Kinesiology','edk'),
    ('Bachelor of Kinesiology','npsc'),
    ('Bachelor of Music','Music Theory'),
    ('Bachelor of Music','Piano Performance'),
    ('Bachelor of Music','Vocal Performance'),
    ('Bachelor of Nursing','General Nursing'),
    ('Bachelor of Nursing','Mental Health'),
    ('Bachelor of Nursing','Pediatric Nursing');

INSERT INTO master(program_name,specialization) VALUES
    ('Master of Business Administration','course-based'),
    ('Master of Business Administration','project-based'),
    ('Master of Business Administration','MBA'),
    ('Master of Engineering','course-based'),
    ('Master of Engineering','thesis-based'),
    ('Master of Engineering','project-based'),
    ('Master of Information','course-based'),
    ('Master of Information','thesis-based'),
    ('Master of Information','project-based'),
    ('Master of Information','MBA');

INSERT INTO phd(program_name,specialization) VALUES
    ('PhD in Biomedical Engineering','Biomaterials'),
    ('PhD in Biomedical Engineering','Imaging'),
    ('PhD in Biomedical Engineering','Neuroengineering'),
    ('PhD in Computer Science','Human-Computer Interaction'),
    ('PhD in Computer Science','Machine Learning'),
    ('PhD in Computer Science','Systems'),
    ('PhD in Education','Curriculum Studies'),
    ('PhD in Education','Education Policy'),
    ('PhD in Law','Constitutional Law'),
    ('PhD in Law','International Law');

INSERT INTO applicant(first_name,last_name,email,phone,date_of_birth) VALUES
    ('Liam','Wong','liam.wong@mail.com','647-111-0001','2002-03-12'),
    ('Emma','Chen','emma.chen@mail.com','647-111-0002','2001-11-08'),
    ('Noah','Singh','noah.singh@mail.com','647-111-0003','2000-07-20'),
    ('Olivia','Nguyen','olivia.nguyen@mail.com','647-111-0004','1999-05-01'),
    ('Elijah','Patel','elijah.patel@mail.com','647-111-0005','1998-09-15'),
    ('Sophia','Brown','sophia.brown@mail.com','647-111-0006','1997-01-22'),
    ('William','Ali','william.ali@mail.com','647-111-0007','2001-04-17'),
    ('Ava','Zhou','ava.zhou@mail.com','647-111-0008','2000-12-03'),
    ('James','Kim','james.kim@mail.com','647-111-0009','2002-02-25'),
    ('Isabella','Lee','isabella.lee@mail.com','647-111-0010','2003-06-30'),
    ('Alex','Morgan','alex.morgan@uoft.ca','416-555-1010','2000-08-12'),
    ('William','Chen','william.chen@student.uoft.ca','647-222-1001','2004-06-18'),
    ('Yuna','Park','yuna.park@student.uoft.ca','647-222-1002','1998-11-02'),
    ('Ethan','Li','ethan.li@student.uoft.ca','647-222-1003','2003-09-25');

INSERT INTO application(applicant_id,applied_program,application_status,application_date,decision_date) VALUES
    (1,'Bachelor of Computer Science','admitted','2023-01-10 00:00:00','2023-02-15 00:00:00'),
    (2,'Bachelor of Music','rejected','2023-01-11 00:00:00','2023-03-01 00:00:00'),
    (3,'Master of Information','admitted','2023-02-01 00:00:00','2023-03-10 00:00:00'),
    (4,'PhD in Education','admitted','2023-02-15 00:00:00','2023-04-20 00:00:00'),
    (4,'PhD in Biomedical Engineering','submitted-pending','2023-03-12 00:00:00',NULL),
    (6,'Bachelor of Nursing','admitted','2023-03-25 00:00:00','2023-04-30 00:00:00'),
    (8,'Master of Engineering','rejected','2023-03-20 00:00:00','2023-04-28 00:00:00'),
    (8,'Master of Business Administration','admitted','2023-04-05 00:00:00','2023-05-10 00:00:00'),
    (9,'PhD in Computer Science','admitted','2023-04-18 00:00:00','2023-05-20 00:00:00'),
    (8,'Bachelor of Computer Science','submitted-pending','2023-04-30 00:00:00',NULL),
    (11,'Master of Information','admitted','2025-03-20 00:00:00',NULL),
    (12,'Bachelor of Computer Science','admitted','2024-03-01 10:30:00','2024-03-15 14:00:00'),
    (13,'PhD in Computer Science','admitted','2024-03-02 09:15:00','2024-03-20 11:45:00'),
    (14,'Bachelor of Kinesiology','admitted','2024-03-05 13:00:00','2024-03-22 15:30:00');

INSERT INTO admission_offer(application_id,applicant_decision_deadline,applicant_decision) VALUES
    (1,'2023-03-15','accepted'),
    (3,'2023-04-15','accepted'),
    (4,'2023-05-15','accepted'),
    (6,'2023-05-30','declined'),
    (8,'2023-06-01','pending'),
    (9,'2023-06-05','accepted'),
    (11,'2024-04-30','declined'),
    (12,'2024-04-15','accepted'),
    (13,'2024-04-20','accepted'),
    (14,'2024-04-22','accepted');

INSERT INTO supporting_document(application_id,document_name,file_path,upload_date) VALUES
    (1,'Resume','/files/app1/resume.pdf','2025-03-25 01:54:21'),
    (1,'Transcript','/files/app1/transcript.pdf','2025-03-25 01:54:21'),
    (3,'Reference Letter','/files/app3/reference.pdf','2025-03-25 01:54:21'),
    (3,'Transcript','/files/app3/transcript.pdf','2025-03-25 01:54:21'),
    (4,'Research Proposal','/files/app4/proposal.pdf','2025-03-25 01:54:21'),
    (6,'Transcript','/files/app6/transcript.pdf','2025-03-25 01:54:21'),
    (8,'Resume','/files/app8/resume.pdf','2025-03-25 01:54:21'),
    (9,'Cover Letter','/files/app9/cover.pdf','2025-03-25 01:54:21'),
    (9,'Transcript','/files/app9/transcript.pdf','2025-03-25 01:54:21'),
    (10,'Transcript','/files/app10/transcript.pdf','2025-03-25 01:54:21'),
    (11,'Reference Letter - 1','/files/app11/reference1.pdf','2025-03-25 03:38:45'),
    (11,'Reference Letter - 2','/files/app11/reference2.pdf','2025-03-25 03:38:45'),
    (11,'Resume','/files/app11/resume.pdf','2025-03-25 03:38:45'),
    (11,'Statement of Purpose','/files/app11/statement.pdf','2025-03-25 03:38:45'),
    (11,'Transcript','/files/app11/transcript.pdf','2025-03-25 03:38:45');

INSERT INTO course(course_id,year,term,course_code,course_name,course_level,credits,offered_by) VALUES
    (1,2024,'fall-winter','INF7203','Anything ability million','undergraduate',0.25,'Faculty of Arts and Science'),
    (2,2025,'winter','INF1114','Reality matter','undergraduate',1.00,'Faculty of Arts and Science'),
    (3,2024,'fall-winter','INF4869','Tree tell fast','graduate',0.50,'Faculty of Information'),
    (4,2024,'fall-winter','INF1668','Eight near','undergraduate',1.00,'Faculty of Arts and Science'),
    (5,2023,'fall','INF5103','Now','graduate',1.00,'Faculty of Information'),
    (6,2025,'summer','INF2159','Cloud coding data','undergraduate',0.50,'Faculty of Engineering'),
    (7,2023,'winter','INF3344','Design logic interface','graduate',1.00,'Faculty of Information'),
    (8,2025,'fall','INF8001','AI decision systems','graduate',0.25,'Faculty of Information'),
    (9,2024,'fall','INF1204','Statistics for Info','undergraduate',0.50,'Faculty of Arts and Science'),
    (10,2023,'fall-winter','INF4420','Digital platforms UX','graduate',1.00,'Faculty of Information'),
    (11,2025,'fall','INF1343','Data Modeling and Database Design','graduate',0.50,'Faculty of Information'),
    (12,2023,'fall','CSC110','Computation, Programs and Programming','undergraduate',0.50,'Faculty of Arts and Science'),
    (13,2023,'winter','CSC121','Models of Computation','undergraduate',0.50,'Faculty of Arts and Science'),
    (14,2023,'fall','CSC210','Software Construction','undergraduate',0.50,'Faculty of Arts and Science'),
    (15,2023,'winter','CSC221','Basic Algorithms and Data Structures','undergraduate',0.50,'Faculty of Arts and Science'),
    (16,2023,'fall','CSC310','Introduction to Software Enginnering','undergraduate',0.50,'Faculty of Arts and Science'),
    (17,2023,'winter','CSC330','Introduction to Machine Learning','undergraduate',0.50,'Faculty of Arts and Science'),
    (18,2023,'fall-winter','CSC502','Artificial Intelligence','graduate',1.00,'Faculty of Arts and Science'),
    (19,2023,'fall','KIN100','Education Seminar','undergraduate',0.25,'Faculty of Kinesiology'),
    (20,2023,'fall','KIN131','Human Physiology I','undergraduate',0.50,'Faculty of Kinesiology'),
    (21,2023,'winter','KIN132','Human Physiology II','undergraduate',0.50,'Faculty of Kinesiology'),
    (22,2023,'fall','KIN235','Exercise Physiology','undergraduate',0.50,'Faculty of Kinesiology'),
    (23,2023,'fall','KIN335','Advanced Application of Exercise Physiology','undergraduate',0.50,'Faculty of Kinesiology'),
    (24,2024,'fall','CSC110','Computation, Programs and Programming','undergraduate',0.50,'Faculty of Arts and Science'),
    (25,2024,'winter','CSC121','Models of Computation','undergraduate',0.50,'Faculty of Arts and Science'),
    (26,2024,'fall','CSC210','Software Construction','undergraduate',0.50,'Faculty of Arts and Science'),
    (27,2024,'winter','CSC221','Basic Algorithms and Data Structures','undergraduate',0.50,'Faculty of Arts and Science'),
    (28,2024,'fall','CSC310','Introduction to Software Enginnering','undergraduate',0.50,'Faculty of Arts and Science'),
    (29,2024,'winter','CSC330','Introduction to Machine Learning','undergraduate',0.50,'Faculty of Arts and Science'),
    (30,2024,'fall','CSC503','Artificial Intelligence II','graduate',0.50,'Faculty of Arts and Science'),
    (31,2024,'winter','CSC504','Artificial Intelligence II','graduate',0.50,'Faculty of Arts and Science'),
    (32,2024,'fall','KIN100','Education Seminar','undergraduate',0.25,'Faculty of Kinesiology'),
    (33,2024,'fall-winter','KIN133','Human Physiology','undergraduate',1.00,'Faculty of Kinesiology'),
    (34,2024,'fall','KIN235','Exercise Physiology','undergraduate',0.50,'Faculty of Kinesiology'),
    (35,2024,'fall','KIN335','Advanced Application of Exercise Physiology','undergraduate',0.50,'Faculty of Kinesiology'),
    (37,2025,'winter','CSC121','Models of Computation','undergraduate',0.50,'Faculty of Arts and Science'),
    (38,2025,'fall','CSC210','Software Construction','undergraduate',0.50,'Faculty of Arts and Science'),
    (39,2025,'winter','CSC221','Basic Algorithms and Data Structures','undergraduate',0.50,'Faculty of Arts and Science'),
    (40,2025,'fall','CSC310','Introduction to Software Enginnering','undergraduate',0.50,'Faculty of Arts and Science'),
    (41,2025,'winter','CSC330','Introduction to Machine Learning','undergraduate',0.50,'Faculty of Arts and Science'),
    (42,2025,'fall-winter','CSC502','Artificial Intelligence','graduate',1.00,'Faculty of Arts and Science');

INSERT INTO prerequisite(course_code,prerequisite_course_code) VALUES
    ('CSC210','CSC110'),
    ('CSC221','CSC121'),
    ('CSC221','CSC210'),
    ('CSC310','CSC210'),
    ('CSC310','CSC221'),
    ('CSC330','CSC210'),
    ('CSC504','CSC503'),
    ('INF2159','INF1114'),
    ('INF7203','INF2159'),
    ('KIN335','KIN235');

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
    (10, 1, '{"Wednesday":["15:00-17:00"]}', 25, 'TS10000005'),
    (11, 101, '{"Monday": ["13:00-15:00"], "Wednesday": ["13:00-15:00"]}', 50, 'TS10000011'),
    (12, 1, '{"Monday": ["09:00-10:30"], "Wednesday": ["09:00-10:30"]}', 100, 'TS10000120'),
    (12, 2, '{"Tuesday": ["14:00-15:30"], "Thursday": ["14:00-15:30"]}', 100, 'TS10000120'),
    (13, 1, '{"Monday": ["10:00-11:30"], "Wednesday": ["10:00-11:30"]}', 80, 'TS10000121'),
    (13, 2, '{"Tuesday": ["12:00-13:30"], "Thursday": ["12:00-13:30"]}', 80, 'TS10000121'),
    (13, 3, '{"Friday": ["09:00-12:00"]}', 60, 'TS10000121'),
    (24, 1, '{"Monday": ["13:00-14:30"], "Wednesday": ["13:00-14:30"]}', 100, 'TS10000122'),
    (24, 2, '{"Tuesday": ["10:00-11:30"], "Thursday": ["10:00-11:30"]}', 90, 'TS10000122'),
    (24, 3, '{"Friday": ["08:00-11:00"]}', 75, 'TS10000122'),
    (22, 1, '{"Monday": ["11:00-12:30"], "Wednesday": ["11:00-12:30"]}', 60, 'TS10000140'),
    (22, 2, '{"Tuesday": ["09:00-10:30"], "Thursday": ["09:00-10:30"]}', 60, 'TS10000140'),
    (34, 1, '{"Monday": ["15:00-16:30"], "Wednesday": ["15:00-16:30"]}', 50, 'TS10000141'),
    (34, 2, '{"Tuesday": ["11:00-12:30"], "Thursday": ["11:00-12:30"]}', 50, 'TS10000141'),
    (14, 1, '{"Monday": ["14:00-16:30"], "Wednesday": ["12:00-14:30"]}', 42, 'TS10000125'),
    (15, 1, '{"Monday": ["14:00-16:30"], "Wednesday": ["8:00-13:30"]}', 49, 'TS10000121'),
    (16, 1, '{"Monday": ["9:00-17:30"], "Wednesday": ["10:00-13:30"]}', 93, 'TS10000120'),
    (17, 1, '{"Monday": ["9:00-16:30"], "Wednesday": ["10:00-14:30"]}', 93, 'TS10000125'),
    (18, 1, '{"Monday": ["9:00-17:30"], "Wednesday": ["8:00-14:30"]}', 40, 'TS10000123'),
    (19, 1, '{"Monday": ["8:00-16:30"], "Wednesday": ["12:00-13:30"]}', 43, 'TS10000141'),
    (20, 1, '{"Monday": ["9:00-18:30"], "Wednesday": ["12:00-14:30"]}', 66, 'TS10000142'),
    (21, 1, '{"Monday": ["10:00-17:30"], "Wednesday": ["11:00-14:30"]}', 40, 'TS10000143'),
    (23, 1, '{"Monday": ["12:00-18:30"], "Wednesday": ["12:00-14:30"]}', 48, 'TS10000140'),
    (25, 1, '{"Monday": ["9:00-18:30"], "Wednesday": ["10:00-13:30"]}', 61, 'TS10000120'),
    (26, 1, '{"Monday": ["13:00-17:30"], "Wednesday": ["9:00-14:30"]}', 89, 'TS10000124'),
    (27, 1, '{"Monday": ["9:00-16:30"], "Wednesday": ["10:00-13:30"]}', 78, 'TS10000125'),
    (28, 1, '{"Monday": ["8:00-18:30"], "Wednesday": ["11:00-14:30"]}', 77, 'TS10000120'),
    (29, 1, '{"Monday": ["14:00-18:30"], "Wednesday": ["9:00-15:30"]}', 58, 'TS10000123'),
    (30, 1, '{"Monday": ["12:00-18:30"], "Wednesday": ["8:00-13:30"]}', 40, 'TS10000125'),
    (31, 1, '{"Monday": ["14:00-18:30"], "Wednesday": ["8:00-15:30"]}', 45, 'TS10000120'),
    (32, 1, '{"Monday": ["15:00-18:30"], "Wednesday": ["10:00-15:30"]}', 60, 'TS10000141'),
    (33, 1, '{"Monday": ["12:00-18:30"], "Wednesday": ["9:00-13:30"]}', 98, 'TS10000141'),
    (35, 1, '{"Monday": ["15:00-17:30"], "Wednesday": ["12:00-13:30"]}', 74, 'TS10000142'),
    (37, 1, '{"Monday": ["11:00-12:30"], "Wednesday": ["11:00-14:30"]}', 91, 'TS10000126'),
    (38, 1, '{"Monday": ["10:00-12:30"], "Wednesday": ["11:00-12:30"]}', 64, 'TS10000126'),
    (39, 1, '{"Monday": ["9:00-13:30"], "Wednesday": ["9:00-14:30"]}', 97, 'TS10000122'),
    (40, 1, '{"Monday": ["11:00-13:30"], "Wednesday": ["9:00-13:30"]}', 67, 'TS10000123'),
    (41, 1, '{"Monday": ["11:00-13:30"], "Wednesday": ["11:00-13:30"]}', 86, 'TS10000121'),
    (42, 1, '{"Monday": ["9:00-12:30"], "Wednesday": ["11:00-12:30"]}', 66, 'TS10000124');

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
    (10, 1, '{"Wednesday":["09:00-10:00"]}', 20, 'TS10000008'),
    (11, 101, {"Friday":["11:00-12:00"]}, 25, 'TS10000011'),
    (14, 1, '{"Friday": ["10:00-18:30"]}', 27, 'TS10000130'),
    (14, 2, '{"Friday": ["12:00-16:30"]}', 35, 'TS10000133'),
    (15, 1, '{"Friday": ["13:00-17:30"]}', 23, 'TS10000134'),
    (15, 2, '{"Friday": ["10:00-18:30"]}', 34, 'TS10000134'),
    (22, 1, '{"Friday": ["12:00-16:30"]}', 29, 'TS10000153'),
    (22, 2, '{"Friday": ["11:00-18:30"]}', 40, 'TS10000153'),
    (26, 1, '{"Friday": ["10:00-18:30"]}', 34, 'TS10000132'),
    (26, 2, '{"Friday": ["9:00-18:30"]}', 34, 'TS10000130'),
    (27, 1, '{"Friday": ["13:00-17:30"]}', 36, 'TS10000133'),
    (27, 2, '{"Friday": ["9:00-16:30"]}', 36, 'TS10000134'),
    (34, 1, '{"Friday": ["12:00-17:30"]}', 26, 'TS10000150'),
    (34, 2, '{"Friday": ["9:00-16:30"]}', 35, 'TS10000153'),
    (38, 1, '{"Friday": ["9:00-13:30"]}', 35, 'TS10000135'),
    (38, 2, '{"Friday": ["8:00-13:30"]}', 23, 'TS10000130'),
    (39, 1, '{"Friday": ["11:00-14:30"]}', 37, 'TS10000135'),
    (39, 2, '{"Friday": ["11:00-12:30"]}', 34, 'TS10000133');

INSERT INTO student(student_number,application_id,first_name,last_name,email,phone,date_of_birth,entry_year,is_domestic,is_full_time,degree_type,program_name) VALUES
    ('S20230001',1,'Liam','Wong','liam@student.uoft.ca','647-111-0001','2002-03-12',2023,1,1,'bachelor','Bachelor of Computer Science'),
    ('S20230002',3,'Noah','Singh','noah@student.uoft.ca','647-111-0003','2000-07-20',2023,1,0,'master','Master of Information'),
    ('S20230003',4,'Olivia','Nguyen','olivia@student.uoft.ca','647-111-0004','1999-05-01',2023,0,1,'phd','PhD in Education'),
    ('S20230004',6,'Sophia','Brown','sophia@student.uoft.ca','647-111-0006','1997-01-22',2023,1,1,'bachelor','Bachelor of Nursing'),
    ('S20230005',8,'Ava','Zhou','ava@student.uoft.ca','647-111-0008','2000-12-03',2023,0,1,'master','Master of Business Administration'),
    ('S20230006',9,'James','Kim','james@student.uoft.ca','647-111-0009','2002-02-25',2023,1,1,'phd','PhD in Computer Science'),
    ('S20240001',12,'William','Chen','william.chen@student.uoft.ca','647-222-1001','2004-06-18',2023,1,1,'bachelor','Bachelor of Computer Science'),
    ('S20240002',13,'Yuna','Park','yuna.park@student.uoft.ca','647-222-1002','1998-11-02',2024,0,1,'phd','PhD in Computer Science'),
    ('S20240003',14,'Ethan','Li','ethan.li@student.uoft.ca','647-222-1003','2003-09-25',2023,1,0,'bachelor','Bachelor of Kinesiology'),
    ('S20251100',11,'Alex','Morgan','alex.morgan@uoft.ca','416-555-1010','2000-08-12',2025,1,1,'master','Master of Information');

INSERT INTO enrollment(student_number,course_id,section_code,tutorial_code) VALUES
    ('S20240001',12,2,NULL),
    ('S20240001',13,3,NULL),
    ('S20240001',20,1,NULL),
    ('S20240001',21,1,NULL),
    ('S20240001',26,1,1),
    ('S20240001',27,1,2),
    ('S20240001',34,1,1),
    ('S20240001',40,1,NULL),
    ('S20240001',41,1,NULL),
    ('S20240002',42,1,NULL),
    ('S20240003',20,1,NULL),
    ('S20240003',21,1,NULL),
    ('S20240003',34,1,2);
