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
 Go


-- 2.Create a procedure called ‘StudentPaymentTransaction’  that accepts Student ID and paymentamount as parameters. 
-- Add the payment to the payment table and adjust the students balance owing to reflect the payment.



-- 3.Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters. 
-- Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. 
-- If the result would be a negative balance set it to 0.



-- 4.Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a parameter and deletes 
-- all records pertaining to that student. It should look like that student was never in IQSchool! 



-- 5.Create a stored procedure that will accept a year and will archive all registration records from that 
-- year (startdate is that year) from the registration table to an archiveregistration table. 
-- Copy all the appropriate records from the registration table to the archiveregistration table and delete them from the registration table. 
-- The archiveregistration table will have the same definition as the registration table but will not have any constraints.