/* Select the average mark from all the marks in the registration table */
SELECT AVG(Mark) "Average Mark" 
FROM Registration;

/* Select how many students are there in the student table */
SELECT COUNT(Student.StudentID) "Student Count"
FROM Student;

/* Select the average payment amount for payment type 5 */
SELECT AVG(Amount) "Average Amount" 
FROM Payment 
WHERE PaymentTypeID = 5;

/* Select the highest payment amount */
SELECT MAX(Amount) "Max Amount" 
FROM Payment;

/* Select the lowest payment amount */
SELECT MIN(Amount) "Min Amount"
FROM Payment;

/* Select the lowest and the highest payment amount */
SELECT MIN(Amount) "Min Amount", MAX(Amount) "Max Amount" 
FROM Payment;

/* Select the total of all the payments that have been made */
SELECT SUM(Amount) "Sum of Payments"
FROM Payment;

/* How many different payment types does the school accept? */
SELECT COUNT(*) "Pay Type Count"
FROM PaymentType;

/* How many students are in club 'CSS'? */
SELECT COUNT(Activity.StudentID) "CSS Club Count" 
FROM Activity 
WHERE ClubId LIKE 'CSS';


