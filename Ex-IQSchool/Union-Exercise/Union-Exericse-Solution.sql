SELECT Staff.StaffID AS 'ID', Staff.FirstName + ' ' + Staff.LastName AS 'Event:Name'
FROM Staff
WHERE DATEPART(mm, Staff.DateHired) = '10'
UNION
SELECT Student.StudentID, Student. FirstName + ' ' + Student.LastName
FROM Student
WHERE DATEPART(mm, Student.Birthdate) = '10'
ORDER BY [ID] DESC