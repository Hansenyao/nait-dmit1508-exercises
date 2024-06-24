use IQSchool
Go

--1. Select	student full names and the course ID's they are registered in.
Select	distinct Student.FirstName + ' ' + Student.LastName "Student Name", Offering.CourseID 
From	Student 
		Inner Join Registration
			On Student.StudentID = Registration.StudentID
		Inner Join Offering
			On Registration.OfferingCode = Offering.OfferingCode

--2. Select	the Staff full names and the course ID's they teach
Select	distinct Staff.FirstName + ' ' + Staff.LastName "Student Name", Offering.CourseID 
From	Staff
			Inner Join Offering
				On Staff.StaffID = Offering.StaffID

--3. Select	the Club ID's and the student full names that are in them
Select	ClubID, FirstName + ' ' + LastName "Student Name" 
From	Activity
			Inner Join Student
				On Student.StudentID = Activity.StudentID

--4. Select	the student full name, course ID's and marks for StudentID 199899200.
Select	Student.FirstName + ' ' + Student.LastName "Student Name", Offering.CourseID, Registration.Mark
From	Student 
			Inner Join Registration
				On Student.StudentID = Registration.StudentID
			Inner Join Offering
				On Registration.OfferingCode = Offering.OfferingCode
Where	Student.StudentID = 199899200

--5. Select	the student full name, course names and marks for StudentID 199899200.
Select	Student.FirstName + ' ' + Student.LastName "Student Name", Course.CourseName, Registration.Mark
From	Student 
			Inner Join Registration
				On Student.StudentID = Registration.StudentID
			Inner Join Offering
				On Registration.OfferingCode = Offering.OfferingCode
			Inner Join Course
				On Course.CourseId= Offering.CourseId
Where	Student.StudentID = 199899200

--6. Select	the courseid, coursenames, and the semestercodes they have been taught in
Select	distinct  Course.CourseId, Course.CourseName, Offering.SemesterCode
From	Course 
			Inner Join Offering On Course.CourseId = Offering.CourseID
order by Course.CourseID

--7. What staff full names have taught 'IT System Administration'?
Select	distinct Staff.FirstName + ' ' + Staff.LastName "Staff Name"
From	Staff
			Inner Join Offering
				On Staff.StaffID = Offering.StaffID
			Inner Join Course
				On Course.CourseId = Offering.CourseId
Where	Course.CourseName = 'IT System Administration'

--8. What is the course list for student ID 199912010 in semester code A100. Select the students full name and the coursenames
Select	Student.FirstName + ' ' + Student.LastName "Student Name", Course.CourseName
From	Student 
			Inner Join Registration
				On Student.StudentID = Registration.StudentID
			Inner Join Offering
				On Registration.OfferingCode = Offering.OfferingCode
			Inner Join Course
				On Course.CourseId = Offering.CourseId 
Where	Student.StudentID = 199912010 And 
		SemesterCode = 'A100'

--9. What are the student names and course ID's that have marks > 80?
Select	Student.FirstName + ' ' + Student.LastName "Student Name", Offering.CourseID
From	Student
			Inner Join Registration
				On Student.StudentID = Registration.StudentID
			Inner Join Offering
				On Offering.OfferingCode = Registration.OfferingCode
Where	Mark > 80
