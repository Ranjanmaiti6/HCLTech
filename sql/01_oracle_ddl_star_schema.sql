-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Candidate Name: Ranjan Maiti | Roll No: 2500321540146
-- Script: 01_oracle_ddl_star_schema.sql
-- Description: Enterprise Oracle SQL DDL script creating Star Schema tables,
--              Primary/Foreign Keys, Check Constraints, Sequences, and Indexes.
-- =============================================================================

-- Drop tables in reverse dependency order to avoid constraint violations
DROP TABLE FACT_ATTRITION CASCADE CONSTRAINTS;
DROP TABLE DIM_EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE DIM_EDUCATION CASCADE CONSTRAINTS;
DROP TABLE DIM_JOB_ROLE CASCADE CONSTRAINTS;
DROP TABLE DIM_DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE STG_EMPLOYEE_ATTRITION CASCADE CONSTRAINTS;

-- -----------------------------------------------------------------------------
-- 1. STAGING TABLE (For bulk ingestion from CSV)
-- -----------------------------------------------------------------------------
CREATE TABLE STG_EMPLOYEE_ATTRITION (
    Age                      NUMBER(3),
    Attrition                VARCHAR2(10),
    BusinessTravel           VARCHAR2(50),
    DailyRate                NUMBER(6),
    Department               VARCHAR2(100),
    DistanceFromHome         NUMBER(4),
    Education                NUMBER(2),
    EducationField           VARCHAR2(100),
    EmployeeCount            NUMBER(2),
    EmployeeNumber           NUMBER(10),
    EnvironmentSatisfaction  NUMBER(2),
    Gender                   VARCHAR2(20),
    HourlyRate               NUMBER(4),
    JobInvolvement           NUMBER(2),
    JobLevel                 NUMBER(2),
    JobRole                  VARCHAR2(100),
    JobSatisfaction          NUMBER(2),
    MaritalStatus            VARCHAR2(30),
    MonthlyIncome            NUMBER(10),
    MonthlyRate              NUMBER(10),
    NumCompaniesWorked       NUMBER(3),
    Over18                   VARCHAR2(5),
    OverTime                 VARCHAR2(10),
    PercentSalaryHike        NUMBER(4),
    PerformanceRating        NUMBER(2),
    RelationshipSatisfaction NUMBER(2),
    StandardHours            NUMBER(4),
    StockOptionLevel         NUMBER(2),
    TotalWorkingYears        NUMBER(3),
    TrainingTimesLastYear    NUMBER(3),
    WorkLifeBalance          NUMBER(2),
    YearsAtCompany           NUMBER(3),
    YearsInCurrentRole       NUMBER(3),
    YearsSinceLastPromotion  NUMBER(3),
    YearsWithCurrManager     NUMBER(3)
);

-- -----------------------------------------------------------------------------
-- 2. DIMENSION: DIM_DEPARTMENT
-- -----------------------------------------------------------------------------
CREATE TABLE DIM_DEPARTMENT (
    DepartmentID   NUMBER(5) PRIMARY KEY,
    DepartmentName VARCHAR2(100) NOT NULL UNIQUE
);

-- -----------------------------------------------------------------------------
-- 3. DIMENSION: DIM_JOB_ROLE
-- -----------------------------------------------------------------------------
CREATE TABLE DIM_JOB_ROLE (
    JobRoleID      NUMBER(5) PRIMARY KEY,
    JobRoleName    VARCHAR2(100) NOT NULL UNIQUE
);

-- -----------------------------------------------------------------------------
-- 4. DIMENSION: DIM_EDUCATION
-- -----------------------------------------------------------------------------
CREATE TABLE DIM_EDUCATION (
    EducationKey   NUMBER(5) PRIMARY KEY,
    EducationLevel NUMBER(2) NOT NULL,
    EducationLabel VARCHAR2(50) NOT NULL,
    EducationField VARCHAR2(100) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 5. DIMENSION: DIM_EMPLOYEE
-- -----------------------------------------------------------------------------
CREATE TABLE DIM_EMPLOYEE (
    EmployeeNumber      NUMBER(10) PRIMARY KEY,
    Age                 NUMBER(3) NOT NULL,
    AgeGroup            VARCHAR2(20) NOT NULL,
    Gender              VARCHAR2(20) NOT NULL,
    MaritalStatus       VARCHAR2(30) NOT NULL,
    DepartmentID        NUMBER(5) NOT NULL,
    JobRoleID           NUMBER(5) NOT NULL,
    EducationKey        NUMBER(5) NOT NULL,
    EducationField      VARCHAR2(100),
    NumCompaniesWorked  NUMBER(3),
    TotalWorkingYears   NUMBER(3),
    DistanceFromHome    NUMBER(4),
    CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DepartmentID) REFERENCES DIM_DEPARTMENT(DepartmentID),
    CONSTRAINT FK_EMP_ROLE FOREIGN KEY (JobRoleID) REFERENCES DIM_JOB_ROLE(JobRoleID),
    CONSTRAINT FK_EMP_EDU  FOREIGN KEY (EducationKey) REFERENCES DIM_EDUCATION(EducationKey)
);

-- -----------------------------------------------------------------------------
-- 6. FACT TABLE: FACT_ATTRITION
-- -----------------------------------------------------------------------------
CREATE TABLE FACT_ATTRITION (
    AttritionFactID          NUMBER(10) PRIMARY KEY,
    EmployeeNumber           NUMBER(10) NOT NULL,
    DepartmentID             NUMBER(5) NOT NULL,
    JobRoleID                NUMBER(5) NOT NULL,
    EducationKey             NUMBER(5) NOT NULL,
    Attrition                VARCHAR2(10) NOT NULL,
    Attrition_Flag           NUMBER(1) NOT NULL,
    MonthlyIncome            NUMBER(10) NOT NULL,
    SalaryBand               VARCHAR2(30) NOT NULL,
    Is_Salary_Outlier        NUMBER(1) DEFAULT 0,
    YearsAtCompany           NUMBER(3) NOT NULL,
    TenureBand               VARCHAR2(30) NOT NULL,
    YearsInCurrentRole       NUMBER(3),
    YearsSinceLastPromotion  NUMBER(3),
    YearsWithCurrManager     NUMBER(3),
    BusinessTravel           VARCHAR2(50),
    OverTime                 VARCHAR2(10),
    JobLevel                 NUMBER(2),
    JobInvolvement           NUMBER(2),
    JobSatisfaction          NUMBER(2),
    EnvironmentSatisfaction  NUMBER(2),
    RelationshipSatisfaction NUMBER(2),
    WorkLifeBalance          NUMBER(2),
    PerformanceRating        NUMBER(2),
    PercentSalaryHike        NUMBER(4),
    StockOptionLevel         NUMBER(2),
    TrainingTimesLastYear    NUMBER(3),
    CONSTRAINT FK_FACT_EMP  FOREIGN KEY (EmployeeNumber) REFERENCES DIM_EMPLOYEE(EmployeeNumber),
    CONSTRAINT FK_FACT_DEPT FOREIGN KEY (DepartmentID) REFERENCES DIM_DEPARTMENT(DepartmentID),
    CONSTRAINT FK_FACT_ROLE FOREIGN KEY (JobRoleID) REFERENCES DIM_JOB_ROLE(JobRoleID),
    CONSTRAINT FK_FACT_EDU  FOREIGN KEY (EducationKey) REFERENCES DIM_EDUCATION(EducationKey),
    CONSTRAINT CHK_ATTRITION_FLAG CHECK (Attrition_Flag IN (0, 1)),
    CONSTRAINT CHK_SALARY_POSITIVE CHECK (MonthlyIncome > 0),
    CONSTRAINT CHK_TENURE_POSITIVE CHECK (YearsAtCompany >= 0)
);

-- -----------------------------------------------------------------------------
-- 7. PERFORMANCE INDEXES
-- -----------------------------------------------------------------------------
CREATE INDEX IDX_FACT_DEPT_ID   ON FACT_ATTRITION (DepartmentID);
CREATE INDEX IDX_FACT_ROLE_ID   ON FACT_ATTRITION (JobRoleID);
CREATE INDEX IDX_FACT_TENURE    ON FACT_ATTRITION (TenureBand);
CREATE INDEX IDX_FACT_SALARY    ON FACT_ATTRITION (SalaryBand);
CREATE INDEX IDX_FACT_OVERTIME  ON FACT_ATTRITION (OverTime);
CREATE INDEX IDX_FACT_ATTR_FLAG ON FACT_ATTRITION (Attrition_Flag);

COMMENT ON TABLE FACT_ATTRITION IS 'Enterprise HR Fact Table storing employee employment events and attrition telemetry';
COMMENT ON COLUMN FACT_ATTRITION.Attrition_Flag IS 'Binary indicator: 1 = Voluntarily Left (Yes), 0 = Currently Active (No)';
COMMENT ON COLUMN FACT_ATTRITION.Is_Salary_Outlier IS 'Flagged via 1.5x IQR upper threshold ($16,581) for executive compensation auditing';
