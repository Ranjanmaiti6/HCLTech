-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Candidate Name: Ranjan Maiti | Roll No: 2500321540146
-- Script: 02_oracle_data_load.sql
-- Description: Oracle SQL ETL and Data Load Scripts populating Star Schema
--              tables from staging data with automated derivations.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION A: SQL*LOADER SPECIFICATION (For reference and direct DB ingest)
-- -----------------------------------------------------------------------------
/*
Save as `load_stg_attrition.ctl`:
LOAD DATA
INFILE 'employee_attrition_clean.csv'
INTO TABLE STG_EMPLOYEE_ATTRITION
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    Age, Attrition, BusinessTravel, DailyRate, Department, DistanceFromHome,
    Education, EducationField, EmployeeNumber, EnvironmentSatisfaction,
    Gender, HourlyRate, JobInvolvement, JobLevel, JobRole, JobSatisfaction,
    MaritalStatus, MonthlyIncome, MonthlyRate, NumCompaniesWorked,
    OverTime, PercentSalaryHike, PerformanceRating, RelationshipSatisfaction,
    StockOptionLevel, TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance,
    YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager
)
*/

-- -----------------------------------------------------------------------------
-- SECTION B: POPULATING DIMENSION TABLES FROM STAGING
-- -----------------------------------------------------------------------------

-- 1. Populate DIM_DEPARTMENT
INSERT INTO DIM_DEPARTMENT (DepartmentID, DepartmentName)
SELECT ROWNUM, Department
FROM (
    SELECT DISTINCT Department
    FROM STG_EMPLOYEE_ATTRITION
    WHERE Department IS NOT NULL
    ORDER BY Department
);
COMMIT;

-- 2. Populate DIM_JOB_ROLE
INSERT INTO DIM_JOB_ROLE (JobRoleID, JobRoleName)
SELECT ROWNUM, JobRole
FROM (
    SELECT DISTINCT JobRole
    FROM STG_EMPLOYEE_ATTRITION
    WHERE JobRole IS NOT NULL
    ORDER BY JobRole
);
COMMIT;

-- 3. Populate DIM_EDUCATION
INSERT INTO DIM_EDUCATION (EducationKey, EducationLevel, EducationLabel, EducationField)
SELECT ROWNUM, Education,
       CASE Education
           WHEN 1 THEN 'Below College'
           WHEN 2 THEN 'College'
           WHEN 3 THEN 'Bachelor'
           WHEN 4 THEN 'Master'
           WHEN 5 THEN 'Doctor'
           ELSE 'Unknown'
       END AS EducationLabel,
       EducationField
FROM (
    SELECT DISTINCT Education, EducationField
    FROM STG_EMPLOYEE_ATTRITION
    WHERE Education IS NOT NULL
    ORDER BY Education, EducationField
);
COMMIT;

-- 4. Populate DIM_EMPLOYEE
INSERT INTO DIM_EMPLOYEE (
    EmployeeNumber, Age, AgeGroup, Gender, MaritalStatus,
    DepartmentID, JobRoleID, EducationKey, EducationField,
    NumCompaniesWorked, TotalWorkingYears, DistanceFromHome
)
SELECT 
    s.EmployeeNumber,
    s.Age,
    CASE 
        WHEN s.Age < 30 THEN '18-29'
        WHEN s.Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN s.Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS AgeGroup,
    s.Gender,
    s.MaritalStatus,
    d.DepartmentID,
    r.JobRoleID,
    e.EducationKey,
    s.EducationField,
    s.NumCompaniesWorked,
    s.TotalWorkingYears,
    s.DistanceFromHome
FROM STG_EMPLOYEE_ATTRITION s
JOIN DIM_DEPARTMENT d ON s.Department = d.DepartmentName
JOIN DIM_JOB_ROLE r   ON s.JobRole = r.JobRoleName
JOIN DIM_EDUCATION e  ON s.Education = e.EducationLevel AND s.EducationField = e.EducationField;
COMMIT;

-- 5. Populate FACT_ATTRITION
INSERT INTO FACT_ATTRITION (
    AttritionFactID,
    EmployeeNumber,
    DepartmentID,
    JobRoleID,
    EducationKey,
    Attrition,
    Attrition_Flag,
    MonthlyIncome,
    SalaryBand,
    Is_Salary_Outlier,
    YearsAtCompany,
    TenureBand,
    YearsInCurrentRole,
    YearsSinceLastPromotion,
    YearsWithCurrManager,
    BusinessTravel,
    OverTime,
    JobLevel,
    JobInvolvement,
    JobSatisfaction,
    EnvironmentSatisfaction,
    RelationshipSatisfaction,
    WorkLifeBalance,
    PerformanceRating,
    PercentSalaryHike,
    StockOptionLevel,
    TrainingTimesLastYear
)
SELECT 
    ROWNUM AS AttritionFactID,
    s.EmployeeNumber,
    d.DepartmentID,
    r.JobRoleID,
    e.EducationKey,
    s.Attrition,
    CASE WHEN UPPER(TRIM(s.Attrition)) = 'YES' THEN 1 ELSE 0 END AS Attrition_Flag,
    s.MonthlyIncome,
    CASE 
        WHEN s.MonthlyIncome < 3500 THEN 'Low (<3.5k)'
        WHEN s.MonthlyIncome < 7000 THEN 'Mid (3.5k-7k)'
        WHEN s.MonthlyIncome < 12000 THEN 'High (7k-12k)'
        ELSE 'Executive (12k+)'
    END AS SalaryBand,
    CASE WHEN s.MonthlyIncome > 16581 THEN 1 ELSE 0 END AS Is_Salary_Outlier,
    s.YearsAtCompany,
    CASE 
        WHEN s.YearsAtCompany < 3 THEN '0-2 Years'
        WHEN s.YearsAtCompany < 6 THEN '3-5 Years'
        WHEN s.YearsAtCompany < 11 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS TenureBand,
    s.YearsInCurrentRole,
    s.YearsSinceLastPromotion,
    s.YearsWithCurrManager,
    s.BusinessTravel,
    s.OverTime,
    s.JobLevel,
    s.JobInvolvement,
    s.JobSatisfaction,
    s.EnvironmentSatisfaction,
    s.RelationshipSatisfaction,
    s.WorkLifeBalance,
    s.PerformanceRating,
    s.PercentSalaryHike,
    s.StockOptionLevel,
    s.TrainingTimesLastYear
FROM STG_EMPLOYEE_ATTRITION s
JOIN DIM_DEPARTMENT d ON s.Department = d.DepartmentName
JOIN DIM_JOB_ROLE r   ON s.JobRole = r.JobRoleName
JOIN DIM_EDUCATION e  ON s.Education = e.EducationLevel AND s.EducationField = e.EducationField;
COMMIT;

-- Validation check
SELECT 'DIM_DEPARTMENT' AS Table_Name, COUNT(*) AS Row_Count FROM DIM_DEPARTMENT
UNION ALL
SELECT 'DIM_JOB_ROLE', COUNT(*) FROM DIM_JOB_ROLE
UNION ALL
SELECT 'DIM_EDUCATION', COUNT(*) FROM DIM_EDUCATION
UNION ALL
SELECT 'DIM_EMPLOYEE', COUNT(*) FROM DIM_EMPLOYEE
UNION ALL
SELECT 'FACT_ATTRITION', COUNT(*) FROM FACT_ATTRITION;
