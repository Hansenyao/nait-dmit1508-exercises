SELECT Staff.StaffID AS 'ID', CONCAT('Staff Hired:', Staff.FirstName + ' ' + Staff.LastName) AS 'Event:Name'
FROM Staff
WHERE DATEPART(mm, Staff.DateHired) = '10'
	UNION
SELECT Student.StudentID, CONCAT('Student Born:', Student. FirstName + ' ' + Student.LastName) AS 'Event:Name'
FROM Student
WHERE DATEPART(mm, Student.Birthdate) = '10'
ORDER BY [ID] DESC