CREATE DATABASE IF NOT EXISTS plp_assignment;
USE plp_assignment;

-- Question 1: Create the student table
CREATE TABLE student (
    id INT PRIMARY KEY,
    fullName VARCHAR(100),
    age INT
);

-- Question 2: Insert 3 records
INSERT INTO student (id, fullName, age) VALUES
(1, 'John Doe', 20),
(2, 'Jane Smith', 22),
(3, 'Alice Johnson', 19);

-- Question 3: Update age for student with ID 2 to 20
UPDATE student
SET age = 20
WHERE id = 2;
