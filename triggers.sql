-- 04_triggers.sql
USE student_analytics;

-- Example trigger: if student's percentage falls below 50 after insert/update marks, create an alert
DROP TRIGGER IF EXISTS trg_check_student_percentage_after_mark_update;
DELIMITER //
CREATE TRIGGER trg_check_student_percentage_after_mark_update
AFTER INSERT ON Marks
FOR EACH ROW
BEGIN
    DECLARE perc DECIMAL(6,2);
    SELECT ROUND(SUM(m.marks_obtained)/NULLIF(SUM(m.max_marks),0)*100,2) INTO perc
    FROM Marks m
    WHERE m.student_id = NEW.student_id;

    IF perc IS NOT NULL AND perc < 50 THEN
        INSERT INTO Alerts(message) VALUES (CONCAT('Warning: Student ID ', NEW.student_id, ' has low percentage: ', perc, '%'));
    END IF;
END //
DELIMITER ;

-- Trigger on update too (covers updates to marks)
DROP TRIGGER IF EXISTS trg_check_student_percentage_after_mark_update2;
DELIMITER //
CREATE TRIGGER trg_check_student_percentage_after_mark_update2
AFTER UPDATE ON Marks
FOR EACH ROW
BEGIN
    DECLARE perc DECIMAL(6,2);
    SELECT ROUND(SUM(m.marks_obtained)/NULLIF(SUM(m.max_marks),0)*100,2) INTO perc
    FROM Marks m
    WHERE m.student_id = NEW.student_id;

    IF perc IS NOT NULL AND perc < 50 THEN
        INSERT INTO Alerts(message) VALUES (CONCAT('Warning: Student ID ', NEW.student_id, ' has low percentage: ', perc, '% (after update)'));
    END IF;
END //
DELIMITER ;
