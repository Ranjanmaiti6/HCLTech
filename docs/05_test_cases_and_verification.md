# Project 10: Employee Attrition Analysis
## Document 05: Test Cases & Acceptance Criteria Verification
**Candidate Name:** Ranjan Maiti  
**Candidate Roll No:** 2500321540146  
**Institution / Program:** HCLTech Career Shaper  
**Submission Requirement:** Validation of Specific Key Test Cases & Acceptance Criteria  

---

### 1. Verification Matrix Overview
As mandated in the HCLTech project brief for **Project 10 (Employee Attrition Analysis)**, the analytical solution must undergo explicit verification against three mandatory edge-case test scenarios, in addition to end-to-end cross-tool reconciliation.

```
+---------+-----------------------------------------+--------------------+----------------+
| Test ID | Test Case Scope                         | Automated Script   | Result Status  |
+---------+-----------------------------------------+--------------------+----------------+
| TC-01   | Missing Tenure Handling & 0-Year Bounds | Python & SQL       | 100% PASSED    |
| TC-02   | Salary Outliers Detection & Robustness  | Python & SQL       | 100% PASSED    |
| TC-03   | Single-Employee Departments & Division  | Python & SQL       | 100% PASSED    |
| TC-04   | Cross-Tool Metric Reconciliation        | Python, SQL, BI    | 100% PASSED    |
+---------+-----------------------------------------+--------------------+----------------+
```

---

### 2. Detailed Test Case Execution Records

#### TEST CASE TC-01: Missing Tenure & Zero-Tenure Boundary Condition
- **Requirement:** Ensure robust handling of missing tenure (`NULL`), 0-tenure (newly joined employees), and negative values.
- **Test Implementation:**
  - *Python:* `python/02_test_cases_validation.py` lines 30-49. Simulated `NaN` injection and zero-tenure checks.
  - *Oracle SQL:* `sql/05_oracle_test_cases.sql` Section 1. Verified `NVL(YearsAtCompany, 0)` and `CHK_TENURE_POSITIVE` constraint.
- **Observed Behavior:**
  - 44 employees in the dataset have exactly `YearsAtCompany = 0` (joined within the current calendar year).
  - Both Python `pd.cut()` and Oracle SQL `CASE` statements safely bucketed all 44 into the `'0-2 Years'` probationary band.
  - No `NaN` or unclassified buckets were generated.
- **Status:** **PASSED**.

#### TEST CASE TC-02: Salary Outliers & Boundary Robustness
- **Requirement:** Accurately detect and handle extreme compensation values without corrupting aggregates or throwing arithmetic overflows.
- **Test Implementation:**
  - *Method:* Tukey's Interquartile Range (IQR). Calculated $Q_1 = \$2,911.00$, $Q_3 = \$8,379.00$, $\text{IQR} = \$5,468.00$, Upper Bound = $\$16,581.00$.
  - *Python:* Tested via `python/02_test_cases_validation.py` lines 54-73.
  - *Oracle SQL:* Audited via `SELECT ... WHERE MonthlyIncome > 16581`.
- **Observed Behavior:**
  - 114 records (7.76% of dataset) exceed \$16,581.
  - All 114 records correlate 100% to legitimate executive designations (74 Managers, 40 Research Directors).
  - Outliers are safely tagged with `Is_Salary_Outlier = 1` rather than deleted, preserving total payroll accuracy.
  - Minimum salary is verified positive (\$1,009 > \$0), satisfying `CHK_SALARY_POSITIVE`.
- **Status:** **PASSED**.

#### TEST CASE TC-03: Single-Employee Departments & Zero-Division Protection
- **Requirement:** Verify that grouping queries and DAX measures do not fail or return divide-by-zero errors (`ORA-01476: divisor is equal to zero` or `#DIV/0!`) when evaluating micro-departments or single-member teams.
- **Test Implementation:**
  - *Python:* Evaluated a synthetic DataFrame containing 1-person departments (`Legal Special Ops` with 1 leaver, `Cyber Forensics` with 0 leavers, and an empty department placeholder).
  - *Oracle SQL:* Tested via `NULLIF(Emp_Count, 0)` and `NVL()` logic.
  - *Power BI DAX:* Enforced via `DIVIDE([Attrition Count], [Total Employees], 0)`.
- **Observed Behavior:**
  - Single employee with separation evaluated cleanly to `100.0%`.
  - Single employee retained evaluated cleanly to `0.0%`.
  - Empty department evaluated cleanly to `0.0%` without runtime exceptions.
- **Status:** **PASSED**.

#### TEST CASE TC-04: Cross-Tool Metric Reconciliation
- **Requirement:** Ensure row counts, separated staff counts, and department rates match exactly between CSV, Oracle SQL, and Power BI.
- **Findings Summary:**
  - Total Headcount: **1,470** across all 3 tools.
  - Active Headcount: **1,233** across all 3 tools.
  - Attrition Count: **237** across all 3 tools.
  - Attrition Rate: **16.12%** across all 3 tools.
  - Sales Department Attrition: **20.63%** (92 / 446) across all 3 tools.
  - Human Resources Department Attrition: **19.05%** (12 / 63) across all 3 tools.
  - R&D Department Attrition: **13.84%** (133 / 961) across all 3 tools.
- **Status:** **PASSED (Zero Variance)**.

---

### 3. Evaluator Sign-Off Criteria
All measurable acceptance criteria defined in Project 10 specifications are satisfied:
1. Attrition rate verified by department and tenure.
2. At least 3 primary insights supported by high-resolution visual charts.
3. Interactive slicers for Department and Gender fully configured and validated.
