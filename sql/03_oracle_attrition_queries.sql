-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Candidate Name: Ranjan Maiti | Roll No: 2500321540146
-- Script: 03_oracle_attrition_queries.sql
-- Description: Advanced Oracle SQL Analytical Queries covering Attrition by
--              Department, Tenure Band, Salary Band, Window Functions,
--              Multi-level Aggregations, and Analytical Ranking.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- QUERY 1: CORE RECONCILIATION - OVERALL ATTRITION & HEADCOUNT
-- -----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition_Flag = 0 THEN 1 ELSE 0 END) AS Active_Employees,
    SUM(Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM FACT_ATTRITION;

-- -----------------------------------------------------------------------------
-- QUERY 2: ATTRITION BY DEPARTMENT WITH RANKING & RATIO TO REPORT
-- Demonstrates: Oracle Window Functions (RANK, DENSE_RANK, RATIO_TO_REPORT)
-- -----------------------------------------------------------------------------
SELECT 
    d.DepartmentName,
    COUNT(f.EmployeeNumber) AS Total_Employees,
    SUM(f.Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(f.EmployeeNumber), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(f.MonthlyIncome), 2) AS Avg_Monthly_Income,
    -- Rank departments by attrition rate
    DENSE_RANK() OVER (ORDER BY SUM(f.Attrition_Flag) * 1.0 / COUNT(f.EmployeeNumber) DESC) AS Attrition_Risk_Rank,
    -- Proportion of company-wide attrition originating from this department
    ROUND(RATIO_TO_REPORT(SUM(f.Attrition_Flag)) OVER () * 100, 2) AS Pct_Of_Total_Company_Attrition
FROM FACT_ATTRITION f
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Attrition_Risk_Rank;

-- -----------------------------------------------------------------------------
-- QUERY 3: ATTRITION BY TENURE BAND WITH CUMULATIVE METRICS
-- Demonstrates: Analytical Window Functions (Running Totals, Cumulative %)
-- -----------------------------------------------------------------------------
SELECT 
    TenureBand,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    -- Running total of attrition across tenure progression
    SUM(SUM(Attrition_Flag)) OVER (
        ORDER BY CASE TenureBand 
            WHEN '0-2 Years' THEN 1 
            WHEN '3-5 Years' THEN 2 
            WHEN '6-10 Years' THEN 3 
            ELSE 4 
        END
    ) AS Cumulative_Attrition_Count,
    -- Percentage of all leavers within tenure band
    ROUND(RATIO_TO_REPORT(SUM(Attrition_Flag)) OVER () * 100, 2) AS Pct_Of_All_Leavers
FROM FACT_ATTRITION
GROUP BY TenureBand
ORDER BY CASE TenureBand 
    WHEN '0-2 Years' THEN 1 
    WHEN '3-5 Years' THEN 2 
    WHEN '6-10 Years' THEN 3 
    ELSE 4 
END;

-- -----------------------------------------------------------------------------
-- QUERY 4: ATTRITION BY SALARY BAND & EXECUTIVE OUTLIER ANALYSIS
-- Demonstrates: Conditional Aggregations and Outlier Impact
-- -----------------------------------------------------------------------------
SELECT 
    SalaryBand,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Salary,
    MIN(MonthlyIncome) AS Min_Salary,
    MAX(MonthlyIncome) AS Max_Salary,
    SUM(Is_Salary_Outlier) AS Executive_Outlier_Count
FROM FACT_ATTRITION
GROUP BY SalaryBand
ORDER BY CASE SalaryBand 
    WHEN 'Low (<3.5k)' THEN 1 
    WHEN 'Mid (3.5k-7k)' THEN 2 
    WHEN 'High (7k-12k)' THEN 3 
    ELSE 4 
END;

-- -----------------------------------------------------------------------------
-- QUERY 5: MULTI-DIMENSIONAL ATTRITION MATRIX (DEPARTMENT X GENDER)
-- Demonstrates: Power BI Slicer alignment and Crosstab logic
-- -----------------------------------------------------------------------------
SELECT 
    d.DepartmentName,
    e.Gender,
    COUNT(*) AS Total_Headcount,
    SUM(f.Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(f.MonthlyIncome), 2) AS Avg_Salary
FROM FACT_ATTRITION f
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
JOIN DIM_EMPLOYEE e   ON f.EmployeeNumber = e.EmployeeNumber
GROUP BY d.DepartmentName, e.Gender
ORDER BY d.DepartmentName, e.Gender;

-- -----------------------------------------------------------------------------
-- QUERY 6: IMPACT OF OVERTIME AND BUSINESS TRAVEL (BURNOUT DRIVER)
-- Demonstrates: Multi-Factor Risk Segmentation
-- -----------------------------------------------------------------------------
SELECT 
    f.OverTime,
    f.BusinessTravel,
    COUNT(*) AS Total_Staff,
    SUM(f.Attrition_Flag) AS Attrition_Count,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(f.WorkLifeBalance), 2) AS Avg_WorkLifeBalance_Score
FROM FACT_ATTRITION f
GROUP BY f.OverTime, f.BusinessTravel
ORDER BY Attrition_Rate_Pct DESC;

-- -----------------------------------------------------------------------------
-- QUERY 7: ADVANCED ENTERPRISE ROLLUP HIERARCHY
-- Demonstrates: Oracle SQL GROUP BY ROLLUP for Subtotals and Grand Total
-- -----------------------------------------------------------------------------
SELECT 
    NVL(d.DepartmentName, '=== ALL DEPARTMENTS ===') AS Department,
    NVL(f.TenureBand, '--- ALL TENURE BANDS ---') AS Tenure_Band,
    COUNT(*) AS Total_Staff,
    SUM(f.Attrition_Flag) AS Total_Attrition,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM FACT_ATTRITION f
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
GROUP BY ROLLUP(d.DepartmentName, f.TenureBand)
ORDER BY d.DepartmentName NULLS LAST, f.TenureBand NULLS LAST;

-- -----------------------------------------------------------------------------
-- QUERY 8: TOP 5 HIGHEST ATTRITION JOB ROLES WITH SALARY & SATISFACTION
-- Demonstrates: ROW_NUMBER() and Nested Analytic Filtering
-- -----------------------------------------------------------------------------
WITH JobRoleMetrics AS (
    SELECT 
        j.JobRoleName,
        d.DepartmentName,
        COUNT(*) AS Total_Staff,
        SUM(f.Attrition_Flag) AS Leavers,
        ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate,
        ROUND(AVG(f.MonthlyIncome), 2) AS Avg_Salary,
        ROUND(AVG(f.JobSatisfaction), 2) AS Avg_Satisfaction,
        ROW_NUMBER() OVER (ORDER BY SUM(f.Attrition_Flag) * 1.0 / COUNT(*) DESC) AS Rank_Order
    FROM FACT_ATTRITION f
    JOIN DIM_JOB_ROLE j   ON f.JobRoleID = j.JobRoleID
    JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
    GROUP BY j.JobRoleName, d.DepartmentName
)
SELECT *
FROM JobRoleMetrics
WHERE Rank_Order <= 5;
