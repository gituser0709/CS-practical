/* =========================================
   DBMS PRACTICALS: STUDENT-SOCIETY SCHEMA
   ========================================= */

-- ==========================================
-- 0. DATABASE SETUP (Run this first)
-- ==========================================
CREATE DATABASE CollegeSociety;
USE CollegeSociety;

CREATE TABLE STUDENT (
    RollNo CHAR(6) PRIMARY KEY,
    StudentName VARCHAR(20),
    Course VARCHAR(10),
    DOB DATE
);

CREATE TABLE SOCIETY (
    SocID CHAR(6) PRIMARY KEY,
    SocName VARCHAR(20),
    MentorName VARCHAR(15),
    TotalSeats INT
);

CREATE TABLE ENROLLMENT (
    RollNo CHAR(6),
    SID CHAR(6),
    DateOfEnrollment DATE,
    PRIMARY KEY (RollNo, SID),
    FOREIGN KEY (RollNo) REFERENCES STUDENT(RollNo),
    FOREIGN KEY (SID) REFERENCES SOCIETY(SocID)
);

INSERT INTO STUDENT VALUES 
('A1', 'Amit', 'CS', '2001-05-15'),
('A2', 'Priya', 'Chem', '2002-08-20'),
('B1', 'Zara', 'CS', '2001-12-01'),
('C1', 'Rahul', 'Phy', '2000-03-10'),
('D1', 'Sneha', 'CS', '2001-01-10'); 

INSERT INTO SOCIETY VALUES 
('S1', 'Debating', 'Dr. Gupta', 10),
('S2', 'Dancing', 'Prof. Sharma', 20),
('S3', 'NSS', 'Dr. Verma', 50),
('S4', 'Sashakt', 'Prof. Gupta', 15);

INSERT INTO ENROLLMENT VALUES 
('A1', 'S1', '2024-07-01'),
('A1', 'S2', '2024-07-02'),
('A1', 'S3', '2024-07-03'),
('A2', 'S1', '2024-07-01'),
('A2', 'S3', '2024-07-03'),
('B1', 'S2', '2024-07-04'),
('C1', 'S4', '2024-07-05');


-- ==========================================
-- QUERIES (Copy and paste one by one)
-- ==========================================

-- Q1: Retrieve names of students enrolled in any society.
SELECT DISTINCT s.StudentName 
FROM STUDENT s JOIN ENROLLMENT e ON s.RollNo = e.RollNo;

-- Q2: Retrieve all society names.
SELECT SocName FROM SOCIETY;

-- Q3: Retrieve students' names starting with the letter 'A'.
SELECT StudentName FROM STUDENT WHERE StudentName LIKE 'A%';

-- Q4: Retrieve students' details studying in courses 'CS' or 'Chem'.
SELECT * FROM STUDENT WHERE Course IN ('CS', 'Chem');

-- Q5: Retrieve students' names whose roll no either starts with 'X' or 'Z' and ends with '9'.
SELECT StudentName FROM STUDENT WHERE RollNo LIKE 'X%9' OR RollNo LIKE 'Z%9';

-- Q6: Find society details with more than N TotalSeats.
SET @N = 15;
SELECT * FROM SOCIETY WHERE TotalSeats > @N;

-- Q7: Update society table for the mentor name of a specific society.
UPDATE SOCIETY SET MentorName = 'Dr. Raj' WHERE SocID = 'S1';

-- Q8: Find society names in which more than five students have enrolled.
SELECT SocName FROM SOCIETY s JOIN ENROLLMENT e ON s.SocID = e.SID 
GROUP BY s.SocID, s.SocName HAVING COUNT(e.RollNo) > 5;

-- Q9: Find the name of the youngest student enrolled in society 'NSS'.
SELECT s.StudentName, s.DOB FROM STUDENT s 
JOIN ENROLLMENT e ON s.RollNo = e.RollNo 
JOIN SOCIETY soc ON e.SID = soc.SocID 
WHERE soc.SocName = 'NSS' ORDER BY s.DOB DESC LIMIT 1;

-- Q10: Find the name of the most popular society (on the basis of enrolled students).
SELECT soc.SocName, COUNT(e.RollNo) AS Total FROM SOCIETY soc 
JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName ORDER BY Total DESC LIMIT 1;

-- Q11: Find the name of two least popular societies (on the basis of enrolled students).
SELECT soc.SocName, COUNT(e.RollNo) AS Total FROM SOCIETY soc 
JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName ORDER BY Total ASC LIMIT 2;

-- Q12: Find the students names who are not enrolled in any society.
SELECT StudentName FROM STUDENT WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);

-- Q13: Find the students names enrolled in at least two societies.
SELECT s.StudentName FROM STUDENT s JOIN ENROLLMENT e ON s.RollNo = e.RollNo 
GROUP BY s.RollNo, s.StudentName HAVING COUNT(e.SID) >= 2;

-- Q14: Find society names in which maximum students are enrolled.
SELECT soc.SocName FROM SOCIETY soc JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName 
HAVING COUNT(e.RollNo) = (SELECT MAX(cnt) FROM (SELECT COUNT(*) as cnt FROM ENROLLMENT GROUP BY SID) as temp);

-- Q15: Find names of all students who have enrolled in any society and society names in which at least one student has enrolled.
SELECT StudentName AS Names FROM STUDENT WHERE RollNo IN (SELECT RollNo FROM ENROLLMENT)
UNION
SELECT SocName AS Names FROM SOCIETY WHERE SocID IN (SELECT SID FROM ENROLLMENT);

-- Q16: Find names of students who are enrolled in any of the three societies 'Debating', 'Dancing' and 'Sashakt'.
SELECT DISTINCT s.StudentName FROM STUDENT s JOIN ENROLLMENT e ON s.RollNo = e.RollNo 
JOIN SOCIETY soc ON e.SID = soc.SocID 
WHERE soc.SocName IN ('Debating', 'Dancing', 'Sashakt');

-- Q17: Find society names such that its mentor has a name with 'Gupta' in it.
SELECT SocName FROM SOCIETY WHERE MentorName LIKE '%Gupta%';

-- Q18: Find the society names in which the number of enrolled students is only 10% of its capacity.
SELECT soc.SocName, soc.TotalSeats, COUNT(e.RollNo) FROM SOCIETY soc 
JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName, soc.TotalSeats 
HAVING COUNT(e.RollNo) = (soc.TotalSeats * 0.10);

-- Q19: Display the vacant seats for each society.
SELECT soc.SocName, soc.TotalSeats, COUNT(e.RollNo) AS Enrolled, 
(soc.TotalSeats - COUNT(e.RollNo)) AS Vacant 
FROM SOCIETY soc LEFT JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName, soc.TotalSeats;

-- Q20: Increment Total Seats of each society by 10%.
UPDATE SOCIETY SET TotalSeats = TotalSeats * 1.10;

-- Q21: Add the enrollment fees paid ('yes'/'No') field in the enrollment table.
ALTER TABLE ENROLLMENT ADD COLUMN FeesPaid ENUM('Yes', 'No') DEFAULT 'No';

-- Q22: Update date of enrollment of society id 's1' to '2018-01-15', 's2' to the current date and 's3' to '2018-01-02'.
UPDATE ENROLLMENT SET DateOfEnrollment = '2018-01-15' WHERE SID = 'S1';
UPDATE ENROLLMENT SET DateOfEnrollment = CURDATE() WHERE SID = 'S2';
UPDATE ENROLLMENT SET DateOfEnrollment = '2018-01-02' WHERE SID = 'S3';

-- Q23: Create a view to keep track of society names with the total number of students enrolled in it.
CREATE VIEW SocietyEnrollmentView AS
SELECT soc.SocName, COUNT(e.RollNo) AS TotalEnrolled 
FROM SOCIETY soc LEFT JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName;

-- Q24: Find student names enrolled in all the societies.
SELECT s.StudentName FROM STUDENT s JOIN ENROLLMENT e ON s.RollNo = e.RollNo 
GROUP BY s.RollNo, s.StudentName 
HAVING COUNT(DISTINCT e.SID) = (SELECT COUNT(*) FROM SOCIETY);

-- Q25: Count the number of societies with more than 5 students enrolled in it.
SELECT COUNT(*) AS PopularSocieties FROM (
    SELECT SID FROM ENROLLMENT GROUP BY SID HAVING COUNT(RollNo) > 5
) AS temp;

-- Q26: Add column Mobile number in student table with default value '9999999999'.
ALTER TABLE STUDENT ADD COLUMN MobileNumber VARCHAR(15) DEFAULT '9999999999';

-- Q27: Find the total number of students whose age is > 20 years.
SELECT COUNT(*) FROM STUDENT WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 20;

-- Q28: Find names of students who were born in 2001 and are enrolled in at least one society.
SELECT DISTINCT s.StudentName FROM STUDENT s JOIN ENROLLMENT e ON s.RollNo = e.RollNo 
WHERE YEAR(s.DOB) = 2001;

-- Q29: Count all societies whose name starts with 'S' and ends with 't' and at least 5 students are enrolled.
SELECT COUNT(*) FROM SOCIETY soc JOIN ENROLLMENT e ON soc.SocID = e.SID 
WHERE soc.SocName LIKE 'S%t' 
GROUP BY soc.SocID HAVING COUNT(e.RollNo) >= 5;

-- Q30: Display the following information: Society name, Mentor name, Total Capacity, Total Enrolled, Unfilled Seats.
SELECT soc.SocName, soc.MentorName, soc.TotalSeats AS TotalCapacity, 
COUNT(e.RollNo) AS TotalEnrolled, 
(soc.TotalSeats - COUNT(e.RollNo)) AS UnfilledSeats 
FROM SOCIETY soc LEFT JOIN ENROLLMENT e ON soc.SocID = e.SID 
GROUP BY soc.SocID, soc.SocName, soc.MentorName, soc.TotalSeats;
