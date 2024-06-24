/* 1. Select All position descriptions and the staff ID's that are in those positions */
SELECT Position.PositionDescription, Staff.StaffID
FROM Position
	LEFT JOIN Staff
	ON Position.PositionID = Staff.StaffID

/* 2. Select the Position Description and the count of how many staff are in those positions. Returnt the count for ALL positions. */
SELECT Position.PositionDescription, COUNT(Staff.StaffID)
FROM Staff
	LEFT JOIN Position
	ON Staff.PositionID = Position.PositionID
GROUP BY Position.PositionDescription

/* 3. Select the average mark of ALL the students. Show the student names and averages. */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', AVG(Registration.Mark)
FROM Student
	LEFT JOIN Registration
	ON Student.StudentID = Registration.StudentID
GROUP BY Student.FirstName, Student.LastName

/* 4. Select the highest and lowest mark for each student. */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', MAX(Registration.Mark) AS 'MAX', MIN(Registration.Mark) AS 'MIN'
FROM Student
	LEFT JOIN Registration
	ON Student.StudentID = Registration.StudentID
GROUP BY Student.FirstName, Student.LastName

/* 5. How many students are in each club? Display the club name and count. */
SELECT Club.ClubName, COUNT(*) AS 'Count'
FROM Club
	LEFT JOIN Activity
	ON Club.ClubId = Activity.ClubId
GROUP BY Club.ClubName
	




