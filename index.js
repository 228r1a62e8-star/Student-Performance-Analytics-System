// index.js
const express = require('express');
const app = express();
const pool = require('./db');

app.use(express.json());

// simple health check
app.get('/ping', (req, res) => res.json({ok: true}));

// Get all students with percentage (from view)
app.get('/students', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT s.student_id, s.first_name, s.last_name, s.roll_no, v.percentage FROM Students s LEFT JOIN vw_student_percentage v ON s.student_id = v.student_id');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({error: 'db error'});
  }
});

// Generate report card via stored procedure: /report-card/:studentId
app.get('/report-card/:studentId', async (req, res) => {
  const sid = parseInt(req.params.studentId, 10);
  if (!sid) return res.status(400).json({error:'invalid student id'});
  try {
    const conn = await pool.getConnection();
    // call stored procedure sp_generate_report_card; it returns multiple result sets
    const [rows] = await conn.query('CALL sp_generate_report_card(?)', [sid]);
    conn.release();
    // mysql2 returns an array of resultsets; we will present them as arrays
    res.json(rows); // rows is array of result set arrays or object; quick and simple
  } catch (err) {
    console.error(err);
    res.status(500).json({error:'db error'});
  }
});

// Class rank: /class-rank?class=10-A
app.get('/class-rank', async (req, res) => {
  const cls = req.query.class;
  if (!cls) return res.status(400).json({error:'class needed'});
  try {
    const conn = await pool.getConnection();
    const [rows] = await conn.query('CALL sp_class_rank(?)', [cls]);
    conn.release();
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({error:'db error'});
  }
});

// Top performers endpoint
app.get('/top-performers', async (req, res) => {
  const topN = parseInt(req.query.n || '5', 10);
  try {
    const [rows] = await pool.query('SELECT * FROM vw_student_percentage ORDER BY percentage DESC LIMIT ?', [topN]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({error:'db error'});
  }
});

// Attendance percentage: /attendance/:studentId?courseId=1
app.get('/attendance/:studentId', async (req, res) => {
  const studentId = parseInt(req.params.studentId,10);
  const courseId = req.query.courseId ? parseInt(req.query.courseId,10) : null;
  try {
    if (courseId) {
      const [rows] = await pool.query('CALL sp_attendance_percentage(?,?)', [studentId, courseId]);
      return res.json(rows);
    } else {
      const [rows] = await pool.query('CALL sp_attendance_percentage(?,NULL)', [studentId]);
      return res.json(rows);
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({error:'db error'});
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=> console.log(`Server listening on ${PORT}`));
