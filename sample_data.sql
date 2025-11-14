-- 02_sample_data.sql
USE student_analytics;

-- Teachers
INSERT INTO Teachers (first_name, last_name, email) VALUES
('Rama','Kumar','rama.kumar@example.com'),
('Anita','Patel','anita.patel@example.com');

-- Courses
INSERT INTO Courses (name, code, credit_hours, teacher_id) VALUES
('Mathematics','MATH101',4,1),
('Physics','PHY101',4,1),
('Chemistry','CHEM101',4,2),
('English','ENG101',2,2);

-- Students
INSERT INTO Students (first_name, last_name, roll_no, class, admission_date) VALUES
('Arjun','Reddy','R001','10-A','2023-06-01'),
('Nikhil','Sharma','R002','10-A','2023-06-01'),
('Priya','Iyer','R003','10-A','2023-06-01'),
('Sneha','K','R004','10-A','2023-06-01'),
('Rahul','Verma','R005','10-A','2023-06-01');

-- Marks (some sample exam scores)
INSERT INTO Marks (student_id, course_id, exam_date, max_marks, marks_obtained) VALUES
(1,1,'2024-03-15',100,85),
(1,2,'2024-03-16',100,78),
(1,3,'2024-03-17',100,91),
(1,4,'2024-03-18',100,88),

(2,1,'2024-03-15',100,92),
(2,2,'2024-03-16',100,89),
(2,3,'2024-03-17',100,76),
(2,4,'2024-03-18',100,84),

(3,1,'2024-03-15',100,70),
(3,2,'2024-03-16',100,66),
(3,3,'2024-03-17',100,72),
(3,4,'2024-03-18',100,75),

(4,1,'2024-03-15',100,58),
(4,2,'2024-03-16',100,62),
(4,3,'2024-03-17',100,55),
(4,4,'2024-03-18',100,60),

(5,1,'2024-03-15',100,95),
(5,2,'2024-03-16',100,94),
(5,3,'2024-03-17',100,98),
(5,4,'2024-03-18',100,96);

-- Attendance: last 10 days for course 1 (Mathematics) as example
INSERT INTO Attendance (student_id, course_id, date, status) VALUES
(1,1,'2024-03-10','Present'),
(1,1,'2024-03-11','Present'),
(1,1,'2024-03-12','Absent'),
(1,1,'2024-03-13','Present'),
(1,1,'2024-03-14','Present'),

(2,1,'2024-03-10','Present'),
(2,1,'2024-03-11','Present'),
(2,1,'2024-03-12','Present'),
(2,1,'2024-03-13','Present'),
(2,1,'2024-03-14','Present'),

(3,1,'2024-03-10','Absent'),
(3,1,'2024-03-11','Present'),
(3,1,'2024-03-12','Present'),
(3,1,'2024-03-13','Absent'),
(3,1,'2024-03-14','Present'),

(4,1,'2024-03-10','Present'),
(4,1,'2024-03-11','Absent'),
(4,1,'2024-03-12','Absent'),
(4,1,'2024-03-13','Present'),
(4,1,'2024-03-14','Absent'),

(5,1,'2024-03-10','Present'),
(5,1,'2024-03-11','Present'),
(5,1,'2024-03-12','Present'),
(5,1,'2024-03-13','Present'),
(5,1,'2024-03-14','Present');
