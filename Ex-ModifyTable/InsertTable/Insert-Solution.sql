Use MemoriesForever
Go

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (1,	'Camera')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2,	'Lights')

INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (3, 'Stand')

-- This statement will fail, because ItemTypeID is primary key and has a record which value is 2.
INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (2,	'Backdrop')

-- This statement will fail, because ItemTypeID data type is int, however 89899985225 is over.
INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (89899985225, 'Outfit')

-- This statment will fail, because value 4A is not int
INSERT INTO ItemType (ItemTypeID, ItemTypeDescription)
VALUES (4A, 'Other')
GO


INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Canon G2', 25, 1)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('100W tungston', 18, 2)

-- This statement will fail, because value 4 as ItemTypeID doesn't exist in table ItemTypeID
INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Super Flash', 25, 4)

INSERT INTO Item (ItemID, ItemDescription, PricePerDay, ItemTypeID)
VALUES (DEFAULT, 'Canon EOS20D',	30,	1)

-- This statement will fail, because ItemID is an identity column
INSERT INTO Item (ItemID, ItemDescription, PricePerDay, ItemTypeID)
VALUES (5, 'HP 630', 25, 1)

INSERT INTO Item (ItemDescription, PricePerDay, ItemTypeID)
VALUES ('Light Holdomatic', 22, 3)
GO


INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Videographer')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (2, 'Photographer')

-- This statement will fail, because StaffTypeID is primary key and value 1 exist.
INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (1, 'Mixer')

-- This statement will fail, because StaffTypeID is not an identify column
INSERT INTO StaffType (StaffTypeDescription)
VALUES ('Sales')

INSERT INTO StaffType (StaffTypeID, StaffTypeDescription)
VALUES (3, 'Sales')
GO

-- This statement will fail. Check constraint on the table says that the hire date must be greater than or equal to todays date
INSERT INTO Staff 
	(StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES 
	(1, 'Joe', 'Cool', '5551223212', 23, 'Jan 1 2023', 1)

INSERT INTO Staff 
	(StaffID, StaffFirstName, StaffLastName, Phone, Wage, HireDate, StaffTypeID)
VALUES 
	(1,	'Joe', 'Cool', '5551223212', 23, 'Aug 2 2024', 1) ,
	(2,	'Sue',	'Photo', '5556676612', 15, 'Aug 3 2024', 3),
	(3,	'Jason', 'Pic',	'3332342123', 23, 'Aug 4 2024', 2)