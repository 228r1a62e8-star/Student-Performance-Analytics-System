-- 03_views_ctes_procs.sql
USE student_analytics;

-- View: Student total and percentage across all courses (per exam row aggregated by student)
CREATE OR REPLACE VIEW vw_student_aggregate AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    COUNT(m.mark_id) AS exams_count,
    SUM(m.marks_obtained) AS total_marks_obtained,
    SUM(m.max_marks) AS total_max_marks,
    ROUND( SUM(m.marks_obtained) / NULLIF(SUM(m.max_marks),0) * 100, 2) AS percentage
FROM Students s
LEFT JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.student_id;

-- View: Course wise average marks
CREATE OR REPLACE VIEW vw_course_avg AS
SELECT
    c.course_id,
    c.name AS course_name,
    COUNT(m.mark_id) AS num_records,
    ROUND(AVG(m.marks_obtained),2) AS avg_marks,
    ROUND(AVG(marks_obtained)/NULLIF(AVG(m.max_marks),0)*100,2) AS avg_percentage
FROM Courses c
LEFT JOIN Marks m ON c.course_id = m.course_id
GROUP BY c.course_id;

-- Procedure: Generate report card for a student (detailed marks & aggregates)
DROP PROCEDURE IF EXISTS sp_generate_report_card;
DELIMITER //
CREATE PROCEDURE sp_generate_report_card(IN p_student_id INT)
BEGIN
    SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, s.roll_no, s.class
    FROM Students s WHERE s.student_id = p_student_id;

    SELECT c.name AS course, m.marks_obtained, m.max_marks,
           ROUND(m.marks_obtained / NULLIF(m.max_marks,0) * 100,2) AS percentage
    FROM Marks m
    JOIN Courses c ON m.course_id = c.course_id
    WHERE m.student_id = p_student_id;

    SELECT
        SUM(m.marks_obtained) AS total_marks_obtained,
        SUM(m.max_marks) AS total_max_marks,
        ROUND(SUM(m.marks_obtained)/NULLIF(SUM(m.max_marks),0)*100,2) AS overall_percentage
    FROM Marks m
    WHERE m.student_id = p_student_id;
END //
DELIMITER ;

-- Procedure: Calculate rank for a class (rank by percentage)
DROP PROCEDURE IF EXISTS sp_class_rank;
DELIMITER //
CREATE PROCEDURE sp_class_rank(IN p_class VARCHAR(50))
BEGIN
    -- Aggregate per student in class
    WITH agg AS (
        SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name,
               ROUND(SUM(m.marks_obtained)/NULLIF(SUM(m.max_marks),0)*100,2) AS percentage
        FROM Students s
        LEFT JOIN Marks m ON s.student_id = m.student_id
        WHERE s.class = p_class
        GROUP BY s.student_id
    )
    SELECT student_id, student_name, percentage,
           RANK() OVER (ORDER BY percentage DESC) AS class_rank
    FROM agg
    ORDER BY class_rank;
END //
DELIMITER ;

-- Procedure: Attendance percentage per student (across all courses or per course)
DROP PROCEDURE IF EXISTS sp_attendance_percentage;
DELIMITER //
CREATE PROCEDURE sp_attendance_percentage(IN p_student_id INT, IN p_course_id INT)
BEGIN
    IF p_course_id IS NULL THEN
        SELECT a.student_id,
               SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count,
               COUNT(*) AS total_sessions,
               ROUND(SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)*100,2) AS attendance_percent
        FROM Attendance a
        WHERE a.student_id = p_student_id
        GROUP BY a.student_id;
    ELSE
        SELECT a.student_id, a.course_id,
               SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count,
               COUNT(*) AS total_sessions,
               ROUND(SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0)*100,2) AS attendance_percent
        FROM Attendance a
        WHERE a.student_id = p_student_id AND a.course_id = p_course_id
        GROUP BY a.student_id, a.course_id;
    END IF;
END //
DELIMITER ;

-- View: Top performers (top N by percentage) - we'll create a parameterized query in backend; this view helps
CREATE OR REPLACE VIEW vw_student_percentage AS
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name,
       ROUND(SUM(m.marks_obtained)/NULLIF(SUM(m.max_marks),0)*100,2) AS percentage
FROM Students s
LEFT JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.student_id;
