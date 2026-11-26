-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Student Name: Ranjan Maiti | Roll No: 2500321540146
-- Academic Year: 2nd-Year B.Tech
-- Domain: HR & Workforce Analytics
-- File: employee_attrition_analysis.sql
-- Description: Consolidated, beginner-friendly Oracle SQL script containing:
--              1. Table Creation (EMPLOYEE_ATTRITION)
--              2. Data Loading Instructions
--              3. Core Analytical Queries (Overall, Dept, Gender, Age, Salary, Tenure, Overtime)
--              4. Production SQL Views for Reporting & Dashboards
-- =============================================================================

-- =============================================================================
-- SECTION 1: TABLE CREATION (DDL)
-- =============================================================================

-- Drop existing table if recreating
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE_ATTRITION CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE EMPLOYEE_ATTRITION (
    Age                      NUMBER(3),
    Attrition                VARCHAR2(10),        -- 'Yes' or 'No'
    BusinessTravel           VARCHAR2(50),        -- 'Travel_Rarely', 'Travel_Frequently', 'Non-Travel'
    DailyRate                NUMBER(6),
    Department               VARCHAR2(50),        -- 'Sales', 'Research & Development', 'Human Resources'
    DistanceFromHome         NUMBER(4),
    Education                NUMBER(2),           -- 1: Below College, 2: College, 3: Bachelor, 4: Master, 5: Doctor
    EducationField           VARCHAR2(50),        -- 'Life Sciences', 'Medical', 'Marketing', etc.
    EmployeeNumber           NUMBER(8) PRIMARY KEY,
    EnvironmentSatisfaction  NUMBER(2),           -- 1: Low, 2: Medium, 3: High, 4: Very High
    Gender                   VARCHAR2(10),        -- 'Male', 'Female'
    HourlyRate               NUMBER(5),
    JobInvolvement           NUMBER(2),
    JobLevel                 NUMBER(2),           -- 1 to 5
    JobRole                  VARCHAR2(50),
    JobSatisfaction          NUMBER(2),           -- 1: Low, 2: Medium, 3: High, 4: Very High
    MaritalStatus            VARCHAR2(20),        -- 'Single', 'Married', 'Divorced'
    MonthlyIncome            NUMBER(8),
    MonthlyRate              NUMBER(8),
    NumCompaniesWorked       NUMBER(3),
    OverTime                 VARCHAR2(10),        -- 'Yes', 'No'
    PercentSalaryHike        NUMBER(3),
    PerformanceRating        NUMBER(2),
    RelationshipSatisfaction NUMBER(2),
    StockOptionLevel         NUMBER(2),
    TotalWorkingYears        NUMBER(3),
    TrainingTimesLastYear    NUMBER(3),
    WorkLifeBalance          NUMBER(2),           -- 1: Bad, 2: Good, 3: Better, 4: Best
    YearsAtCompany           NUMBER(3),
    YearsInCurrentRole       NUMBER(3),
    YearsSinceLastPromotion  NUMBER(3),
    YearsWithCurrManager     NUMBER(3),
    -- Derived Analytical Fields
    Attrition_Flag           NUMBER(1),           -- 1 for Yes, 0 for No
    AgeGroup                 VARCHAR2(20),        -- '18-29', '30-39', '40-49', '50+'
    SalaryBand               VARCHAR2(30),        -- 'Low (<3.5k)', 'Mid (3.5k-7k)', 'High (7k-12k)', 'Executive (12k+)'
    TenureBand               VARCHAR2(30),        -- '0-2 Years', '3-5 Years', '6-10 Years', '10+ Years'
    Is_Salary_Outlier        NUMBER(1)            -- 1 if MonthlyIncome > $16,581 (IQR Upper Bound), else 0
);

COMMENT ON TABLE EMPLOYEE_ATTRITION IS 'Cleaned IBM HR Analytics dataset for Employee Attrition Analysis';
COMMENT ON COLUMN EMPLOYEE_ATTRITION.Attrition_Flag IS 'Binary indicator: 1 = Left Company, 0 = Active';
COMMENT ON COLUMN EMPLOYEE_ATTRITION.Is_Salary_Outlier IS 'Statistical IQR outlier flag: Managers/Directors retained without distortion';


-- =============================================================================
-- SECTION 2: DATA LOADING INSTRUCTIONS
-- =============================================================================
/*
METHOD A: Using Oracle SQL Developer GUI (Recommended for Students)
1. Open Oracle SQL Developer and connect to your database.
2. In the 'Connections' navigator, expand your connection and right-click on 'Tables' -> select 'Import Data...'.
3. Browse and select the cleaned CSV: 'dataset/employee_attrition_cleaned.csv'.
4. Format: CSV, Header: checked, Delimiter: comma (,).
5. Map source columns to the table EMPLOYEE_ATTRITION columns created above.
6. Click Finish to load all 1,470 records.

METHOD B: Using SQL*Loader (Command-Line)
1. Create a control file 'load_attrition.ctl':
   LOAD DATA
   INFILE 'dataset/employee_attrition_cleaned.csv'
   INTO TABLE EMPLOYEE_ATTRITION
   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
   TRAILING NULLCOLS
   (Age, Attrition, BusinessTravel, DailyRate, Department, DistanceFromHome,
    Education, EducationField, EmployeeNumber, EnvironmentSatisfaction, Gender,
    HourlyRate, JobInvolvement, JobLevel, JobRole, JobSatisfaction, MaritalStatus,
    MonthlyIncome, MonthlyRate, NumCompaniesWorked, OverTime, PercentSalaryHike,
    PerformanceRating, RelationshipSatisfaction, StockOptionLevel, TotalWorkingYears,
    TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany, YearsInCurrentRole,
    YearsSinceLastPromotion, YearsWithCurrManager, Attrition_Flag, AgeGroup,
    SalaryBand, TenureBand, Is_Salary_Outlier)
2. Run in terminal:
   sqlldr userid=username/password@db control=load_attrition.ctl skip=1
*/


-- =============================================================================
-- SECTION 3: OVERALL ATTRITION & HEADCOUNT METRICS
-- Purpose: Verify total workforce, active employees, total exits, and company-wide attrition rate.
-- Expected Output: Total=1,470 | Active=1,233 | Left=237 | Attrition Rate=16.12% | Avg Age=36.9
-- =============================================================================
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(Age), 1) AS Average_Employee_Age
FROM EMPLOYEE_ATTRITION;


-- =============================================================================
-- SECTION 4: DEPARTMENT-WISE EMPLOYEE COUNT & ATTRITION ANALYSIS
-- Purpose: Quantify headcount and voluntary turnover across organizational units.
-- Expected Output:
-- Sales: 446 total, 92 exits, 20.63% attrition rate (Highest rate)
-- Human Resources: 63 total, 12 exits, 19.05% attrition rate
-- Research & Development: 961 total, 133 exits, 13.84% attrition rate (Lowest rate)
-- =============================================================================
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY Department
ORDER BY Attrition_Rate_Pct DESC;


-- =============================================================================
-- SECTION 5: GENDER-WISE ATTRITION ANALYSIS
-- Purpose: Compare attrition rates between male and female employees.
-- Expected Output:
-- Male: 882 total, 150 exits, 17.01% attrition rate
-- Female: 588 total, 87 exits, 14.80% attrition rate
-- =============================================================================
SELECT 
    Gender,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY Gender
ORDER BY Attrition_Rate_Pct DESC;


-- =============================================================================
-- SECTION 6: AGE COHORT ATTRITION ANALYSIS
-- Purpose: Identify which age brackets experience the highest turnover.
-- Expected Output:
-- 18-29: 326 total, 91 exits, 27.91% attrition rate (Highest)
-- 30-39: 622 total, 89 exits, 14.31% attrition rate
-- 40-49: 349 total, 34 exits, 9.74% attrition rate (Lowest)
-- 50+:   173 total, 23 exits, 13.29% attrition rate
-- =============================================================================
SELECT 
    AgeGroup,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY AgeGroup
ORDER BY 
    CASE AgeGroup
        WHEN '18-29' THEN 1
        WHEN '30-39' THEN 2
        WHEN '40-49' THEN 3
        WHEN '50+'   THEN 4
        ELSE 5
    END;


-- =============================================================================
-- SECTION 7: SALARY BAND ATTRITION ANALYSIS
-- Purpose: Measure the direct correlation between compensation tier and employee exits.
-- Expected Output:
-- Low (<3.5k):        472 total, 128 exits, 27.12% attrition rate (54% of all leavers)
-- Mid (3.5k-7k):      563 total, 62 exits, 11.01% attrition rate
-- High (7k-12k):      240 total, 36 exits, 15.00% attrition rate
-- Executive (12k+):   195 total, 11 exits, 5.64% attrition rate
-- =============================================================================
SELECT 
    SalaryBand,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY SalaryBand
ORDER BY 
    CASE SalaryBand
        WHEN 'Low (<3.5k)'       THEN 1
        WHEN 'Mid (3.5k-7k)'     THEN 2
        WHEN 'High (7k-12k)'     THEN 3
        WHEN 'Executive (12k+)'  THEN 4
        ELSE 5
    END;


-- =============================================================================
-- SECTION 8: TENURE AT COMPANY (TENURE BAND) ATTRITION ANALYSIS
-- Purpose: Uncover the "Two-Year Flight Window" among early-tenure hires.
-- Expected Output:
-- 0-2 Years:  342 total, 102 exits, 29.82% attrition rate (43% of all exits)
-- 3-5 Years:  434 total, 60 exits, 13.82% attrition rate
-- 6-10 Years: 448 total, 55 exits, 12.28% attrition rate
-- 10+ Years:  246 total, 20 exits, 8.13% attrition rate (Highest loyalty)
-- =============================================================================
SELECT 
    TenureBand,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY TenureBand
ORDER BY 
    CASE TenureBand
        WHEN '0-2 Years'  THEN 1
        WHEN '3-5 Years'  THEN 2
        WHEN '6-10 Years' THEN 3
        WHEN '10+ Years'  THEN 4
        ELSE 5
    END;


-- =============================================================================
-- SECTION 9: OVERTIME IMPACT ANALYSIS
-- Purpose: Quantify the burnout multiplier effect of mandatory overtime.
-- Expected Output:
-- OverTime = 'Yes': 416 total, 127 exits, 30.53% attrition rate
-- OverTime = 'No':  1,054 total, 110 exits, 10.44% attrition rate
-- Result: Employees working overtime face nearly 3x higher turnover risk!
-- =============================================================================
SELECT 
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM EMPLOYEE_ATTRITION
GROUP BY OverTime
ORDER BY Attrition_Rate_Pct DESC;


-- =============================================================================
-- SECTION 10: PRODUCTION ORACLE SQL VIEWS
-- Purpose: Reusable views for reporting and Power BI DirectQuery / Live Connect.
-- =============================================================================

-- 1. Executive Summary View
CREATE OR REPLACE VIEW VW_ATTRITION_SUMMARY AS
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Who_Left,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Overall_Attrition_Rate_Pct,
    ROUND(AVG(Age), 1) AS Average_Employee_Age,
    ROUND(AVG(MonthlyIncome), 2) AS Average_Monthly_Income
FROM EMPLOYEE_ATTRITION;

-- 2. Department Breakdown View
CREATE OR REPLACE VIEW VW_DEPT_ATTRITION_METRICS AS
SELECT 
    Department,
    COUNT(*) AS Headcount,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Retained_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Leaver_Count,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Monthly_Salary
FROM EMPLOYEE_ATTRITION
GROUP BY Department;

-- 3. Critical Early-Career High Risk Cohort View (0-2 Yrs Tenure & Low Salary)
CREATE OR REPLACE VIEW VW_EARLY_CAREER_RISK AS
SELECT 
    EmployeeNumber,
    Age,
    Department,
    JobRole,
    MonthlyIncome,
    YearsAtCompany,
    OverTime,
    WorkLifeBalance,
    Attrition
FROM EMPLOYEE_ATTRITION
WHERE TenureBand = '0-2 Years' 
  AND SalaryBand = 'Low (<3.5k)';

-- =============================================================================
-- VERIFICATION NOTE:
-- All queries above conform strictly to Oracle SQL standards and use exact 
-- column identifiers verified against 'employee_attrition_cleaned.csv'.
-- Output statistics match verified Python calculations:
-- Total: 1,470 | Left: 237 | Active: 1,233 | Rate: 16.12%
-- =============================================================================
