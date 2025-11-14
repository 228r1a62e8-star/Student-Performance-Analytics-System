-- 01_create_schema.sql
-- MySQL 8+ recommended (for window functions)

CREATE DATABASE IF NOT EXISTS student_analytics;
USE student_analytics;

-- Students table
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    roll_no VARCHAR(50) UNIQUE,
    class VARCHAR(50),
    admission_date DATE
);

-- Teachers table
CREATE TABLE IF NOT EXISTS Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150)
);

-- Courses table
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    code VARCHAR(50) UNIQUE,
    credit_hours INT DEFAULT 3,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

-- Marks table: each row = student score in a course exam
CREATE TABLE IF NOT EXISTS Marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    exam_date DATE,
    max_marks INT DEFAULT 100,
    marks_obtained DECIMAL(6,2) DEFAULT 0,
    CONSTRAINT fk_marks_student FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_marks_course FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Attendance: record per student per course per date (present/absent)
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present','Absent') DEFAULT 'Present',
    CONSTRAINT fk_att_student FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_att_course FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Optional: Alerts table used by triggers
CREATE TABLE IF NOT EXISTS Alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    message VARCHAR(500)
);
