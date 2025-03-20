-- todo: check ';' 

CREATE TABLE faculty(
    faculty_name VARCHAR(50) PRIMARY KEY NOT NULL,
    administrator VARCHAR(50),
    phone VARCHAR(20)
    email VARCHAR(100) UNIQUE NOT NULL,
)

CREATE TABLE program(
    program_name VARCHAR(50) PRIMARY KEY NOT NULL, -- e.g. 'bachelor of information', 'master of science'
    degree_type ENUM('bachelor','master','phd') NOT NULL, -- not in the ERD
    credits_required DECIMAL(3,1) NOT NULL, -- if 0.5: CHECK (credits % 0.5 = 0)
    offered_by faculty_id INT NOT NULL,
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_id)
)

CREATE TABLE bachelor(
    program_id INT PRIMARY KEY,
    ...--tbd

    FOREIGN KEY (program_id) REFERENCES program(program_id)
)

CREATE TABLE master(
    program_id INT PRIMARY KEY,
    ...--tbd

    FOREIGN KEY (program_id) REFERENCES program(program_id)
)

CREATE TABLE phd(
    program_id INT PRIMARY KEY,
    supervisor VARCHAR(50),
    ...--tbd

    FOREIGN KEY (program_id) REFERENCES program(program_id)
)




CREATE TABLE teaching_staff(
    staff_id INT PRIMARY KEY,
    faculty_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    contract_type ENUM('full-time','part-time') NOT NULL, -- need edit
    employment_type ENUM('full-time','part-time') NOT NULL, -- need edit
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
)

-- consider move these two into teaching_staff as attributes: position ENUM('professor','lecturer','instructor','teaching_assistant') NOT NULL,
CREATE TABLE professor(
    staff_id INT PRIMARY KEY,
    FOREIGN KEY (staff_id) REFERENCES teaching_staff(staff_id)
)
CREATE TABLE teaching_assistant(
    staff_id INT PRIMARY KEY,
    FOREIGN KEY (staff_id) REFERENCES teaching_staff(staff_id)
)




-- applicant, application, admission

CREATE TABLE applicant(
	applicant_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
);

CREATE TABLE application( -- an applicant can have multiple applications, but only one can be accepted
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id),
    applied_program FOREIGN KEY (applied_program) REFERENCES program(program_name),
    application_status ENUM('not-submitted','submitted-pending','admitted','rejected') NOT NULL, -- issued by the school 
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    decision_date TIMESTAMP, -- when the program makes the decision
);

-- admission: program sends out all admissions to qualified applicants
-- whenever an application has application_status = 'accepted', an admission is created here 
-- an applicant can have multiple admissions, but only one is accepted.
-- it should be a subtype of application, so it inherit the attribures of application 
CREATE TABLE admission (
    application_id INT PRIMARY KEY,
    FOREIGN KEY (application_id) REFERENCES application(application_id) ON DELETE CASCADE
    applicant_decision_deadline DATE NOT NULL,
    accepted_by_applicant ENUM ('pending','accepted','declined') NOT NULL,


);

    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    admission_status VARCHAR(50),
    admission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES application(application_id)
);





-- not done below
CREATE TABLE supporting_document( -- weak entity
    application_id INT NOT NULL,
    document_type ENUM('transcript','resume','cover_letter','reference_letter','other') NOT NULL,
    file ...,
    updload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES application(application_id)
);

CREATE TABLE academic_record( 
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    school_name VARCHAR(100),
    degree VARCHAR(50),
    major VARCHAR(50),
    gpa DECIMAL(3,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (application_id) REFERENCES application(application_id)
)

-- not done above


















CREATE TABLE course(
    course_id INT AUTO_INCREMENT PRIMARY KEY, 
    'year' INT NOT NULL,
    term ENUM('fall','winter','summer','fall-winter') NOT NULL,
    course_code VARCHAR(10) NOT NULL, -- e.g. CSC2515 
    course_name VARCHAR(50) NOT NULL, -- e.g. 'Intro to ML'
    course_level ENUM('undergraduate','graduate') NOT NULL, -- where course_level = 'undergraduate'
    credits DECIMAL(4,2) NOT NULL, -- 0.25, 0.5, 1, etc.
    offered_by faculty_name INT NOT NULL,
    FOREIGN KEY (prerequisite_course_id) REFERENCES course(course_id),
    FOREIGN KEY (offered_by) REFERENCES faculty(faculty_name)
)

CREATE TABLE year_term_date(
    'year' INT NOT NULL,
    term ENUM('fall','winter','summer') NOT NULL,
    'start_date' DATE,
    end_date DATE,
    enrollment_start_date DATE,
    enrollment_end_date DATE,
    PRIMARY KEY ('year', term)
)

CREATE TABLE prerequisite( -- weak entity with composite key
    course_id INT NOT NULL,
    prerequisite_course_id INT NOT NULL,
    PRIMARY KEY (course_id, prerequisite_course_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (prerequisite_course_id) REFERENCES course(course_id)
)

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
    instructor faculty_id INT NOT NULL, -- assume only one instructor per section
    PRIMARY KEY (course_id, section_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor) REFERENCES faculty(faculty_id)
)

CREATE TABLE tutorial( -- weak entity with composite key
    course_id INT NOT NULL,
    tutorial_code INT NOT NULL,
    schedule JSON NOT NULL,
    capacity INT NOT NULL,
    instructor faculty_id INT NOT NULL,
    PRIMARY KEY (course_id, tutorial_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor) REFERENCES faculty(faculty_id)
)

CREATE TABLE lab( -- weak entity with composite key
    course_id INT NOT NULL,
    lab_code INT NOT NULL,
    schedule JSON NOT NULL,
    capacity INT NOT NULL,
    instructor faculty_id INT NOT NULL,
    PRIMARY KEY (course_id, lab_code),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (instructor) REFERENCES faculty(faculty_id)
)


-- should create a new table that map section/tutorial/lab to 





CREATE TABLE student( -- let admission refer to student id; dont add admission id here 
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
    entry_year YEAR NOT NULL, --  CHECK (entry_year >= 1900 AND entry_year <= YEAR(CURDATE()))
    degree_type ENUM('bachelor','master','phd') NOT NULL,
    is_domestic BOOLEAN NOT NULL,
    is_full_time BOOLEAN NOT NULL,
    program_name FOREIGN KEY (program_name) REFERENCES program(program_name),
)
-- don't add study mode, it doesn't make sense for a registration system to have it 

-- CREATE TABLE alumni() -- optional; if we want to keep a copy of past students' data


-- check for constraint: student cannot take a course that they have already passed
CREATE TABLE enrollment( -- junction table
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    section_code ... NOT NULL,
    tutorial_code , -- nullable
    lab_code ,  -- nullable
    PRIMARY KEY (student_id, course_id, section_code),
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (section_code) REFERENCES section(section_code)
)