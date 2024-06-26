-- 1. Select the payment dates and payment amount for all payments that were Cash
SELECT Payment.PaymentDate, Payment.Amount
FROM Payment
WHERE Payment.PaymentTypeID 
	IN (SELECT PaymentType.PaymentTypeID FROM PaymentType WHERE PaymentType.PaymentTypeDescription = 'Cash')

-- 2. Select the Student ID's of all the students that are in the 'Association of Computing Machinery' club
SELECT Student.StudentID
FROM Student
WHERE Student.StudentID 
	IN (SELECT Activity.StudentID FROM Activity WHERE Activity.ClubId 
		IN (SELECT Club.ClubId FROM Club WHERE Club.ClubName = 'Association of Computing Machinery'))

-- 3. Select All the staff full names that have taught a course.
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
FROM Staff
WHERE Staff.StaffID 
	IN (SELECT Offering.StaffID FROM Offering)

-- 4. Select All the staff full names that taught ANAP1525.
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
FROM Staff
WHERE Staff.StaffID 
	IN (SELECT Offering.StaffID FROM Offering WHERE Offering.CourseId = 'ANAP1525')

-- 5. Select All the staff full names that have never taught a course
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
FROM Staff
WHERE Staff.StaffID 
	NOT IN (SELECT Offering.StaffID FROM Offering)

-- 6. Select the Payment TypeID(s) that have the highest number of Payments made.
SELECT Payment.PaymentTypeID
FROM Payment
GROUP BY Payment.PaymentTypeID
HAVING COUNT(Payment.PaymentTypeID) 
	IN (SELECT TOP 1 COUNT(Payment.PaymentTypeID) AS 'Count'
		FROM Payment
		GROUP BY Payment.PaymentTypeID
		ORDER BY [Count] DESC)

-- 7. Select the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentType.PaymentTypeDescription
FROM PaymentType
	INNER JOIN (SELECT Payment.PaymentTypeID 
				FROM Payment
				GROUP BY Payment.PaymentTypeID
				HAVING COUNT(Payment.PaymentTypeID) 
					IN (SELECT TOP 1 COUNT(Payment.PaymentTypeID) AS 'Count'
					FROM Payment
					GROUP BY Payment.PaymentTypeID
					ORDER BY [Count] DESC)) HighestPayment
	ON PaymentType.PaymentTypeID = HighestPayment.PaymentTypeID


-- 8. What is the total avg mark for the students from Edmonton?
SELECT AVG(Registration.Mark) AS 'Average Mark'
FROM Registration
WHERE Registration.StudentID
	IN (SELECT Student.StudentID 
		FROM Student 
		WHERE Student.City = 'Edmonton')

-- 9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)
SELECT Registration.StudentID, AVG(Registration.Mark) AS 'Average Mark'
FROM Registration
WHERE Registration.StudentID
	IN (SELECT Student.StudentID 
		FROM Student 
		WHERE Student.City = 'Edmonton')
GROUP BY Registration.StudentID
