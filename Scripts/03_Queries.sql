/*
------------------------------------------------------------
 Project: Human Resources Database System
 File:    03_Queries.sql
 Author:  Tomek Marek
 Date:    2025-10-06
 Purpose: SQL practice queries demonstrating key concepts
------------------------------------------------------------
*/

USE HumanResources;
GO

-- Q1: Show all employees with first name, last name, and city.
SELECT 
    FirstName AS [First Name],
    LastName AS [Last Name],
    City
FROM dbo.Employees
ORDER BY FirstName;

-- Q2: Show employees earning above 55,000.
SELECT 
    *
FROM dbo.Employees
WHERE BaseSalary > 55000
ORDER BY BaseSalary DESC;

-- Q3: Show employees hired after 2020.
SELECT 
    *
FROM dbo.Employees
WHERE StartDate > '2020-12-31';

-- Q4: Show each employee and their department name.
SELECT 
    e.FirstName + ' ' + e.LastName AS [Full Name],
    d.DepartmentName
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID;

-- Q5: Show each employee’s phone numbers and phone types.
SELECT 
    e.FirstName,
    e.LastName,
    epn.PhoneNumber,
    pt.PhoneType
FROM dbo.Employees e
JOIN dbo.EmployeePhoneNumbers epn ON e.EmployeeID = epn.EmployeeID
JOIN dbo.PhoneTypes pt ON pt.PhoneTypeID = epn.PhoneTypeID;

-- Q6: Show employees with their benefit types and company names.
SELECT
    e.FirstName,
    e.LastName,
    bt.BenefitType,
    bt.BenefitCompanyName
FROM dbo.Employees e
JOIN dbo.EmployeeBenefits eb ON e.EmployeeID = eb.EmployeeId
JOIN dbo.BenefitTypes bt ON eb.BenefitTypeID = bt.BenefitTypeID;

-- Q7: Count how many employees are in each department.
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;

-- Q8: Show the average base salary per department.
SELECT
    d.DepartmentName,
    AVG(e.BaseSalary) AS [Average Salary]
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY [Average Salary] DESC;

-- Q9: Show which benefit type has the most enrolled employees.
SELECT TOP 1 WITH TIES
    bt.BenefitType,
    COUNT(eb.EmployeeID) AS EnrolledCount
FROM dbo.EmployeeBenefits eb
JOIN dbo.BenefitTypes bt ON eb.BenefitTypeID = bt.BenefitTypeID
GROUP BY bt.BenefitType
ORDER BY EnrolledCount DESC;

-- Q10: Show the top 3 highest-paid employees with their department name.
SELECT TOP 3
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.BaseSalary
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID
ORDER BY e.BaseSalary DESC;

-- Q11: List all employees ordered by last name (A–Z) and salary descending.
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM dbo.Employees e
ORDER BY e.LastName ASC, e.BaseSalary DESC;

-- Q12: Show all claims with ClaimAmount > 200 including provider, employee name, and benefit type.
SELECT 
    p.ProviderName,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    bt.BenefitType,
    c.ClaimAmount,
    c.ServiceDate,
    c.ClaimDate
FROM dbo.Claims c
JOIN dbo.Providers p ON c.ProviderID = p.ProviderID
JOIN dbo.EmployeeBenefits eb ON c.EmployeeBenefitID = eb.EmployeeBenefitID
JOIN dbo.Employees e ON eb.EmployeeID = e.EmployeeID
JOIN dbo.BenefitTypes bt ON eb.BenefitTypeID = bt.BenefitTypeID
WHERE c.ClaimAmount > 200
ORDER BY c.ClaimAmount DESC;

-- Q13: Show employees whose salary is above the company average.
SELECT 
    e.FirstName,
    e.LastName,
    e.BaseSalary
FROM dbo.Employees e
WHERE e.BaseSalary > (SELECT AVG(BaseSalary) FROM dbo.Employees)
ORDER BY e.BaseSalary DESC;

-- Q14: Show departments that have more than one employee.
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
HAVING COUNT(e.EmployeeID) > 1
ORDER BY EmployeeCount DESC;

-- Q15: List each provider and the total claim amount they have processed.
SELECT 
    p.ProviderName,
    SUM(c.ClaimAmount) AS TotalClaimAmount
FROM dbo.Claims c
JOIN dbo.Providers p ON c.ProviderID = p.ProviderID
GROUP BY p.ProviderName
ORDER BY TotalClaimAmount DESC;

-- Q16: Find the youngest employee and their department.
SELECT TOP 1
    e.FirstName,
    e.LastName,
    d.DepartmentName,
    e.DateOfBirth
FROM dbo.Employees e
JOIN dbo.Departments d ON e.CurrentDepartmentID = d.DepartmentID
ORDER BY e.DateOfBirth DESC;
