-- 1.Create a view of staff full names called staff_list.
CREATE VIEW staff_list AS
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name'
FROM Staff
GO

-- 2.Create a view of staff ID's, full names, positionID's and datehired called staff_confidential.
CREATE VIEW staff_confidential AS
SELECT Staff.StaffID, Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name', Staff.PositionID, Staff.DateHired
FROM Staff
GO

-- 3.Create a view of student ID's, full names, courseId's, course names, and grades called student_grades.
CREATE VIEW student_grades AS
SELECT Student.StudentID, Student.FirstName + ' ' + Student.LastName AS 'Student Name', Offering.CourseId, Course.CourseName, Registration.Mark
FROM Student
	LEFT JOIN Registration
	ON Student.StudentID = Registration.StudentID
	LEFT JOIN Offering
	ON Registration.OfferingCode = Offering.OfferingCode
	LEFT JOIN Course
	ON Offering.CourseId = Course.CourseId
GO

-- 4.Use the student_grades view to create a grade report for studentID 199899200 that shows the students ID, full name, course names and marks.
SELECT student_grades.StudentID, student_grades.[Student Name], student_grades.CourseName, student_grades.Mark
FROM student_grades
WHERE student_grades.StudentID = '199899200'
GO

-- 5.Select the same information using the student_grades view for studentID 199912010.
SELECT student_grades.StudentID, student_grades.[Student Name], student_grades.CourseName, student_grades.Mark
FROM student_grades
WHERE student_grades.StudentID = '199912010'
GO

-- 6.Using the student_grades view update the mark for studentID 199899200 in course dmit2015 to be 90 and change the coursename to be 'basket weaving 101'.
-- !!!This operation will fail, this operation will modify records in more than one table.!!!!
UPDATE student_grades
SET student_grades.Mark = 90, student_grades.CourseName = 'basket weaving 101'
WHERE student_grades.StudentID = '199899200' AND student_grades.CourseId = 'dmit2015'
GO

-- 7.Using the student_grades view, update the mark for studentID 199899200 in course dmit2015 to be 90.
UPDATE student_grades
SET student_grades.Mark = 90
WHERE student_grades.StudentID = '199899200' AND student_grades.CourseId = 'dmit2015'
GO

-- 8.Using the student_grades view, delete the same record from question 7.
-- !!!This operation will fail, this operation will delete records in more than one table.!!!!
DELETE student_grades
WHERE student_grades.StudentID = '199899200' AND student_grades.CourseId = 'dmit2015'
GO

-- 9.Retrieve the code for the student_grades view from the database.
SP_HELPTEXT student_grades
GO







