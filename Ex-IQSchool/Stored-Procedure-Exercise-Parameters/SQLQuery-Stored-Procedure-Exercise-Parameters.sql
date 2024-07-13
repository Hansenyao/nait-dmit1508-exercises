USE IQSchool
GO

-- 1. Create a stored procedure called “GoodCourses” to select all the course names that have averages greater than a given value. 
DROP PROCEDURE IF EXISTS GoodCourses
GO
CREATE PROCEDURE GoodCourses (@average DECIMAL(5,2) = NULL)
AS
BEGIN
	IF @average IS NULL
		BEGIN
			RaisError('You must privode a mark value!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT Course.CourseName, AVG(Registration.Mark) AS 'Average Mark'
			FROM Course
				INNER JOIN Offering
				ON Course.CourseId = Offering.CourseId
				INNER JOIN Registration
				ON Offering.OfferingCode = Registration.OfferingCode
			GROUP BY Course.CourseId,Course.CourseName
			HAVING AVG(Registration.Mark) > @average
		END
END
RETURN
GO
-- Test
EXEC GoodCourses @average = 85
GO

-- 2. Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names that have average > a given value in a given semester. 
-- *You can check all parameters in one conditional expression and a common message printed if any of them are missing*
DROP PROCEDURE IF EXISTS HonorCoursesForOneTerm
GO
CREATE PROCEDURE HonorCoursesForOneTerm (@average DECIMAL(5,2) = NULL, @semester VARCHAR(25) = NULL)
AS
BEGIN
	IF @average IS NULL
		BEGIN
			RaisError('You must privode a mark value!', 16, 1)
		END
	ELSE IF @semester IS NULL
		BEGIn
			RaisError('You must privode a semester value!', 16, 2)
		END
	ELSE
		BEGIN
			SELECT Course.CourseName, AVG(Registration.Mark) AS 'Average Mark', Offering.SemesterCode
			FROM Course
				INNER JOIN Offering
				ON Course.CourseId = Offering.CourseId
				INNER JOIN Registration
				ON Offering.OfferingCode = Registration.OfferingCode
			WHERE Offering.SemesterCode = @semester
			GROUP BY Course.CourseId,Course.CourseName, Offering.SemesterCode
			HAVING AVG(Registration.Mark) > @average
		END
END
RETURN
GO
-- Test
EXEC HonorCoursesForOneTerm 50, 'A600'
GO

-- 3. Create a stored procedure called “NotInACourse” that lists the full names of the student that are not taught a given CourseID.
DROP PROCEDURE IF EXISTS NotInACourse
GO
CREATE PROCEDURE NotInACourse(@CourseID AS VARCHAR(20) = NULL)
AS
BEGIN
	IF @CourseID IS NULL
		BEGIN
			RaisError('You must privode a Course ID!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT Student.FirstName + ' ' + Student.LastName AS 'Staff Name'
			FROM Student
			WHERE Student.StudentID NOT IN (SELECT Registration.StudentID
											FROM Registration
												INNER JOIN Offering
												ON Registration.OfferingCode = Offering.OfferingCode
											WHERE Offering.CourseId = @CourseID)
		END
END
RETURN
GO
--Test
EXEC NotInACourse 'DMIT1001'
GO

-- 4. Create a stored procedure called “LowCourses” to select the course name of the course(s) 
--   that have had less than a given number of students in them.
DROP PROCEDURE IF EXISTS LowCourses
GO
CREATE PROCEDURE LowCourses (@numbers INT = NULL)
AS
BEGIN
	IF @numbers IS NULL
		BEGIN
			RaisError('You must privode a students number!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT Course.CourseName
			FROM Course
				INNER JOIN Offering
				ON Course.CourseId = Offering.CourseId
				INNER JOIN Registration
				ON Offering.OfferingCode = Registration.OfferingCode
			GROUP BY Course.CourseId, Course.CourseName
			HAVING COUNT(*) < @numbers
		END
END
RETURN
GO
-- Test
EXEC LowCourses 4
GO

-- 5. Create a stored procedure called “ListaProvince” to list all the student’s names that are in a given province.
DROP PROCEDURE IF EXISTS ListaProvince
GO
CREATE PROCEDURE ListaProvince (@province VARCHAR(25) = NULL)
AS
BEGIN
	IF @province IS NULL
		BEGIN
			RaisError('You must privode a province name!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name'
			FROM Student
			WHERE Student.Province = @province
		END
END
RETURN
GO
-- Test
EXEC ListaProvince 'SK'

-- 6. Create a stored procedure called “Transcript” to select the transcript for a given StudentID. 
-- Select the StudentID, full name, course ID’s, course names, and marks.
DROP PROCEDURE IF EXISTS Transcript
GO
CREATE PROCEDURE Transcript (@StudentID INT = NULL)
AS
BEGIN
	IF @StudentID IS NULL
		BEGIN
			RaisError('You must privode a student ID!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT Student.StudentID, Student.FirstName + ' ' + Student.LastName AS 'Student', Course.CourseName, Registration.Mark
			FROM Student
				INNER JOIN Registration
				ON Student.StudentID = Registration.StudentID
				INNER JOIN Offering
				ON Registration.OfferingCode = Offering.OfferingCode
				INNER JOIN Course
				ON Offering.CourseId = Course.CourseId
			WHERE Student.StudentID = @StudentID
		END
END
RETURN
GO
-- Test
EXEC Transcript 199899200

-- 7. Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 
DROP PROCEDURE IF EXISTS PaymentTypeCount
GO
CREATE PROCEDURE PaymentTypeCount (@description VARCHAR(30) = NULL)
AS
BEGIN
	IF @description IS NULL
		BEGIN
			RaisError('You must privode a payment type description!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT COUNT(Payment.PaymentTypeID) AS 'Payment Count' 
			FROM Payment
				INNER JOIN PaymentType
				ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
			WHERE PaymentType.PaymentTypeDescription = @description
		END
END
RETURN
GO
--Test
EXEC PaymentTypeCount 'VISA'
GO

-- 8. Create stored procedure called “ClassList” to select student Full names that are in a course for a given SemesterCode and CourseName.
DROP PROCEDURE IF EXISTS ClassList
GO
CREATE PROCEDURE ClassList (@SemesterCode VARCHAR(20) = NULL, @CourseName VARCHAR(50) = NULL)
AS
BEGIN
	IF @SemesterCode IS NULL
		BEGIN
			RaisError('You must privode a semester code!', 16, 1)
		END
	ELSE IF @CourseName IS NULL
		BEGIN
			RaisError('You must privode a course name!', 16, 2)
		END
	ELSE
		BEGIN
			SELECT Student.FirstName + ' ' + Student.LastName AS 'Student Name'
			FROM Student
				INNER JOIN Registration
				ON Student.StudentID = Registration.StudentID
				INNER JOIN Offering
				ON Registration.OfferingCode = Offering.OfferingCode
				INNER JOIN Course
				ON Offering.CourseId = Course.CourseId
			WHERE Offering.SemesterCode = @SemesterCode AND Course.CourseName = @CourseName
		END
END
RETURN
GO
-- Test
EXEC ClassList 'A200', 'IT System Administration'
GO
