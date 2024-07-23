--Stored Procedure Transaction Exercise

USE IQSchool
Go

DROP TABLE IF EXISTS ArchiveRegistration
Go
DROP PROCEDURE IF EXISTS RegisterStudentTransaction
DROP PROCEDURE IF EXISTS StudentPaymentTransaction
DROP PROCEDURE IF EXISTS WithdrawStudentTransaction
DROP PROCEDURE IF EXISTS DisappearingStudent
DROP PROCEDURE IF EXISTS ArchiveRegistrationTransaction
Go


 -- 1.Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID and offering code as parameters. 
 -- If the number of students in that course and semester are not greater than the Max Students for that course, 
 -- add a record to the Registration table and add the cost of the course to the students balance. 
 -- If the registration would cause the course in that semester to have greater than MaxStudents for that course raise an error.
 CREATE PROCEDURE RegisterStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
 AS
 BEGIN
	DECLARE @StudentCount INT
	DECLARE @MaxStudents INT
	DECLARE @CourseCost SMALLMONEY
	DECLARE @RowCount INT
	DECLARE @Error INT

	IF @StudentID IS NULL OR @OfferingCode IS NULL
		BEGIN
			RaisError('You must provide a Student ID and Offering Code', 16, 1)
		END
	ELSE
		BEGIN
			/* Select the max student count of course */
			SELECT @MaxStudents = Course.MaxStudents FROM Course
				INNER JOIN Offering
				ON Course.CourseId = Offering.CourseId
			WHERE Offering.OfferingCode = @OfferingCode

			/* Select current student count of course */
			SELECT @StudentCount = COUNT(Registration.OfferingCode) FROM Registration
			WHERE Registration.OfferingCode = @OfferingCode AND Registration.WithdrawYN != 'Y'

			/* Check current student count is more than max or not */
			IF @StudentCount >= @MaxStudents
				BEGIN
					RaisError('The course is already full.', 16, 2)
				END
			ELSE
				BEGIN
					/* Select the course cost */
					SELECT @CourseCost = Course.CourseCost FROM Course
						INNER JOIN Offering
						ON Course.CourseId = Offering.CourseId
					WHERE Offering.OfferingCode = @OfferingCode
					IF @@ROWCOUNT = 0
						BEGIN
							RaisError('No any course record related offering code: %s', 16, 3, @OfferingCode)
						END
					ELSE
						BEGIN
							BEGIN TRANSACTION
							/* Insert new record to table Registion */
							INSERT INTO Registration
								(StudentID, OfferingCode)
							VALUES
								(@StudentID, @OfferingCode)
							SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
							IF @Error <> 0
								BEGIN
									ROLLBACK TRANSACTION
									RaisError('Insert into Registration failed.', 16, 4)
								END
							ELSE IF @RowCount = 0 
								BEGIN
									ROLLBACK TRANSACTION
									RaisError('You did not insert any records into Registration.', 16, 5)
								END
							ELSE
								BEGIN
									/* Update student's balance */
									UPDATE Student
										SET Student.BalanceOwing = Student.BalanceOwing + @CourseCost
									WHERE Student.StudentID = @StudentID
									SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
									IF @Error <> 0
										BEGIN
											ROLLBACK TRANSACTION
											RaisError('Upate table student failed.', 16, 6)
										END
									ELSE IF @RowCount = 0
										BEGIN
											ROLLBACK TRANSACTION
											RaisError('You did not update any records into table student.', 16, 7)
										END
									ELSE
										BEGIN
											COMMIT TRANSACTION
										END
								END
						END
				END
		END
 END
 RETURN
 GO


-- 2.Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and paymentamount as parameters. 
-- Add the payment to the payment table and adjust the students balance owing to reflect the payment.
CREATE PROCEDURE StudentPaymentTransaction (@StudentID INT = NULL, @PaymentAmount SMALLMONEY = NULL, @PaymentTypeID TINYINT = NULL)
AS
BEGIN
	/* Checking parameters */
	IF @StudentID IS NULL OR @PaymentAmount IS NULL OR @PaymentTypeID IS NULL
		BEGIN
			RaisError('You must provide a Student ID, Payment amount and Payment type ID.', 16, 1)
		END
	ELSE
		BEGIN
			DECLARE @Error INT
			DECLARE @RowCount INT

			/* Check student ID exists or not */
			IF NOT EXISTS (SELECT * FROM Student WHERE Student.StudentID = @StudentID)
				BEGIN
					RaisError('Student ID: %d does not exists.', 16, 2, @StudentID)
					return
				END
			/* Check payment type ID exists or not */
			IF NOT EXISTS (SELECT * FROM PaymentType WHERE PaymentType.PaymentTypeID = @PaymentTypeID)
				BEGIN
					RaisError('Payment type ID: %d does not exists.', 16, 3, @PaymentTypeID)
					return
				END

			-- Use transaction to update tables Payment and Student
			BEGIN TRANSACTION
			/* Insert the payment record to table Payment */
			INSERT INTO Payment
				(Amount, PaymentID, StudentID)
			VALUES
				(@PaymentAmount, @PaymentTypeID, @StudentID)
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Insert the new record to table Payment failed.', 16, 4)
					ROLLBACK TRANSACTION
					return;
				END
			IF @RowCount = 0
				BEGIN
					RaisError('You did not insert any record to table Payment.', 16, 5)
					ROLLBACK TRANSACTION
					return;
				END
			/* Update student's balance owing in table Student */
			UPDATE Student
				SET Student.BalanceOwing = Student.BalanceOwing - @PaymentAmount
			WHERE Student.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Insert the new record to table Student failed.', 16, 6)
					ROLLBACK TRANSACTION
					return;
				END
			IF @RowCount = 0
				BEGIN
					RaisError('You did not insert any record to table Student.', 16, 7)
					ROLLBACK TRANSACTION
					return;
				END
			-- OK! Commit Transaction
			COMMIT TRANSACTION
		END
END
RETURN
GO



-- 3.Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters. 
-- Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. 
-- If the result would be a negative balance set it to 0.
CREATE PROCEDURE WithdrawStudentTransaction (@StudentID INT = NULL, @OfferingCode INT = NULL)
AS
BEGIN
	/* Checking parameters */
	IF @StudentID IS NULL OR @OfferingCode IS NULL
		BEGIN
			RaisError('You must provide a Student ID, Offering code.', 16, 1)
		END
	ELSE
		BEGIN
			DECLARE @Error INT
			DECLARE @RowCount INT
			DECLARE @WithDraw CHAR
			DECLARE @CourseCost DECIMAL(6,2)
			DECLARE @BalanceOwing DECIMAL(7,2)
			DECLARE @NewBalanceOwing DECIMAL(7,2)

			/* Check the record exists or not in table Registration */
			SELECT @WithDraw = Registration.WithdrawYN 
			FROM Registration
			WHERE Registration.StudentID = @StudentID AND Registration.OfferingCode = @OfferingCode
			SELECT @RowCount = @@ROWCOUNT
			IF @RowCount = 0
				BEGIN
					RaisError('Student ID: %d and Offering code: %d does not exists in table Registration.', 16, 2, @StudentID, @OfferingCode)
					return
				END
			IF @WithDraw = 'Y'
				BEGIN
					RaisError('Student ID: %d and Offering code: %d is withdraw already.', 16, 3, @StudentID, @OfferingCode)
					return
				END

			/* Select the cost of course which is going to be withdraw */
			SELECT @CourseCost = Course.CourseCost 
			FROM Course
				INNER JOIN Offering
				ON Course.CourseId = Offering.CourseId
			WHERE Offering.OfferingCode = @OfferingCode;

			/* Select the student's balance owing */
			SELECT @BalanceOwing = Student.BalanceOwing
			FROM Student
			WHERE Student.StudentID = @StudentID

			/* Calculate the new balance owing */
			SET @NewBalanceOwing = @BalanceOwing - 0.5*@CourseCost
			IF @NewBalanceOwing < 0
				BEGIN
					SET @NewBalanceOwing = 0
				END
			
			-- Use transaction to update tables Registration and Student
			BEGIN TRANSACTION
			/* Update table Registration */
			UPDATE Registration
				SET Registration.WithdrawYN = 'Y'
			WHERE Registration.StudentID = @StudentID AND Registration.OfferingCode = @OfferingCode
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Update table Registration failed.', 16, 4)
					ROLLBACK TRANSACTION
					RETURN
				END
			IF @RowCount = 0
				BEGIN
					RaisError('You did not update any record in table Registration.', 16, 5)
					ROLLBACK TRANSACTION
					RETURN
				END
			/* Update table Student */
			UPDATE Student
				SET Student.BalanceOwing = @NewBalanceOwing
			WHERE Student.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Update table Student failed.', 16, 6)
					ROLLBACK TRANSACTION
					RETURN
				END
			IF @RowCount = 0
				BEGIN
					RaisError('You did not update any record in table Student.', 16, 7)
					ROLLBACK TRANSACTION
					RETURN
				END
			-- OK! Commit Transaction
			COMMIT TRANSACTION
		END
END
RETURN
GO



-- 4.Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a parameter and deletes 
-- all records pertaining to that student. It should look like that student was never in IQSchool! 
CREATE PROCEDURE DisappearingStudent (@StudentID INT = NULL)
AS
BEGIN
	/* Checking parameters */
	IF @StudentID IS NULL
		BEGIN
			RaisError('You must provide a Student ID.', 16, 1)
		END
	ELSE
		BEGIN
			DECLARE @Error INT
			DECLARE @RowCount INT

			/* Check this student id exists or not */
			IF NOT EXISTS(SELECT * FROM Student WHERE Student.StudentID = @StudentID)
				BEGIN
					RaisError('The student ID: %d does not exist.', 16, 2, @StudentID)
					RETURN;
				END
			-- Use transaction to update multi-tables
			BEGIN TRANSACTION
			/* Delete this student's records in table Activity */
			DELETE Activity WHERE Activity.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Delete the record in table Activity failed.', 16, 3)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not delete any record in table Activity.', 16, 4)
					ROLLBACK TRANSACTION
					RETURN;
				END
			
			/* Delete this student's records in table Payment */
			DELETE Payment WHERE Payment.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Delete the record in table Payment failed.', 16, 5)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not delete any record in table Payment.', 16, 6)
					ROLLBACK TRANSACTION
					RETURN;
				END
				
			/* Delete this student's records in table Registration */
			DELETE Registration WHERE Registration.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Delete the record in table Registration failed.', 16, 7)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not delete any record in table Registration.', 16, 8)
					ROLLBACK TRANSACTION
					RETURN;
				END

			/* Delete the relevant record in table Student */
			DELETE Student WHERE Student.StudentID = @StudentID
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Delete the record in table Student failed.', 16, 9)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not delete any record in table Student.', 16, 10)
					ROLLBACK TRANSACTION
					RETURN;
				END
			-- OK! Commit Transaction
			COMMIT TRANSACTION
		END
END
RETURN
GO



-- 5.Create a stored procedure that will accept a year and will archive all registration records from that 
-- year (startdate is that year) from the registration table to an archiveregistration table. 
-- Copy all the appropriate records from the registration table to the archiveregistration table and delete them from the registration table. 
-- The archiveregistration table will have the same definition as the registration table but will not have any constraints.

/* Create the new table at first */
CREATE TABLE Archiveregistration (
	OfferingCode INT NOT NULL,
	StudentID INT NOT NULL,
	Mark DECIMAL(5,2),
	WithdrawYN CHAR(1)
)
GO

CREATE PROCEDURE ArchiveRegistrationTransaction (@RecordingYear CHAR(4) = NULL)
AS
BEGIN
	/* Checking parameters */
	IF @RecordingYear IS NULL
		BEGIN
			RaisError('You must provide a year value.', 16, 1)
		END
	ELSE
		BEGIN
			DECLARE @Error INT
			DECLARE @RowCount INT

			-- Use transaction to update tables Archiveregistration and Registration
			BEGIN TRANSACTION
			/* Insert all relevant records to table Archiveregistration */
			INSERT INTO Archiveregistration
				(OfferingCode, StudentID, Mark, WithdrawYN)
			SELECT Registration.OfferingCode, Registration.StudentID, Registration.Mark, Registration.WithdrawYN
			FROM Registration
				INNER JOIN Offering
				ON Registration.OfferingCode = Offering.OfferingCode
				INNER JOIN Semester
				ON Offering.SemesterCode = Semester.SemesterCode
			WHERE DATEPART(YY, Semester.StartDate) = @RecordingYear
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Insert the records into table Archiveregistration failed.', 16, 2)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not insert any record into table Archiveregistration.', 16, 3)
					ROLLBACK TRANSACTION
					RETURN;
				END
			/* Remove the relevant records from table Registration */
			DELETE Registration
			WHERE Registration.OfferingCode IN (SELECT Offering.OfferingCode
												FROM Offering
													INNER JOIN Semester
													ON Offering.SemesterCode = Semester.SemesterCode
												WHERE DATEPART(YY, Semester.StartDate) = @RecordingYear)
			SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
			IF @Error <> 0
				BEGIN
					RaisError('Remove records from table Registration failed.', 16, 4)
					ROLLBACK TRANSACTION
					RETURN;
				END
			IF @RowCount <> 0
				BEGIN
					RaisError('You did not remove any record from table Registration.', 16, 5)
					ROLLBACK TRANSACTION
					RETURN;
				END
			-- OK! Commit Transaction
			COMMIT TRANSACTION
		END
END
RETURN
GO