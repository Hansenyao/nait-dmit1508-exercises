-- 1.Create a stored procedure called StudentClubCount. It will accept a clubID as a parameter.
-- If the count of students in that club is greater than 2 print ‘A successful club!’.
-- If the count is not greater than 2 print ‘Needs more members!’.
Drop PROCEDURE IF Exists StudentClubCount
GO
CREATE PROCEDURE StudentClubCount
	@clubID VARCHAR(50) = NULL
AS
BEGIN
	IF @clubID IS NULL
		BEGIN
			PRINT 'You must provide a ClubId'
		END
	ELSE
		BEGIN
			DECLARE @Count Integer
			SELECT @Count = COUNT(*) 
			FROM Activity 
			WHERE Activity.ClubId = @clubID
			IF @Count > 2
				BEGIN
					PRINT 'A successful club!'
				END
			ELSE
				BEGIN
					PRINT 'Needs more members!'
				END
		END
END
RETURN
GO
-- Test
EXEC StudentClubCount
EXEC StudentClubCount @clubID = 'ACM'
EXEC StudentClubCount @clubID = 'CHESS'
GO


-- 2.Create a stored procedure called BalanceOrNoBalance. It will accept a studentID as a parameter. 
-- Each course has a cost. If the total of the costs for the courses the student is registered in is
-- more than the total of the payments that student has made, then print ‘balance owing!’ 
-- otherwise print ‘Paid in full! Welcome to IQ School!’
-- Do Not use the BalanceOwing field in your solution. 
DROP PROCEDURE IF EXISTS BalanceOrNoBalance
GO
CREATE PROCEDURE BalanceOrNoBalance
	@studentID VARCHAR(50) = NULL
AS
BEGIN
	IF @studentID = NULL
		BEGIN
			PRINT 'You must provide a StudentID'
		END
	ELSE
		BEGIN
			DECLARE @Cost DECIMAL(6, 2), @Payment MONEY
			SELECT @Cost = SUM(Course.CourseCost) 
			FROM Course
				INNER JOIN Offering
				ON Offering.CourseId = Course.CourseId
				INNER JOIN Registration
				ON Registration.OfferingCode = Offering.OfferingCode
			WHERE Registration.StudentID = @studentID
			IF @Cost IS NULL 
				BEGIN
					SET @Cost = 0.0
				END

			SELECT @Payment = SUM(Payment.Amount) 
			FROM Payment 
			WHERE Payment.StudentID = @studentID
			IF @Payment IS NULL 
				BEGIN
					SET @Payment = 0.0
				END

			IF @Cost > @Payment
				BEGIN
					PRINT 'balance owing!'
				END
			ELSE
				BEGIN
					PRINT 'Paid in full! Welcome to IQ School!'
				END
		END
END
RETURN 
GO
-- Test
EXEC BalanceOrNoBalance @studentID = '200978500'
EXEC BalanceOrNoBalance @studentID = '198933540'
EXEC BalanceOrNoBalance @studentID = '199899200'
GO

-- 3.Create a stored procedure called ‘DoubleOrNothin’. 
-- It will accept a student’s first name and last name as parameters. 
-- If the student’s name already is in the table, then print ‘We already have a student with the name firstname lastname!’
-- Otherwise print ‘Welcome firstname lastname!’
DROP PROCEDURE IF EXISTS DoubleOrNothin
GO
CREATE PROCEDURE DoubleOrNothin
	@firstName VARCHAR(20) = NULL,
	@lastName VARCHAR(20) = NULL
AS
BEGIN
	IF @firstName IS NULL OR @lastName IS NULL
		BEGIN
			Print 'You must provide a student first and last name'
		END
	ELSE
		BEGIN
			IF EXISTS(SELECT * FROM Student WHERE Student.FirstName = @firstName AND Student.LastName = @lastName)
				BEGIN
					PRINT 'We already have a student with the name ' + @firstName + ' ' + @lastName + '!'
				END
			ELSE
				BEGIN
					PRINT 'Welcome ' + @firstName + ' ' + @lastName + '!'
				END
		END
END
RETURN
GO
-- Test
EXEC DoubleOrNothin @firstName = 'Winnie', @lastName = 'Woo'
EXEC DoubleOrNothin @firstName = 'aa', @lastName = 'ee'
GO

-- 4.4.Create a procedure called ‘StaffRewards’. It will accept a staff ID as a parameter. 
-- If the number of classes the staff member has ever taught is between 0 and 10 print ‘Well done!’, 
-- if it is between 11 and 20 print ‘Exceptional effort!’, 
-- if the number is greater than 20 print ‘Totally Awesome Dude!’
DROP PROCEDURE IF EXISTS StaffRewards
GO
CREATE PROCEDURE StaffRewards (@staffID  INT = NULL) 
AS
BEGIN
	IF @staffID IS NULL
		BEGIN
			PRINT 'You must provide a Staff ID'
		END
	ELSE
		BEGIN
			DECLARE @classesCount AS INT
			SELECT @classesCount = COUNT(*) FROM Offering 
				INNER JOIN Registration
				ON Offering.OfferingCode = Registration.OfferingCode
			WHERE Offering.StaffID = @staffID
	
			IF @classesCount <= 0
				BEGIN
					PRINT 'No classes!'
				END
			ELSE IF @classesCount > 0 AND @classesCount <= 10
				BEGIN
					PRINT 'Well done!' 
				END
			ELSE IF @classesCount > 10 AND @classesCount <= 20
				BEGIN
					PRINT 'Exceptional effort!' 
				END
			ELSE
				BEGIN
					PRINT 'Totally Awesome Dude!' 
				END
		END
END
RETURN
GO

-- Test
EXEC StaffRewards @staffID = 3
EXEC StaffRewards @staffID = 4
EXEC StaffRewards @staffID = 5
EXEC StaffRewards @staffID = 6
GO
