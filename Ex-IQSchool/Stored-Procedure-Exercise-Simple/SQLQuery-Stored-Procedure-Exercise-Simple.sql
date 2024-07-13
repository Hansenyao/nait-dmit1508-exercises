USE IQSchool
GO

-- 1. Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%.
DROP PROCEDURE IF EXISTS HonorCourses
GO
CREATE PROCEDURE HonorCourses
AS
BEGIN
	SELECT Course.CourseName
	FROM Course
		INNER JOIN Offering
		ON Course.CourseId = Offering.CourseId
		INNER JOIN Registration
		ON Offering.OfferingCode = Registration.OfferingCode
	GROUP BY Course.CourseId, Course.CourseName
	HAVING AVG(Registration.Mark) > 80
END
RETURN
GO
-- Test
EXEC HonorCourses

-- 2. Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that have average >80% in semester A100.
DROP PROCEDURE IF EXISTS HonorCourses
GO
CREATE PROCEDURE HonorCourses
AS
BEGIN
	SELECT Course.CourseName
	FROM Course
		INNER JOIN Offering
		ON Course.CourseId = Offering.CourseId
		INNER JOIN Registration
		ON Offering.OfferingCode = Registration.OfferingCode
	WHERE  Offering.SemesterCode = 'A100'
	GROUP BY Course.CourseId, Course.CourseName
	HAVING AVG(Registration.Mark) > 80
END
RETURN
GO

-- 3. Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly.
ALTER PROCEDURE HonorCourses
AS
BEGIN
	SELECT Course.CourseName
	FROM Course
		INNER JOIN Offering
		ON Course.CourseId = Offering.CourseId
		INNER JOIN Registration
		ON Offering.OfferingCode = Registration.OfferingCode
	WHERE  Offering.SemesterCode = 'A200'
	GROUP BY Course.CourseId, Course.CourseName
	HAVING AVG(Registration.Mark) > 80
END
RETURN
GO

-- 4. Create a stored procedure called “NotInCOMP1017” that lists the full names of the staff that have not taught COMP1017.
DROP PROCEDURE IF EXISTS NotInCOMP1017
GO
CREATE PROCEDURE NotInCOMP1017
AS
	BEGIN
	SELECT DISTINCT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
	FROM Staff
	WHERE Staff.StaffID NOT IN (SELECT Offering.StaffID 
								FROM Offering 
								WHERE Offering.CourseId = 'COMP1017')
END
RETURN
GO
-- Test
EXEC NotInCOMP1017

-- 5. Create a stored procedure called “LowNumbers” to select the course name of the course(s) 
-- that have had the lowest number of students in it. Assume all courses have registrations.
DROP PROCEDURE IF EXISTS LowNumbers
GO
CREATE PROCEDURE LowNumbers
AS
BEGIN
	SELECT Course.CourseName
	FROM Registration
		INNER JOIN Offering
		ON Registration.OfferingCode = Offering.OfferingCode
		INNER JOIN Course
		ON Offering.CourseId = Course.CourseId
	GROUP BY Course.CourseId, Course.CourseName
	HAVING COUNT(*) <= ALL ( SELECT COUNT(*)
							FROM Registration
								INNER JOIN Offering
								ON Registration.OfferingCode = Offering.OfferingCode
							GROUP BY Offering.OfferingCode)
END
RETURN
GO
-- Test
EXEC LowNumbers
GO

-- 6. Create a stored procedure called “Provinces” to list all the student’s provinces.
DROP PROCEDURE IF EXISTS Provinces
GO
CREATE PROCEDURE Provinces
AS
BEGIN
	SELECT DISTINCT Student.Province
	FROM Student
END
Return
GO
-- Test
EXEC Provinces
GO

-- 7. OK, question 6 was ridiculously simple and serves no purpose. Remove that stored procedure from the database.
DROP PROCEDURE IF EXISTS Provinces
GO

-- 8. Create a stored procedure called “StudentPaymentTypes” that lists all the student names and their payment type Description. 
-- Ensure all the student names are listed.
DROP PROCEDURE IF EXISTS StudentPaymentTypes
GO
CREATE PROCEDURE StudentPaymentTypes
AS
BEGIN
	SELECT DISTINCT Student.FirstName + ' ' + Student.LastName AS 'Student', PaymentType.PaymentTypeDescription
	FROM Student
		INNER JOIN Payment
		ON Student.StudentID = Payment.StudentID
		INNER JOIN PaymentType
		ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
END
RETURN
GO
-- Test
EXEC StudentPaymentTypes
GO

-- 9. Modify the procedure from question 8 to return only the student names that have made payments.
ALTER PROCEDURE StudentPaymentTypes
AS
BEGIN
	SELECT DISTINCT Student.FirstName + ' ' + Student.LastName AS 'Student'
	FROM Student
		INNER JOIN Payment
		ON Student.StudentID = Payment.StudentID
END
RETURN
GO
-- Test
EXEC StudentPaymentTypes
GO

