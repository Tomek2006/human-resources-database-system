--/*
USE MASTER;
GO
Alter database HumanResources set single_user with rollback immediate;  
GO
DROP DATABASE HumanResources;
GO
--*/

CREATE DATABASE HumanResources;
GO

USE HumanResources
GO

CREATE TABLE dbo.Departments(
	DepartmentID INT IDENTITY CONSTRAINT PK_Department PRIMARY KEY,
	DepartmentName NVARCHAR(150) NOT NULL,
	StreetAddress NVARCHAR(60) NOT NULL,
	City NVARCHAR(60) NOT NULL,
	Province NVARCHAR(60) NOT NULL,
	PostalCode CHAR(6) NOT NULL,
	Country NVARCHAR(60) NOT NULL,
	MaxWorkstations INT NOT NULL 
	CONSTRAINT DF_Departments_MaxWorkstations DEFAULT (10),
	CONSTRAINT CK_Departments_MaxWorkstations_NegativeCheck CHECK(MaxWorkstations >= 0)
	-- 	CurrentEmployeeWorkstations INT NOT NULL -- Best not to Store, as this could be calculated from Employee/Dept data

);
CREATE UNIQUE INDEX UQ_Departments_DepartmentName ON dbo.Departments(DepartmentName);


CREATE TABLE dbo.PhoneTypes(
	PhoneTypeID INT IDENTITY CONSTRAINT PK_PhoneTypes PRIMARY KEY,
	PhoneType NVARCHAR(60) NOT NULL
);
  
CREATE TABLE dbo.Employees(
	EmployeeID INT IDENTITY CONSTRAINT PK_Employee PRIMARY KEY,
	FirstName NVARCHAR(60) NOT NULL,
	MiddleName NVARCHAR(60) NULL,
	LastName NVARCHAR(60) NOT NULL,
	DateofBirth DATE NOT NULL,
	SIN char(9) NOT NULL,
	DefaultDepartmentID  INT NOT NULL CONSTRAINT FK_Employees_Departments_Default REFERENCES dbo.Departments ( DepartmentID ),
    CurrentDepartmentID  INT NOT NULL CONSTRAINT FK_Employees_Departments_Current REFERENCES dbo.Departments ( DepartmentID ),
	ReportsToEmployeeID INT NULL CONSTRAINT FK_Employees_Employees REFERENCES dbo.Employees ( EmployeeID ),
	StreetAddress NVARCHAR(60) NULL,
	City NVARCHAR(60) NULL,
	Province NVARCHAR(60) NULL,
	Country NVARCHAR(60) NOT NULL,
	PostalCode CHAR(6) NULL,
	StartDate  DATE NOT NULL,
	BaseSalary decimal(16, 2) NOT NULL
	CONSTRAINT DF_Employees_BaseSalary DEFAULT (0),
	CONSTRAINT UQ_Employees_SIN UNIQUE (SIN),
	CONSTRAINT CK_Employees_DateofBirth CHECK (DateofBirth <= CONVERT(date, GETDATE())),
	CONSTRAINT CK_Employees_StartDate CHECK (StartDate <= CONVERT(date, GETDATE()))
  --	BonusPercent decimal(3, 2) NOT NULL -- Best not to Store, as Business decided that this would always be 3% for Employees and 5% for Managers, so 
  --                                           could always be calculated from Employee data & displayed when asked for 
);
CREATE INDEX IX_Employees_City_Province ON dbo.Employees (City, Province);
CREATE INDEX IX_Employees_Province ON dbo.Employees (Province);



CREATE TABLE dbo.EmployeePhoneNumbers(
	EmployeePhoneNumberID INT IDENTITY CONSTRAINT PK_EmployeePhoneNumbers PRIMARY KEY,
	EmployeeID INT NOT NULL CONSTRAINT FK_EmployeePhoneNumbers_Employees REFERENCES dbo.Employees ( EmployeeID ),
	PhoneTypeID INT NOT NULL CONSTRAINT FK_EmployeePhoneNumbers_PhoneTypes REFERENCES dbo.PhoneTypes (PhoneTypeID ),
	PhoneNumber NVARCHAR(14) NULL
); 
CREATE INDEX IX_EMPN_PhoneType_Employee ON dbo.EmployeePhoneNumbers (PhoneTypeID, EmployeeID) INCLUDE (PhoneNumber);
CREATE INDEX IX_EMPN_Employee_PhoneType ON dbo.EmployeePhoneNumbers (EmployeeID, PhoneTypeID) INCLUDE (PhoneNumber);




CREATE TABLE dbo.BenefitTypes(
	BenefitTypeID INT IDENTITY CONSTRAINT PK_BenefitType PRIMARY KEY, 
	BenefitType NVARCHAR(100) NOT NULL,
	BenefitCompanyName NVARCHAR(100) NOT NULL,
    PolicyNumber INT NULL
);
CREATE UNIQUE INDEX UQ_BenefitTypes_PolicyNumber ON dbo.BenefitTypes(PolicyNumber) WHERE PolicyNumber IS NOT NULL;




CREATE TABLE dbo.EmployeeBenefits(
	EmployeeBenefitID INT IDENTITY CONSTRAINT PK_EmployeeBenefits PRIMARY KEY, 
	EmployeeId INT NOT NULL CONSTRAINT FK_EmployeeBenefits_Employees REFERENCES dbo.Employees ( EmployeeID ),
	BenefitTypeID INT NOT NULL CONSTRAINT FK_EmployeeBenefits_BenefitTypes REFERENCES dbo.BenefitTypes ( BenefitTypeID  ),
    StartDate DATE NULL,
	CONSTRAINT CK_EmployeeBenefits_StartDate_NotFuture CHECK (StartDate IS NULL OR StartDate <= CONVERT(date, GETDATE()))
);
CREATE INDEX IX_EB_BenefitType_Employee ON dbo.EmployeeBenefits (BenefitTypeID, EmployeeID) INCLUDE (StartDate);
CREATE INDEX IX_EB_Employee_BenefitType ON dbo.EmployeeBenefits (EmployeeID, BenefitTypeID) INCLUDE (StartDate);





CREATE TABLE dbo.Providers (
	ProviderID INT IDENTITY CONSTRAINT PK_Providers PRIMARY KEY, 
	ProviderName  NVARCHAR(60) NOT NULL,
	ProviderAddress NVARCHAR(60) NOT NULL,
	ProviderCity NVARCHAR(60) NOT NULL
);

CREATE TABLE dbo.Claims(
	ClaimsID INT IDENTITY CONSTRAINT PK_Claims PRIMARY KEY, 
	ProviderID INT NOT NULL CONSTRAINT FK_Claims_Providers REFERENCES dbo.Providers ( ProviderID ),
	ClaimAmount decimal(16, 2) NOT NULL
	CONSTRAINT DF_Claims_ClaimAmount DEFAULT (0),
	ServiceDate DATE NOT NULL
	CONSTRAINT DF_Claims_ServiceDate DEFAULT (CONVERT(date, GETDATE())),
	EmployeeBenefitID INT NULL CONSTRAINT FK_Claims_EmployeeBenefits REFERENCES dbo.EmployeeBenefits ( EmployeeBenefitID ),
	ClaimDate DATE NOT NULL
	CONSTRAINT DF_Claims_ClaimDate DEFAULT (CONVERT(date, GETDATE())),
	CONSTRAINT CK_Claims_ServiceDate_NotFuture CHECK (ServiceDate <= CONVERT(date, GETDATE())),
    CONSTRAINT CK_Claims_ClaimDate_NotFuture CHECK (ClaimDate <= CONVERT(date, GETDATE()))

);
CREATE INDEX IX_Claims_Provider_EmployeeBenefit ON dbo.Claims (ProviderID, EmployeeBenefitID) INCLUDE (ClaimAmount, ServiceDate, ClaimDate);
CREATE INDEX IX_Claims_EmployeeBenefit_Provider ON dbo.Claims (EmployeeBenefitID, ProviderID) INCLUDE (ClaimAmount, ServiceDate, ClaimDate);
GO
