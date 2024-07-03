-- 1.Delete the Staff with StaffID 8
-- 0 rows affected. Deleting records that do not exist does not cause an error
DELETE FROM Staff
WHERE Staff.StaffID = 8

-- 2.Delete StaffTypeId 1
-- cannot Delete	the stafftypeId 1 because that value is in the foreign key field for child records 
DELETE FROM StaffType
WHERE StaffType.StaffTypeID = 1

-- 3.Delete all the staff whose wage is less $21.66
DELETE FROM Staff
WHERE Staff.Wage < 21.66

-- 4.Try and Delete StaffTypeID 1 again. Why did it work this time?
-- Staff with StaffTypeID of 1 has been deleted
DELETE FROM StaffType
WHERE StaffType.StaffTypeID = 1

-- 5.Delete ItemID 5
DELETE FROM Item
WHERE Item.ItemID = 5
