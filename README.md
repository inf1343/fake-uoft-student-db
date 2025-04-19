# University Student Information System - Database Simulation

**Author**: Hon Wa Ng, Steven Tsai, Diana Malynovska, Kyle Thomas 
**Date**: April 2025

## Overview

This project simulates a comprehensive University Student Information System (SIS), developed to manage key academic operations such as student admissions, course enrollments, teaching staff assignments, and academic record management.

The system is designed using MySQL and supports core business processes while ensuring data integrity, normalization (up to 3NF), and scalability.  
This project was developed as part of coursework for INF1343: Data Modeling and Database Design at the University of Toronto.

The finalized database schema, test case validations, and reporting queries are included under the `/scripts` directory.

---

## Objectives

- Design and implement a normalized relational database schema based on an Enhanced ER model.
- Populate the database with realistic data representing students, applicants, courses, and teaching assignments.
- Test schema constraints and business logic through structured SQL test cases.
- Develop SQL queries to generate operational reports supporting admissions, enrollment, and staffing decisions.

---

## Repository Structure
```bash
university-student-information-system-database-simulation/
│── scripts/                         # Final deliverables
│   ├── Script1.sql                  # Create database schema and populate sample data
│   ├── Script2.sql                  # Test cases to validate constraints and data quality
│   ├── Script3.sql                  # SQL queries to generate business reports
│
│── for-assignment-turnins/          # Submission documents and artifacts
│
│── LICENSE                          # License information
│── README.md                        # Project overview and usage guide

```
---

## Installation & Usage

### 1. Clone the Repository
```
git clone https://github.com/yourusername/university-student-information-system-database-simulation.git
cd university-student-information-system-database-simulation

```

### 2. Install Dependencies
Ensure you have MySQL (version 8.0 or higher) installed. Then:

#### Create the database and populate sample data:
```
Run scripts/Script1.sql

```

#### Validate database constraints and business logic:
```
Run scripts/Script2.sql

```

#### Generate analytical reports:
```
Run scripts/Script3.sql

```


---
## How to Run the Project
- Execute Script1.sql to create all tables and populate them with valid, realistic data.
- Execute Script2.sql to run test cases checking primary keys, foreign keys, NOT NULL, UNIQUE, ENUM validations, and complex logical constraints.
- Execute Script3.sql to retrieve operational business reports covering:
  - Admissions trends and yield rates
  - Teaching staff workload distribution
  - Enrollment trends and credit accumulation
Reports can be further visualized using Excel PivotTables and charts if desired.

---
## Methods Used

1. Database Design
- Enhanced ER modeling translated into a relational schema (normalized to 3NF).
- Use of subtypes for program degrees (bachelor, master, PhD) via vertical partitioning.

2. Data Population & Testing
- Bulk INSERT statements for realistic records.
- Structured SQL test cases for constraint validation.

3. Reporting & Insights
- SQL aggregation, grouping, and Common Table Expressions (CTEs) to support trend analysis.
- Exported data visualizations to external tools for operational insights.

---

## Results & Analysis

- A scalable, normalized database schema capturing key university academic processes.
- Comprehensive test coverage ensuring data quality and schema integrity.
- Actionable operational reports supporting admissions, enrollment, and faculty management decisions.
  
Refer to the project_report.pdf for detailed results.
---
## License
This project is licensed under the MIT License.



