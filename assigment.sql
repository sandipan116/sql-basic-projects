CREATE DATABASE exam_mgnt;
use exam_mgnt;
drop table students;
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  roll_no VARCHAR(20) UNIQUE,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  class VARCHAR(20),
  section VARCHAR(10),
  dob DATE,
  created_at TIMESTAMP
);

drop table subjects;
CREATE TABLE subjects (
  subject_id INT PRIMARY KEY AUTO_INCREMENT,
  subject_code VARCHAR(50) UNIQUE,
  subject_name VARCHAR(100)
);
drop table exams;
CREATE TABLE exams (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_name VARCHAR(100),
  exam_date DATE,
  max_marks INT
);

DROP TABLE IF EXISTS results;
CREATE TABLE results (
  result_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  subject_id INT,
  exam_id INT,
  marks DECIMAL(6,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_results_student FOREIGN KEY (student_id) REFERENCES students(student_id),
  CONSTRAINT fk_results_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
  CONSTRAINT fk_results_exam    FOREIGN KEY (exam_id)    REFERENCES exams(exam_id)
);



drop table exam_aggregates;
CREATE TABLE exam_aggregates (
  agg_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  exam_id INT,
  total_marks DECIMAL(8,2),
  percentage DECIMAL(6,2),
  grade VARCHAR(5),
  updated_at TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);
select * from students;
select * from subjects;
select * from exams;
select * from results;
select * from exam_aggregates;

INSERT INTO students (roll_no, first_name, last_name, class, section, dob, created_at) VALUES
('RN001', 'Amit', 'Sharma', '10', 'A', '2009-05-12', CURRENT_TIMESTAMP),
('RN002', 'Priya', 'Verma', '10', 'A', '2009-07-23', CURRENT_TIMESTAMP),
('RN003', 'Rohan', 'Das', '10', 'B', '2009-09-15', CURRENT_TIMESTAMP),
('RN004', 'Sneha', 'Mukherjee', '9', 'A', '2010-01-19', CURRENT_TIMESTAMP),
('RN005', 'Arjun', 'Singh', '9', 'B', '2010-03-08', CURRENT_TIMESTAMP),
('RN006', 'Meera', 'Nair', '8', 'A', '2011-02-05', CURRENT_TIMESTAMP),
('RN007', 'Kunal', 'Patel', '8', 'B', '2011-03-22', CURRENT_TIMESTAMP),
('RN008', 'Ananya', 'Roy', '7', 'A', '2012-01-10', CURRENT_TIMESTAMP),
('RN009', 'Vikram', 'Gupta', '7', 'B', '2012-02-25', CURRENT_TIMESTAMP),
('RN010', 'Neha', 'Chatterjee', '6', 'A', '2013-01-28', CURRENT_TIMESTAMP);

INSERT INTO subjects (subject_code, subject_name) VALUES
('MATH101', 'Mathematics'),
('SCI102', 'Science'),
('ENG103', 'English'),
('HIS104', 'History'),
('GEO105', 'Geography'),
('PHY106', 'Physics'),
('CHE107', 'Chemistry'),
('BIO108', 'Biology'),
('CSC109', 'Computer Science'),
('ECO110', 'Economics');

INSERT INTO exams (exam_name, exam_date, max_marks) VALUES
('Midterm Mathematics', '2025-03-10', 100),
('Midterm Science', '2025-03-12', 100),
('Midterm English', '2025-03-14', 100),
('Midterm History', '2025-03-16', 100),
('Midterm Geography', '2025-03-18', 100),
('Final Mathematics', '2025-09-10', 100),
('Final Science', '2025-09-12', 100),
('Final English', '2025-09-14', 100),
('Final Physics', '2025-09-16', 100),
('Final Chemistry', '2025-09-18', 100);

INSERT INTO results (student_id, subject_id, exam_id, marks) VALUES
(1, 1, 1, 85.50),
(2, 2, 2, 78.00),
(3, 3, 3, 92.00),
(4, 4, 4, 66.75),
(5, 5, 5, 74.25),
(6, 6, 6, 88.00),
(7, 7, 7, 81.50),
(8, 8, 8, 90.00),
(9, 9, 9, 69.00),
(10, 10, 10, 72.50);

INSERT INTO exam_aggregates (student_id, exam_id, total_marks, percentage, grade, updated_at) VALUES
(1, 1, 85.50, 85.50, 'A', CURRENT_TIMESTAMP),
(2, 2, 78.00, 78.00, 'B', CURRENT_TIMESTAMP),
(3, 3, 92.00, 92.00, 'A', CURRENT_TIMESTAMP),
(4, 4, 66.75, 66.75, 'C', CURRENT_TIMESTAMP),
(5, 5, 74.25, 74.25, 'B', CURRENT_TIMESTAMP),
(6, 6, 88.00, 88.00, 'A', CURRENT_TIMESTAMP),
(7, 7, 81.50, 81.50, 'B', CURRENT_TIMESTAMP),
(8, 8, 90.00, 90.00, 'A', CURRENT_TIMESTAMP),
(9, 9, 69.00, 69.00, 'C', CURRENT_TIMESTAMP),
(10, 10, 72.50, 72.50, 'B', CURRENT_TIMESTAMP);
-- order by 
-- Q1 — Top 3 students by percentage
SELECT ea.student_id, s.roll_no, s.first_name, s.last_name, ea.percentage
FROM exam_aggregates ea
JOIN students s ON ea.student_id = s.student_id
ORDER BY ea.percentage DESC
LIMIT 3;

-- Q2 — Average marks for each exam
SELECT e.exam_id, e.exam_name, ROUND(AVG(r.marks),2) AS avg_marks
FROM exams e
LEFT JOIN results r ON e.exam_id = r.exam_id
GROUP BY e.exam_id, e.exam_name
ORDER BY e.exam_id;

-- Q3 — Grade distribution for all exams
SELECT grade, COUNT(*) AS count_students
FROM exam_aggregates
GROUP BY grade
ORDER BY grade;

-- Q4 — Subject toppers
SELECT sub.subject_id, sub.subject_name,
       r.student_id, s.first_name, s.last_name, r.marks
FROM subjects sub
JOIN results r ON sub.subject_id = r.subject_id
JOIN students s ON r.student_id = s.student_id
WHERE r.marks = (
  SELECT MAX(r2.marks)
  FROM results r2
  WHERE r2.subject_id = sub.subject_id
)
ORDER BY sub.subject_id;
-- Q5 — Students who scored more than 80 marks
SELECT r.student_id, s.roll_no, s.first_name, s.last_name, r.marks
FROM results r
JOIN students s ON r.student_id = s.student_id
WHERE r.marks > 80
ORDER BY r.marks DESC;
-- Q6- List all students sorted by their roll number in descending order
SELECT student_id, roll_no, first_name, last_name
FROM students
ORDER BY roll_no DESC;
-- Q7- Show all results sorted from lowest marks to highest marks.
SELECT result_id, student_id, marks
FROM results
ORDER BY marks ASC;
-- Q8- Show exams sorted by exam date (newest to oldest)

SELECT exam_id, exam_name, exam_date
FROM exams
ORDER BY exam_date DESC;


-- group by

-- Q1 — Grade-wise count of students
SELECT grade, COUNT(*) AS students_count
FROM exam_aggregates
GROUP BY grade
ORDER BY grade;

-- Q2 — Subject-wise highest and lowest marks
SELECT s.subject_name,
       MAX(r.marks) AS highest_mark,
       MIN(r.marks) AS lowest_mark
FROM results r
JOIN subjects s ON r.subject_id = s.subject_id
GROUP BY s.subject_name;
-- Q3 — Average percentage per grade
SELECT grade,
       ROUND(AVG(percentage),2) AS avg_percentage
FROM exam_aggregates
GROUP BY grade;
-- Q4 — Number of students in each section
SELECT section,
       COUNT(*) AS total_students
FROM students
GROUP BY section;

-- Q5-SELECT section, COUNT(*) AS total_students
SELECT section, COUNT(*) AS total_students
FROM students
GROUP BY section;

-- Q6- Find average marks for each subject.
SELECT s.subject_name,
       ROUND(AVG(r.marks),2) AS avg_marks
FROM results r
JOIN subjects s ON r.subject_id = s.subject_id
GROUP BY s.subject_name;

-- Q7-Count how many exams each student has given.
SELECT s.student_id, s.first_name, COUNT(r.exam_id) AS exams_given
FROM students s
LEFT JOIN results r ON s.student_id = r.student_id
GROUP BY s.student_id, s.first_name;





