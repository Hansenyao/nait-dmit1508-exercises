use IQSchool
go

-- Q1
Begin Transaction
Select OfferingCode, StudentID, WithdrawYN from Registration where StudentID = 200495500
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Exec RegisterStudentTransaction 200495500, 1012
Select OfferingCode, StudentID, WithdrawYN from Registration where StudentID = 200495500
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Rollback Transaction

-- Q2
Begin Transaction
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Select PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID from Payment where StudentID = 200495500 
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Exec StudentPaymentTransaction 200495500, 300, 1
Select PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID from Payment where StudentID = 200495500 
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Rollback Transaction

-- Q3
Begin Transaction
Select OfferingCode, StudentID, WithdrawYN from Registration where StudentID = 200495500
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Exec WithdrawStudentTransaction 200495500, 1011
Select OfferingCode, StudentID, WithdrawYN from Registration where StudentID = 200495500
Select StudentID, BalanceOwing from Student where StudentID = 200495500
Rollback Transaction

-- Q4
Begin Transaction
Select StudentID, OfferingCode from Registration Where StudentID = 200495500
Select StudentID, PaymentID from Payment Where StudentID = 200495500
Select StudentID, ClubId from Activity Where StudentID = 200495500
Select StudentID, FirstName from Student Where StudentID = 200495500
Exec DisappearingStudent 200495500
Select StudentID, OfferingCode from Registration Where StudentID = 200495500
Select StudentID, PaymentID from Payment Where StudentID = 200495500
Select StudentID, ClubId from Activity Where StudentID = 200495500
Select StudentID, FirstName from Student Where StudentID = 200495500
Rollback Transaction

-- Q5
Begin Transaction
Select OfferingCode, StudentID, Mark, WithdrawYN from ArchiveRegistration
Select	Registration.OfferingCode, Registration.StudentID, 
		Registration.Mark, Registration.WithdrawYN
From	Registration 
			Inner Join Offering
				On Registration.OfferingCode = Offering.OfferingCode
			Inner Join Semester
				On Semester.Semestercode = Offering.Semestercode
Where	Datepart(YY, Semester.StartDate) = 2022
exec ArchiveRegistrationTransaction 2022
Select OfferingCode, StudentID, Mark, WithdrawYN from ArchiveRegistration
Select	Registration.OfferingCode, Registration.StudentID, 
		Registration.Mark, Registration.WithdrawYN
From	Registration 
			Inner Join Offering
				On Registration.OfferingCode = Offering.OfferingCode
			Inner Join Semester
				On Semester.Semestercode = Offering.Semestercode
Where	Datepart(YY, Semester.StartDate) = 2022
Rollback Transaction
