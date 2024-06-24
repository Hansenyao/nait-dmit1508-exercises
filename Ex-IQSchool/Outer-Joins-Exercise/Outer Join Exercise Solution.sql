Use IQSchool
Go

--1. Select All position descriptions and the staff ID's that are in those positions
Select	Position.PositionDescription, Staff.StaffID 
From	Position
			Left Outer Join Staff
				On Position.PositionID = Staff.PositionID

--2. Select the Position Description and he count of how many staff are in those positions. Returnt the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
Select	Position.PositionDescription, Count(Staff.StaffID) "Count" 
From	Position 
			Left Outer Join Staff
				On Position.PositionID = Staff.PositionID 
Group By Position.Positionid, Position.PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
Select	Student.FirstName  + ' ' + Student.LastName 'Student Name' , AVG(Registration.Mark)"Average" 
From	Student 
			Left Outer Join Registration
				On Student.StudentID  = Registration.StudentID
Group By Student.StudentID, Student.FirstName, Student.LastName

--4. Select the highest and lowest mark for each student. 
Select	Student.FirstName  + ' ' + Student.LastName "Student Name", 
		Max(Registration.Mark) "Highest", Min(Registration.Mark) "Lowest" 
From	Student 
			Left Outer Join Registration
				On Student.StudentID = Registration.StudentID
Group By Student.StudentID, Student.FirstName, Student.LastName

--5. How many students are in each club? Display the club name and count
Select	Club.ClubName, Count(Activity.ClubId) "Student Count" 
From	Club 
			Left Outer Join Activity
				On Club.ClubId = Activity.ClubId
Group By Club.ClubId, Club.ClubName

