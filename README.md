# Fake UofT Student Database

This project is a simulation of a student database for the University of Toronto. It includes various tables to manage students, courses, programs, and enrollments.

## Database Schema

The database schema includes the following tables:
- `faculty`
- `program`
- `teaching_staff`
- `bachelor`
- `master`
- `phd`
- `applicant`
- `application`
- `admission_offer`
- `supporting_document`
- `course`
- `section`
- `tutorial`
- `student`
- `enrollment`

## Key Reports and Potential Questions

### 1. Do we limit students from enrolling in conflicting courses?
- **Description**: This report can reveal if students are enrolled in courses that have conflicting schedules.
- **Potential Question**: Should we implement constraints to prevent students from enrolling in courses with overlapping schedules?

### 2. Do we enforce pairing of sections and tutorials?
- **Description**: This report can check if students are enrolled in tutorials without being enrolled in the corresponding section.
- **Potential Question**: Should we enforce a rule that students must be enrolled in a section before they can enroll in a tutorial for that section?

## Future Updates

The following features and constraints may be added in future updates:
- Implementing constraints to prevent students from enrolling in conflicting courses.
- Enforcing rules to ensure students are enrolled in sections before enrolling in corresponding tutorials.

## Getting Started

To set up the database, run the `db-creation.sql` script in your SQL environment.

```sh
mysql -u your_username -p < db-creation.sql
```

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License.