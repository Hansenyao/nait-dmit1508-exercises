-- This statement will faild
-- Changing the Primary key value causes a related recorded in Item to lose its parent record in ItemType. 
-- Updating the primary key value is not recomended.
UPDATE ItemType 
SET ItemType.ItemTypeID = 5
WHERE ItemType.ItemTypeID = 1
GO

UPDATE ItemType 
SET ItemType.ItemTypeDescription = 'Bright Lights'
WHERE ItemType.ItemTypeID = 2
GO

UPDATE Item
SET Item.PricePerDay = 30, Item.ItemDescription = 'Canon G3'
WHERE Item.ItemID  = 1

-- This statement will fail
-- There is no ItemTypeId 5. Foreign Key values must have a matching value in the parent table.
UPDATE Item
SET Item.ItemTypeID = 5
WHERE Item.ItemID  = 4

UPDATE Item
SET Item.PricePerDay = 30
WHERE Item.ItemID  = 4
GO

UPDATE Staff
SET Staff.Wage = 19
WHERE Staff.StaffID = 1

UPDATE Staff
SET Staff.StaffLastName='Pic', Staff.Wage = 23
WHERE Staff.StaffID = 2

-- 0 rows will be updated, because no any record has StaffID is 12.
UPDATE Staff
SET Staff.Wage = 80
WHERE Staff.StaffID = 12


