use IQSchool
Go

--1. How many staff are there in each Position? Select the number and PositiOn Description
Select	Position.PositionDescription, Count(*) "Number of Staff"
From	Staff 
			Inner Join Position
				On Staff.PositionID = Position.PositionID
Group By Position.PositionId, Position.PositionDescription

--2. Select	the average mark for each course. Display the CourseName and the average mark
Select	Course.CourseName, Avg(Registration.Mark)"Average Mark"
From	Offering
			Inner Join Course
				On Offering.CourseId = Course.CourseId
			Inner Join Registration
				On Offering.OfferingCode = Registration.OfferingCode
Group By Course.CourseId, Course.CourseName

--3. How many payments where made for each payment type. Display the PaymentTypeDescriptiOn and the count
Select	PaymentType.PaymentTypeDescription, Count(*) "Count of Payment Type"
From	Payment
			Inner Join PaymentType
				On PaymentType.PaymentTypeID =Payment.PaymentTypeID
Group By Payment.PaymentTypeID, PaymentType.PaymentTypeDescription

--4. Select	the average mark for each student. Display the Student Name and their average mark
Select	Student.FirstName  + ' ' + Student.LastName "Student Name", Avg(Registration.Mark) "Average"
From	Registration
			Inner Join Student
				On Student.StudentID = Registration.StudentID
Group By  Student.StudentID, Student.FirstName, Student.LastName

--5. Select	the same data as question 4 but only show the student names and averages that are > 80
Select	Student.FirstName  + ' ' + Student.LastName "Student Name", Avg(Registration.Mark) "Average"
From	Registration
			Inner Join Student
				On Student.StudentID = Registration.StudentID
Group By Student.StudentID, Student.FirstName, Student.LastName
Having Avg(Mark) > 80
 
--6.what is the highest, lowest and average payment amount for each payment type description? 
Select	PaymentType.PaymentTypeDescription, Max(Payment.Amount) "Highest",
		Min(Payment.Amount) "Lowest", Avg(Payment.Amount) "Average"
From	Payment
			Inner Join PaymentType
				On Payment.PaymentTypeID = PaymentType.PaymentTypeID
Group By PaymentType.PaymentTypeID, PaymentType.PaymentTypeDescription

--7. How many students are there in each club? Show the clubName and the count
Select	Club.ClubName, Count(*) "Number of Students"
From	Activity
			Inner Join Club
				On Activity.ClubId = Club.ClubId
Group By Club.ClubId, Club.ClubName

--8. Which clubs have 3 or more students in them? Display the Club Names.
Select	Club.ClubName
From	Activity
			Inner Join Club 
				On Activity.ClubId = Club.ClubId
Group By Club.ClubId, Club.ClubName 
Having Count(*) >= 3
