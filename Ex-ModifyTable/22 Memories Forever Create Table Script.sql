Use MemoriesForever
Go

Drop Table If Exists ProjectItem
Drop Table If Exists Project
Drop Table If Exists Item
Drop Table If Exists Staff
Drop Table If Exists Client
Drop Table If Exists ProjectType
Drop Table If Exists ItemType
Drop Table If Exists StaffType
Go

Create Table StaffType
( 
	StaffTypeID				int				Not Null
											Constraint PK_StaffType_StaffTypeID
												Primary Key Clustered,
	StaffTypeDescription	varchar(50)		Not Null
)

Create Table ItemType
(
	ItemTypeID				int				Not Null
											Constraint PK_ItemType_ItemTypeID
												Primary Key Clustered,
	ItemTypeDescription		varchar(50)		Not Null
)

Create Table ProjectType
(
	ProjectTypeCode			int				Not Null
											Constraint PK_ProjectType_ProjectTypeCode
												Primary Key Clustered,
	ProjectTypeDescription	varchar(50)		Not Null
)

Create Table Client
(
	ClientID				int identity(1,1)	Not Null
												Constraint PK_Client_ClientID
													Primary Key Clustered,
	Organization			varchar(50)			Not Null,
	ClientFirstName			varchar(50)			Not Null,
	ClientLastName			varchar(50)			Not Null,
	Phone					varchar(10)			Not Null,
	Email					varchar(50)			Not Null,
	Address					varchar(100)		Not Null,
	City					varchar(50)			Not Null,
	Province				char(2)				Not Null,
	PC						char(6)				Not Null
)

Create Table Staff
(
	StaffID					int					Not Null Constraint PK_Staff_StaffID
													Primary Key Clustered,
	StaffFirstName			varchar(50)			Not Null,
	StaffLastName			varchar(50)			Not Null,
	Phone					varchar(10)			Not Null,
	Wage					smallmoney			Not Null 
												Constraint DF_Staff_Wage_950
													Default 9.5
												Constraint CK_Staff_Wage_Gr_Zero
													Check(Wage > 0),
	HireDate				datetime			Not Null
												Constraint CK_Staff_HireDate_GrEq_GetDate
													Check(HireDate >= GetDate()),
	StaffTypeID				int					Not Null
												Constraint FK_Staff_StaffTypeID_To_StaffType_StaffTypeID
													References StaffType(StaffTypeID)
)

Create Table Item
(
	ItemID					int identity (1,1)	Not Null
												Constraint PK_Item_ItemID
													Primary Key Clustered,
	ItemDescription			varchar(100)		Not Null,
	PricePerDay				money				Not Null,
	ItemTypeID				int					Not Null 
												Constraint FK_Item_ItemTypeID_To_ItemType_ItemTypeID
													References ItemType(ItemTypeID)
)

Create Table Project 
(
	ProjectId				int identity (1,1)	Not Null
												Constraint PK_Project_ProjectId
													Primary Key Clustered,
	ProjectDescription		varchar(100)		Not Null,
	InDate					datetime			Not Null,
	OutDate					datetime			Not Null,
	Estimate				money				Not Null
												Constraint DF_Project_Estimate
													Default 0,
	ProjectTypeCode			int					Not Null
												Constraint FK_Project_ProjectTypeCode_To_ProjectType_ProjectTypeCode
													References ProjectType(ProjectTypeCode),
	ClientID				int					Not Null
												Constraint FK_Project_ClientID_To_Client_ClientID
													References Client(ClientID),
	SubTotal				money				Not Null,
	GST						money				Not Null,
	Total					money				Not Null,
	StaffID					int					Not Null
												Constraint FK_Project_StaffID_To_Staff_StaffID
													References Staff(StaffID),
	Constraint CK_Project_InDate_GrEq_OutDate
		Check (InDate >= OutDate),
	Constraint CK_Project_Total_Gr_Subtotal
		Check (Total > Subtotal)
)

Create Table ProjectItem
(
	ItemID					int					Not Null
												Constraint FK_ProjectItem_ItemID_To_Item_ItemID
													References Item(ItemID),
	ProjectID				int					Not Null
												Constraint FK_ProjectItem_ProjectID_To_Project_ProjectID
													References Project(ProjectID),
	CheckInNotes			varchar(200)		Not Null,
	CheckOutNotes			varchar(200)		Not Null,
	DateOut					datetime			Not Null,
	DateIn					datetime			Not Null,
	ExtPrice				money				Not Null,
	Historicalprice			money				Not Null,
	Days					smallint			Not Null
												Constraint CK_ProjectItem_Days_Gr_Zero
													Check(Days > 0),
	Constraint PK_ProjectItem_ItemID_ProjectID
		Primary Key Clustered (ItemID, ProjectID),
	Constraint CK_ProjectItem_DateIn_GrEq_DateOut
		Check (DateIn >= DateOut)
)
