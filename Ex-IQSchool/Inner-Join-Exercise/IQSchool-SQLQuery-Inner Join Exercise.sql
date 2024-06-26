/* 1.Select Student full names and the course ID's they are registered in. */
SELECT Student.FirstName + ' '+ Student.LastName AS 'Student Name', Offering.CourseId
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode

/* 2.Select the Staff full names and the Course ID’s they teach */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name', Offering.CourseId
FROM Staff
	INNER JOIN Offering
	ON Staff.StaffID = Offering.StaffID

/* 3.Select all the Club ID's and the Student full names that are in them */
SELECT Activity.ClubId, Student.FirstName + ' ' + Student.LastName AS 'Student Name'
FROM Activity
	INNER JOIN Student
	ON Student.StudentID = Activity.StudentID

/* 4.Select the Student full name, courseID's and marks for studentID 199899200. */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Offering.CourseId, Registration.Mark
From Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
WHERE Student.StudentID = '199899200'

/* 5.Select the Student full name, course names and marks for studentID 199899200 */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Course.CourseName, Registration.Mark
From Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
WHERE Student.StudentID = '199899200'

/* 6.Select the CourseID, CourseNames, and the Semesters they have been taught in */
SELECT DISTINCT Course.CourseId, Course.CourseName, Offering.SemesterCode
FROM Course
	INNER JOIN Offering
	ON Course.CourseId = Offering.CourseId
ORDER BY Course.CourseId ASC

/* 7.What Staff Full Names have taught IT System Administration? */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
FROM Staff
	INNER JOIN Offering
	ON Staff.StaffID = Offering.StaffID
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
WHERE Course.CourseName = 'IT System Administration'

/* 8.What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames */
SELECT Student.FirstName + ' ' + Student.LastName, Course.CourseName
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
WHERE Student.StudentID = '199912010' AND Offering.SemesterCode = 'A100'

/* 9.What are the Student Names, courseID's that have Marks > 80? */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Offering.CourseId
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
WHERE Registration.Mark > 80








