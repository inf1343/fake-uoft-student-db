-- todo: check ';' 

CREATE TABLE faculty(
    faculty_name VARCHAR(50) PRIMARY KEY NOT NULL,
    administrator VARCHAR(50),
    phone VARCHAR(20)
    email VARCHAR(100) UNIQUE NOT NULL,
);

CREATE TABLE program(
    program_name VARCHAR(50) PRIMARY KEY NOT NULL, -- e.g. 'bachelor of information', 'master of science'
    degree_type ENUM('bachelor','master','phd') NOT NULL, -- not in the ERD
    credits_required INT NOT NULL, -- if 0.5: CHECK (credits % 0.5 = 0)
    offered_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_name)
);

-- a list of possible options for bachelor/master/phd programs
CREATE TABLE bachelor(
    program_name VARCHAR(50),
    specialization VARCHAR(50),
    PRIMARY KEY (program_name, specialization),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);

CREATE TABLE master(
    program_name INT PRIMARY KEY,
    'type' ENUM('course-based','thesis-based','project-based','MBA') NOT NULL,
    PRIMARY KEY (program_name, 'type'),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);

CREATE TABLE phd(
    program_name INT PRIMARY KEY,
    supervisor VARCHAR(50),
    PRIMARY KEY (program_name, supervisor),
    FOREIGN KEY (program_name) REFERENCES program(program_name)
);




CREATE TABLE teaching_staff(
    staff_id INT PRIMARY KEY,
    faculty_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    employment_type ENUM('full-time','part-time') NOT NULL, -- need edit
    position ENUM('professor','lecturer','instructor','teaching_assistant') NOT NULL,
    FOREIGN KEY faculty_name REFERENCES faculty(faculty_name)
);




-- applicant, application, admission

CREATE TABLE applicant(
	applicant_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
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
CREATE TABLE admission (
    application_id INT PRIMARY KEY,
    applicant_decision_deadline DATE NOT NULL,
    accepted_by_applicant ENUM ('pending','accepted','declined') NOT NULL,
    FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);


-- not done below
CREATE TABLE supporting_document( -- weak entity
    application_id INT NOT NULL,
    document_type ENUM('transcript','resume','cover_letter','reference_letter','other') NOT NULL,
    file_path VARCHAR(500) NOT NULL, -- assume after upload, the file is stored in the school's server
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (application_id, document_type),
    FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
);




-- lets just get rid of this; not important for our database
-- CREATE TABLE academic_record( -- if a supporting document is a transcript
--     record_id INT AUTO_INCREMENT PRIMARY KEY,
--     application_id INT NOT NULL,
--     school_name VARCHAR(100),
--     degree VARCHAR(50),
--     major VARCHAR(50),
--     gpa DECIMAL(3,2),
--     start_date DATE,
--     end_date DATE,
--     FOREIGN KEY (application_id) REFERENCES application(application_id)
-- )


-- COURSE AND STUDENT

CREATE TABLE course(
    course_id INT AUTO_INCREMENT PRIMARY KEY, 
    'year' YEAR NOT NULL,
    term ENUM('fall','winter','summer','fall-winter') NOT NULL,
    course_code VARCHAR(10) NOT NULL, -- e.g. CSC2515 
    course_name VARCHAR(50) NOT NULL, -- e.g. 'Intro to ML'
    course_level ENUM('undergraduate','graduate') NOT NULL, -- where course_level = 'undergraduate'
    credits DECIMAL(4,2) NOT NULL, -- 0.25, 0.5, 1, etc.
    offered_by faculty_name INT NOT NULL,
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_name)
);

CREATE TABLE year_term_date(
    'year' YEAR NOT NULL,
    term ENUM('fall','winter','summer') NOT NULL,
    'start_date' DATE,
    end_date DATE,
    enrollment_start_date DATE,
    enrollment_end_date DATE,
    PRIMARY KEY ('year', term)
);

CREATE TABLE prerequisite( -- weak entity
    course_code VARCHAR(10) NOT NULL, -- no reference since course_code is not a primary key in course
    prerequisite_course_name VARCHAR(10) NOT NULL,
    PRIMARY KEY (course_code, prerequisite_course_name),
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
    instructor_id INT NOT NULL, -- only include one main instructor here
    PRIMARY KEY (course_id, section_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES teaching_staff(staff_id)
);

CREATE TABLE tutorial( -- weak entity 
    course_id INT NOT NULL,
    tutorial_code INT NOT NULL,
    schedule JSON NOT NULL,
    capacity INT NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (course_id, tutorial_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES teaching_staff(staff_id)
);

CREATE TABLE lab( -- weak entity
    course_id INT NOT NULL,
    lab_code INT NOT NULL,
    schedule JSON NOT NULL,
    capacity INT NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (course_id, lab_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES teaching_staff(staff_id)
);

-- simplify: don't speacify the teaching team (e.g. TAs) for each section, tutorial, lab
-- it's not that important for our database



CREATE TABLE student( 
    -- make sure applicant data can be transferred here directly 
    -- only include current students (no alumni); 
    -- if a student turns from an undergrad to a grad, 
    -- should use update instead of creating a new entry
    
    student_number CHAR(10) PRIMARY KEY,
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
    FOREIGN KEY (program_name) REFERENCES program(program_name),
);
-- CREATE TABLE alumni() -- optional; if we want to keep a copy of past students' data

CREATE TABLE bachelor_student(
    student_number INT PRIMARY KEY,
    program_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50),
    FOREIGN KEY (student_number) REFERENCES student(student_number)
    FOREIGN KEY (program_name) REFERENCES bachelor(program_name)
    FOREIGN KEY (specialization) REFERENCES bachelor(specialization)
);

CREATE TABLE master_student(
    student_number INT PRIMARY KEY,
    program_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_number) REFERENCES student(student_number)
    FOREIGN KEY (program_name) REFERENCES master(program_name)
);

CREATE TABLE phd_student(
    student_number INT PRIMARY KEY,
    program_name VARCHAR(50) NOT NULL,
    supervisor VARCHAR(50) NOT NULL,
    FOREIGN KEY (student_number) REFERENCES student(student_number)
    FOREIGN KEY (program_name) REFERENCES phd(program_name)
    FOREIGN KEY (supervisor) REFERENCES phd(supervisor)
);



-- check for constraint: student cannot take a course that they have already passed
CREATE TABLE enrollment( -- junction table
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    section_code NOT NULL,
    tutorial_code , -- nullable
    lab_code ,  -- nullable
    PRIMARY KEY (student_id, course_id, section_code),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (section_code) REFERENCES section(section_code)
)




-- academic record: keep track of all courses a student has taken
-- a student can only take a course that they have not taken before
-- or they can retake a course if they have failed (grade = 'F')
CREATE TABLE academic_record(
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    section_code INT NOT NULL,
    grade ENUM('A+','A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F') NOT NULL,
    PRIMARY KEY (student_id, course_id, section_code),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (section_code) REFERENCES section(section_code)
);