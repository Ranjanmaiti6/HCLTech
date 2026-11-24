-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Candidate Name: Ranjan Maiti | Roll No: 2500321540146
-- Script: 05_oracle_test_cases.sql
-- Description: Oracle SQL Test Suite verifying Edge Cases, Data Quality Rules,
--              Outlier Flags, Zero-Division Handling, and Reconciliation.
-- =============================================================================

SET SERVEROUTPUT ON;

-- -----------------------------------------------------------------------------
-- TEST CASE 1: MISSING TENURE AND NULL / ZERO CHECKS
-- -----------------------------------------------------------------------------
PROMPT =========================================================================
PROMPT [TEST CASE 1]: VALIDATING TENURE INTEGRITY & NULL HANDLING
PROMPT =========================================================================

-- Verify no unhandled NULL tenure values exist in FACT_ATTRITION
SELECT 
    COUNT(*) AS Null_Tenure_Count,
    CASE WHEN COUNT(*) = 0 THEN 'PASSED' ELSE 'FAILED' END AS Test_Status
FROM FACT_ATTRITION
WHERE YearsAtCompany IS NULL;

-- Validate safe binning logic with NVL fallback
SELECT 
    NVL(TO_CHAR(YearsAtCompany), 'NULL_VALUE') AS Tenure_Value,
    CASE 
        WHEN NVL(YearsAtCompany, 0) < 3 THEN '0-2 Years'
        WHEN NVL(YearsAtCompany, 0) < 6 THEN '3-5 Years'
        WHEN NVL(YearsAtCompany, 0) < 11 THEN '6-10 Years'
        ELSE '10+ Years'
    END AS Safe_Tenure_Band,
    COUNT(*) AS Employee_Count
FROM FACT_ATTRITION
GROUP BY YearsAtCompany
HAVING YearsAtCompany IN (0, 1, 2)
ORDER BY YearsAtCompany;

-- -----------------------------------------------------------------------------
-- TEST CASE 2: SALARY OUTLIERS AND BOUNDARY CHECKS
-- -----------------------------------------------------------------------------
PROMPT =========================================================================
PROMPT [TEST CASE 2]: AUDITING SALARY OUTLIERS (> 1.5x IQR THRESHOLD $16,581)
PROMPT =========================================================================

-- Detect and classify salary outliers
SELECT 
    f.EmployeeNumber,
    j.JobRoleName,
    d.DepartmentName,
    f.MonthlyIncome,
    f.Is_Salary_Outlier,
    f.Attrition
FROM FACT_ATTRITION f
JOIN DIM_JOB_ROLE j   ON f.JobRoleID = j.JobRoleID
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
WHERE f.MonthlyIncome > 16581
ORDER BY f.MonthlyIncome DESC
FETCH FIRST 10 ROWS ONLY;

-- Verify negative/zero compensation constraint
SELECT 
    COUNT(*) AS Invalid_Salary_Count,
    CASE WHEN COUNT(*) = 0 THEN 'PASSED (Zero invalid salaries)' ELSE 'FAILED' END AS Boundary_Check
FROM FACT_ATTRITION
WHERE MonthlyIncome <= 0;

-- -----------------------------------------------------------------------------
-- TEST CASE 3: SINGLE-EMPLOYEE DEPARTMENT ZERO-DIVISION RESILIENCE
-- -----------------------------------------------------------------------------
PROMPT =========================================================================
PROMPT [TEST CASE 3]: SINGLE-EMPLOYEE DEPARTMENT ZERO-DIVISION RESILIENCE
PROMPT =========================================================================

-- Test query with simulated 1-person departments using NVL and NULLIF
WITH Mock_Department_Data AS (
    SELECT 'Executive Security' AS Dept_Name, 1 AS Emp_Count, 1 AS Leavers FROM DUAL UNION ALL
    SELECT 'Board Advisory'     AS Dept_Name, 1 AS Emp_Count, 0 AS Leavers FROM DUAL UNION ALL
    SELECT 'Vacant Innovation'  AS Dept_Name, 0 AS Emp_Count, 0 AS Leavers FROM DUAL
)
SELECT 
    Dept_Name,
    Emp_Count,
    Leavers,
    -- Safe division protecting against ORA-01476: divisor is equal to zero
    ROUND(NVL(Leavers * 100.0 / NULLIF(Emp_Count, 0), 0.0), 2) AS Calculated_Attrition_Rate_Pct,
    CASE 
        WHEN Emp_Count = 0 THEN 'SAFE_ZERO_HANDLED'
        WHEN Emp_Count = 1 AND Leavers = 1 THEN '100%_SINGLE_EMP_HANDLED'
        WHEN Emp_Count = 1 AND Leavers = 0 THEN '0%_SINGLE_EMP_HANDLED'
    END AS Edge_Case_Evaluation
FROM Mock_Department_Data;

-- -----------------------------------------------------------------------------
-- TEST CASE 4: RECONCILIATION ACROSS STAGING, STAR SCHEMA, AND VIEWS
-- -----------------------------------------------------------------------------
PROMPT =========================================================================
PROMPT [TEST CASE 4]: MULTI-TIER RECONCILIATION AUDIT
PROMPT =========================================================================

SELECT 
    'STG_EMPLOYEE_ATTRITION' AS Table_Or_View,
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN UPPER(TRIM(Attrition)) = 'YES' THEN 1 ELSE 0 END) AS Leavers,
    ROUND(SUM(CASE WHEN UPPER(TRIM(Attrition)) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 4) AS Attrition_Rate
FROM STG_EMPLOYEE_ATTRITION
UNION ALL
SELECT 
    'FACT_ATTRITION',
    COUNT(*),
    SUM(Attrition_Flag),
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 4)
FROM FACT_ATTRITION
UNION ALL
SELECT 
    'VW_HR_ATTRITION_MASTER',
    COUNT(*),
    SUM(Attrition_Flag),
    ROUND(SUM(Attrition_Flag) * 100.0 / COUNT(*), 4)
FROM VW_HR_ATTRITION_MASTER;
