/* 1. How many staff are there in each position? Select the number and Position Description. */
SELECT Position.PositionDescription, Count(*) AS 'Number of Staff'
FROM Staff
	INNER JOIN Position
	ON Staff.PositionID = Position.PositionID
GROUP BY Position.PositionID, Position.PositionDescription

/* 2. Select the average mark for each course. Display the CourseName and the average mark. */
SELECT Course.CourseName, AVG(Registration.Mark) AS 'Average Mark'
FROM Course
	INNER JOIN Offering
	ON Course.CourseId = Offering.CourseId
	INNER JOIN Registration
	ON Offering.OfferingCode = Registration.OfferingCode
GROUP BY Course.CourseName

/* 3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count. */
SELECT PaymentType.PaymentTypeDescription, SUM(Payment.Amount) AS 'SUM'
FROM PaymentType
	INNER JOIN Payment
	ON PaymentType.PaymentTypeID = Payment.PaymentTypeID
GROUP BY  PaymentType.PaymentTypeDescription

/* 4. Select the average Mark for each student. Display the Student Name and their average mark */
SELECT Student.FirstName, Student.LastName, AVG(Registration.Mark) AS 'Average Mark'
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
GROUP BY Student.FirstName, Student.LastName

/* 5. Select the same data as question 4 but only show the student names and averages that are > 80. */
SELECT Student.FirstName, Student.LastName, AVG(Registration.Mark) AS 'Average Mark'
FROM Student
	INNER JOIN Registration
	ON Student.StudentID = Registration.StudentID
GROUP BY Student.FirstName, Student.LastName
HAVING AVG(Registration.Mark) >  80

/* 6.what is the highest, lowest and average payment amount for each payment type Description?  */
SELECT PaymentType.PaymentTypeDescription, MAX(Payment.Amount) AS 'Max', MIN(Payment.Amount) AS 'Min', AVG(Payment.Amount) AS 'Average'
FROM Payment
	INNER JOIN PaymentType
	ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeDescription

/* 7. How many students are there in each club? Show the clubName and the count. */
SELECT Club.ClubName, COUNT(*) AS 'Students Number'
FROM Club
	INNER JOIN Activity
	ON Club.ClubId = Activity.ClubId
	INNER JOIN Student
	ON Activity.StudentID = Student.StudentID
GROUP BY Club.ClubName

/* 8. Which clubs have 3 or more students in them? Display the Club Names. */
SELECT Club.ClubName, COUNT(*) AS 'Students Number'
FROM Club
	INNER JOIN Activity
	ON Club.ClubId = Activity.ClubId
	INNER JOIN Student
	ON Activity.StudentID = Student.StudentID
GROUP BY Club.ClubName
HAVING COUNT(*) >= 3









