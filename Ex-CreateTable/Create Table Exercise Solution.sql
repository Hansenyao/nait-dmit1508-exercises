USE IQSchool
GO

Drop Table If Exists Activity
Drop Table If Exists Grade
Drop Table If Exists Club
Drop Table If Exists Course
Drop Table If Exists Student
Go

Create Table Student
(
	StudentId			int				Not Null
										Constraint PK_Student_StudentId
											Primary Key Clustered,
	StudentFirstName	varchar(40)		Not Null,
	StudentLastName		varchar(40)		Not Null,
	GenderCode			char(1)			Not Null,
	Address				varchar(30)		Null,
	Birthdate			datetime		Null,
	PostalCode			char(6)			Null,
	AvgMark				decimal(4,1)	Null,
	NoOfCourses			smallint		Null	
)

Create Table Course
(
	CourseId			char(8)			Not Null
										Constraint PK_Course_CourseId
											Primary Key Clustered,
	CourseName			varchar(40)		Not Null,
	Hours				smallint		Null,
	NoOfStudents		smallint		Null
)

Create Table Club
(
	ClubId				int				Not Null
										Constraint PK_Club_ClubId
											Primary Key Clustered,
	ClubName			varchar(50)		Not Null
)

Create Table Grade
(
	StudentId			int				Not Null
										Constraint FK_Grade_StudentId_To_Student_StudentId
											References Student(StudentId),
	CourseId			char(8)			Not Null
										Constraint FK_Grade_CourseId_To_Course_CourseId
											References Course(CourseId),
	Mark				smallint		Null,
	Constraint PK_Grade_StudentId_CourseId
		Primary Key Clustered (StudentId, CourseId)
)

Create Table Activity
(
	StudentId			int				Not Null
										Constraint FK_Activity_StudentId_To_Student_StudentId
											References Student(StudentId),
	ClubId				int				Not Null
										Constraint FK_Activity_ClubId_To_Club_ClubId
											References Club(ClubId),
	Constraint PK_Activity_StudentId_ClubId 
		Primary Key Clustered (StudentId, ClubId)
)
