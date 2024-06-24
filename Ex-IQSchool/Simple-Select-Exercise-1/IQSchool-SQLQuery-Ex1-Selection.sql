/* Select all the information from the club table */
SELECT * FROM Club;

/* Select the FirstNames and LastNames of all the students */
SELECT Student.FirstName, Student.LastName FROM Student;

/* Select all the CourseId and CourseName of all the coureses. Use the column aliases of Course ID and Course Name */
SELECT Course.CourseId "Course ID", Course.CourseName "Course Name"
FROM Course;

/* Select all the course information for courseID 'DMIT1001' */
SELECT * FROM Course
WHERE Course.CourseId = 'DMIT1001';

/* Select the Staff names who have positionID of 3 */
SELECT Staff.FirstName "First Name", Staff.LastName "Last Name"
FROM Staff
WHERE Staff.PositionID = 3

/* Select the CourseNames whos CourseHours are less than 96 */
SELECT Course.CourseName
FROM Course
WHERE Course.CourseHours < 96

/* Select the studentID's, OfferingCode and mark where the Mark is between 70 and 80 */
SELECT Registration.StudentID, Registration.OfferingCode, Registration.Mark
FROM Registration
WHERE Registration.Mark >= 70 AND Registration.Mark <= 80
ORDER BY Registration.Mark ASC

/* Select the studentID's, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009 */
SELECT Registration.StudentID, Registration.OfferingCode, Registration.Mark
FROM Registration
WHERE (Registration.Mark >= 70 AND Registration.Mark <= 80) AND (Registration.OfferingCode = '1001' OR Registration.OfferingCode = '1009')
ORDER BY Registration.Mark ASC

/* Select the students first and last names who have last names starting with S */
SELECT Student.FirstName "First Name", Student.LastName "Last Name"
FROM Student
WHERE Student.LastName LIKE 'S%'

/* Select Coursenames whose CourseID  have a 1 as the fifth character */
SELECT Course.CourseName, Course.CourseId
FROM Course
WHERE Course.CourseId LIKE '____1%'

/* Select the CourseID's and Coursenames where the CourseName contains the word 'programming' */
SELECT Course.CourseId, Course.CourseName
FROM Course
WHERE Course.CourseName LIKE '%programming%'

/* Select all the ClubNames who start with N or C */
SELECT Club.ClubName
FROM Club
WHERE ClubName LIKE 'N%' OR ClubName LIKE 'C%'

/* Select Student Names, Street Address and City where the LastName is only 3 letters long */
SELECT Student.FirstName, Student.LastName, Student.StreetAddress, Student.City
FROM Student
WHERE Student.LastName LIKE '___'

/* Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5 */
SELECT Payment.StudentID, Payment.Amount, Payment.PaymentTypeID
FROM Payment
WHERE Payment.Amount < 500 OR Payment.PaymentTypeID = 5

