-- =============================================================================
-- HCLTech Career Shaper - Final Academic Project Submission
-- Project No: 10 - Employee Attrition Analysis
-- Candidate Name: Ranjan Maiti | Roll No: 2500321540146
-- Script: 04_oracle_views_plsql.sql
-- Description: Production Oracle Views for BI Consumption, and Enterprise PL/SQL
--              Procedures & Functions for Workforce Risk Auditing.
-- =============================================================================

-- =============================================================================
-- PART 1: ORACLE DATABASE REPORTING VIEWS
-- =============================================================================

-- 1. Master Flat Analytical View for BI Ingestion
CREATE OR REPLACE VIEW VW_HR_ATTRITION_MASTER AS
SELECT 
    f.AttritionFactID,
    f.EmployeeNumber,
    e.Age,
    e.AgeGroup,
    e.Gender,
    e.MaritalStatus,
    d.DepartmentID,
    d.DepartmentName,
    j.JobRoleID,
    j.JobRoleName,
    ed.EducationKey,
    ed.EducationLevel,
    ed.EducationLabel,
    ed.EducationField,
    f.Attrition,
    f.Attrition_Flag,
    f.MonthlyIncome,
    f.SalaryBand,
    f.Is_Salary_Outlier,
    f.YearsAtCompany,
    f.TenureBand,
    f.YearsInCurrentRole,
    f.YearsSinceLastPromotion,
    f.YearsWithCurrManager,
    f.BusinessTravel,
    f.OverTime,
    f.JobLevel,
    f.JobInvolvement,
    f.JobSatisfaction,
    f.EnvironmentSatisfaction,
    f.RelationshipSatisfaction,
    f.WorkLifeBalance,
    f.PerformanceRating,
    f.PercentSalaryHike,
    f.StockOptionLevel,
    f.TrainingTimesLastYear,
    e.NumCompaniesWorked,
    e.TotalWorkingYears,
    e.DistanceFromHome
FROM FACT_ATTRITION f
JOIN DIM_EMPLOYEE e   ON f.EmployeeNumber = e.EmployeeNumber
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
JOIN DIM_JOB_ROLE j   ON f.JobRoleID = j.JobRoleID
JOIN DIM_EDUCATION ed ON f.EducationKey = ed.EducationKey;

-- 2. Department Summary View
CREATE OR REPLACE VIEW VW_DEPT_ATTRITION_METRICS AS
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    COUNT(*) AS Headcount,
    SUM(f.Attrition_Flag) AS Leavers,
    SUM(CASE WHEN f.Attrition_Flag = 0 THEN 1 ELSE 0 END) AS Retained,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(f.MonthlyIncome), 2) AS Avg_Monthly_Salary,
    ROUND(AVG(f.YearsAtCompany), 1) AS Avg_Tenure_Years,
    ROUND(AVG(f.WorkLifeBalance), 2) AS Avg_WorkLifeBalance
FROM FACT_ATTRITION f
JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;

-- 3. Tenure vs Salary Cross-Tabulation View
CREATE OR REPLACE VIEW VW_TENURE_SALARY_MATRIX AS
SELECT 
    f.TenureBand,
    f.SalaryBand,
    COUNT(*) AS Headcount,
    SUM(f.Attrition_Flag) AS Leavers,
    ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM FACT_ATTRITION f
GROUP BY f.TenureBand, f.SalaryBand;

-- =============================================================================
-- PART 2: ENTERPRISE PL/SQL STORED PROCEDURES & FUNCTIONS
-- =============================================================================

-- Stored Procedure: Departmental Attrition Threshold Auditor
-- Flags departments exceeding a defined threshold (e.g., 15.0%)
CREATE OR REPLACE PROCEDURE PRC_CHECK_ATTRITION_ALERT (
    p_threshold_pct IN NUMBER DEFAULT 15.0
)
IS
    CURSOR c_dept_metrics IS
        SELECT 
            d.DepartmentName,
            COUNT(*) AS total_count,
            SUM(f.Attrition_Flag) AS attr_count,
            ROUND(SUM(f.Attrition_Flag) * 100.0 / COUNT(*), 2) AS attr_rate
        FROM FACT_ATTRITION f
        JOIN DIM_DEPARTMENT d ON f.DepartmentID = d.DepartmentID
        GROUP BY d.DepartmentName
        ORDER BY attr_rate DESC;
        
    v_alert_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('==================================================================');
    DBMS_OUTPUT.PUT_LINE('HCLTECH WORKFORCE AUDIT: DEPARTMENT ATTRITION ALERT MONITOR');
    DBMS_OUTPUT.PUT_LINE('CANDIDATE: RANJAN MAITI | ROLL NO: 2500321540146');
    DBMS_OUTPUT.PUT_LINE('Target Alert Threshold: ' || p_threshold_pct || '%');
    DBMS_OUTPUT.PUT_LINE('==================================================================');

    FOR r IN c_dept_metrics LOOP
        IF r.attr_rate > p_threshold_pct THEN
            v_alert_count := v_alert_count + 1;
            DBMS_OUTPUT.PUT_LINE('[ALERT - HIGH RISK] Department: ' || RPAD(r.DepartmentName, 25) || 
                                 ' | Total: ' || RPAD(TO_CHAR(r.total_count), 4) || 
                                 ' | Leavers: ' || RPAD(TO_CHAR(r.attr_count), 4) || 
                                 ' | Rate: ' || r.attr_rate || '% (BREACHED)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[COMPLIANT - SAFE]  Department: ' || RPAD(r.DepartmentName, 25) || 
                                 ' | Total: ' || RPAD(TO_CHAR(r.total_count), 4) || 
                                 ' | Leavers: ' || RPAD(TO_CHAR(r.attr_count), 4) || 
                                 ' | Rate: ' || r.attr_rate || '% (NORMAL)');
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Breached Departments Identified: ' || v_alert_count);
    DBMS_OUTPUT.PUT_LINE('==================================================================');
END PRC_CHECK_ATTRITION_ALERT;
/

-- Stored Function: Multi-Factor Employee Attrition Risk Scorer (0 - 100 Index)
CREATE OR REPLACE FUNCTION FN_CALC_ATTRITION_RISK_INDEX (
    p_emp_number IN NUMBER
) RETURN NUMBER
IS
    v_score NUMBER := 0;
    v_overtime VARCHAR2(10);
    v_salary NUMBER;
    v_tenure NUMBER;
    v_job_sat NUMBER;
    v_wlb NUMBER;
BEGIN
    SELECT OverTime, MonthlyIncome, YearsAtCompany, JobSatisfaction, WorkLifeBalance
    INTO v_overtime, v_salary, v_tenure, v_job_sat, v_wlb
    FROM FACT_ATTRITION
    WHERE EmployeeNumber = p_emp_number;

    -- Factor 1: OverTime (30 points)
    IF UPPER(TRIM(v_overtime)) = 'YES' THEN
        v_score := v_score + 30;
    END IF;

    -- Factor 2: Low Compensation (< $3,500) (25 points)
    IF v_salary < 3500 THEN
        v_score := v_score + 25;
    ELSIF v_salary < 7000 THEN
        v_score := v_score + 10;
    END IF;

    -- Factor 3: Early Tenure (< 3 Years) (20 points)
    IF v_tenure < 3 THEN
        v_score := v_score + 20;
    ELSIF v_tenure < 6 THEN
        v_score := v_score + 10;
    END IF;

    -- Factor 4: Low Job Satisfaction (15 points)
    IF v_job_sat = 1 THEN
        v_score := v_score + 15;
    ELSIF v_job_sat = 2 THEN
        v_score := v_score + 8;
    END IF;

    -- Factor 5: Poor Work-Life Balance (10 points)
    IF v_wlb = 1 THEN
        v_score := v_score + 10;
    ELSIF v_wlb = 2 THEN
        v_score := v_score + 5;
    END IF;

    RETURN LEAST(v_score, 100);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- Employee does not exist
END FN_CALC_ATTRITION_RISK_INDEX;
/
