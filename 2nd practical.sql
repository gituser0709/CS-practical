/* =========================================
   PRACTICAL II: DATABASE ADMINISTRATION COMMANDS
   ========================================= */

-- 1. Create a new user
CREATE USER 'student_admin'@'localhost' IDENTIFIED BY 'password123';

-- 2. Create a role
CREATE ROLE 'society_manager';

-- 3. Grant privileges to a role
GRANT SELECT, INSERT ON CollegeSociety.* TO 'society_manager';

-- 4. Assign the role to the user
GRANT 'society_manager' TO 'student_admin'@'localhost';

-- 5. Revoke a privilege from a role
REVOKE INSERT ON CollegeSociety.* FROM 'society_manager';

-- 6. Create an index (to speed up searches on student names)
CREATE INDEX idx_student_name ON STUDENT(StudentName);


/* =========================================
   CLEANUP COMMANDS (Run only after exam)
   ========================================= */
-- DROP USER 'student_admin'@'localhost';
-- DROP ROLE 'society_manager';
-- DROP INDEX idx_student_name ON STUDENT;