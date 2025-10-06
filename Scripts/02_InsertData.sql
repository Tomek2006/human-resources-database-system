USE HumanResources;
GO

-- ========================
--  Departments
-- ========================
INSERT INTO dbo.Departments
(DepartmentName, StreetAddress, City, Province, PostalCode, Country, MaxWorkstations)
VALUES
('Human Resources', '100 Wellington St', 'London', 'Ontario', 'N6A1A1', 'Canada', 10),
('Information Technology', '200 Dundas St', 'London', 'Ontario', 'N6B2R1', 'Canada', 20),
('Finance', '300 Oxford St', 'London', 'Ontario', 'N6H1T1', 'Canada', 15);
GO


-- ========================
--  Phone Types
-- ========================
INSERT INTO dbo.PhoneTypes (PhoneType)
VALUES ('Mobile'), ('Home'), ('Work');
GO


-- ========================
--  Employees
-- ========================
INSERT INTO dbo.Employees
(FirstName, MiddleName, LastName, DateOfBirth, SIN, DefaultDepartmentID, CurrentDepartmentID,
 ReportsToEmployeeID, StreetAddress, City, Province, Country, PostalCode, StartDate, BaseSalary)
VALUES
('Alex', NULL, 'Kim', '1990-05-12', '123456789', 2, 2, NULL, '15 Queen St', 'London', 'Ontario', 'Canada', 'N6C3K1', '2020-01-15', 60000),
('Jordan', 'M', 'Lee', '1995-09-03', '987654321', 2, 2, 1, '22 King St', 'London', 'Ontario', 'Canada', 'N6B3N2', '2021-06-10', 52000),
('Priya', NULL, 'Singh', '1988-02-25', '111222333', 1, 1, NULL, '10 Colborne St', 'London', 'Ontario', 'Canada', 'N6A2V3', '2019-03-22', 65000),
('Lucas', NULL, 'Brown', '1992-11-15', '444555666', 3, 3, NULL, '55 Richmond St', 'London', 'Ontario', 'Canada', 'N6C2Y9', '2022-07-01', 58000);
GO


-- ========================
--  Employee Phone Numbers
-- ========================
INSERT INTO dbo.EmployeePhoneNumbers (EmployeeID, PhoneTypeID, PhoneNumber)
VALUES
(1, 1, '(519)555-1111'),
(1, 3, '(519)555-2222'),
(2, 1, '(519)555-3333'),
(3, 2, '(519)555-4444'),
(4, 1, '(519)555-5555');
GO


-- ========================
--  Benefit Types
-- ========================
INSERT INTO dbo.BenefitTypes (BenefitType, BenefitCompanyName, PolicyNumber)
VALUES
('Health', 'SunLife', 1001),
('Dental', 'Manulife', 1002),
('Vision', 'GreatWest', 1003);
GO


-- ========================
--  Employee Benefits
-- ========================
INSERT INTO dbo.EmployeeBenefits (EmployeeId, BenefitTypeID, StartDate)
VALUES
(1, 1, '2020-02-01'),
(1, 2, '2020-02-01'),
(2, 1, '2021-07-01'),
(3, 1, '2019-04-01'),
(3, 3, '2019-04-01'),
(4, 2, '2022-07-15');
GO


-- ========================
--  Providers
-- ========================
INSERT INTO dbo.Providers (ProviderName, ProviderAddress, ProviderCity)
VALUES
('London Eye Clinic', '101 Vision Rd', 'London'),
('Ontario Dental Care', '202 Smile St', 'London'),
('SunLife Insurance', '303 Benefit Ave', 'Toronto');
GO


-- ========================
--  Claims
-- ========================
INSERT INTO dbo.Claims (ProviderID, ClaimAmount, ServiceDate, EmployeeBenefitID, ClaimDate)
VALUES
(1, 180.00, '2024-03-01', 5, '2024-03-05'),
(2, 250.00, '2024-02-15', 2, '2024-02-20'),
(3, 300.00, '2024-04-01', 1, '2024-04-02');
GO
