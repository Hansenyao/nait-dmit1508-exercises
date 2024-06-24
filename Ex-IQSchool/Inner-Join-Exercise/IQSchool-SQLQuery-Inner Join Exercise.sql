/* 1.Select Student full names and the course ID's they are registered in. */
SELECT Student.FirstName + ' '+ Student.LastName AS 'Student Name', Offering.CourseId
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
ORDER BY [Student Name]

/* 2.Select the Staff full names and the Course ID’s they teach */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name', Offering.CourseId
FROM Staff
	INNER JOIN Offering
	ON Staff.StaffID = Offering.StaffID
ORDER BY [Staff Name]

/* 3.Select all the Club ID's and the Student full names that are in them */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Club.ClubId
FROM Student
	INNER JOIN Activity
	ON Student.StudentID = Activity.StudentID
	INNER JOIN Club
	ON Activity.ClubId = Club.ClubId
ORDER BY [ClubId]

/* 4.Select the Student full name, courseID's and marks for studentID 199899200. */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Offering.CourseId, Registration.Mark
From Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
WHERE Student.StudentID = '199899200'
ORDER BY Registration.Mark DESC

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
ORDER BY Registration.Mark DESC

/* 6.Select the CourseID, CourseNames, and the Semesters they have been taught in */
SELECT Course.CourseId, Course.CourseName, Semester.SemesterCode, Semester.StartDate, Semester.EndDate
FROM Course
	INNER JOIN Offering
	ON Course.CourseId = Offering.CourseId
	INNER JOIN Semester
	ON Offering.SemesterCode = Semester.SemesterCode
ORDER BY Semester.StartDate ASC

/* 7.What Staff Full Names have taught IT System Administration? */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name', Course.CourseName
FROM Staff
	INNER JOIN Offering
	ON Staff.StaffID = Offering.StaffID
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
WHERE Course.CourseName = 'IT System Administration'

/* 8.What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames */
SELECT Student.FirstName + ' ' + Student.LastName, Course.CourseName, Semester.SemesterCode
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
	INNER JOIN Semester
	ON Offering.SemesterCode = Semester.SemesterCode
WHERE Student.StudentID = '199912010' AND Semester.SemesterCode = 'A100'

/* 9.What are the Student Names, courseID's that have Marks > 80? */
SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name', Course.CourseId, Registration.Mark
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
	INNER JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
	INNER JOIN Course
	ON Offering.CourseId = Course.CourseId
WHERE Registration.Mark > 80
ORDER BY [Registration].Mark ASC








