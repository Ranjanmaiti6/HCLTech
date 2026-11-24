# Project Presentation Slide Deck Outline
## HCLTech Career Shaper - Final Capstone Evaluation
### Project 10: Employee Attrition Analysis & Workforce Retention Strategy

---

### Slide 1: Title Slide
- **Title:** Enterprise Employee Attrition Analysis
- **Subtitle:** Identifying Turnover Drivers & Predictive Workforce Optimization Using Python, Oracle SQL & Power BI
- **Candidate Name:** Ranjan Maiti
- **Roll Number:** 2500321540146
- **Organization / Program:** HCLTech Career Shaper Capstone Project

---

### Slide 2: Business Context & Problem Statement
- **The Challenge:** Voluntary employee turnover costs organizations 50% to 200% of an annual salary per departure in backfill hiring and lost productivity.
- **The Dataset:** Benchmark IBM HR Analytics Employee Dataset (1,470 records, 35 raw parameters).
- **Core Objectives:**
  - Audited headcount reconciliation across analytical tools.
  - Identification of turnover risk factors across Department, Tenure, and Compensation bands.
  - Delivery of an enterprise Star Schema and interactive executive Power BI Dashboard.

---

### Slide 3: Technical Architecture & Methodology
- **Data Engineering (Python):**
  - Cleaned zero-variance columns (`EmployeeCount`, `Over18`, `StandardHours`).
  - Feature-engineered Salary Bands, Tenure Bands, and binary flags.
  - Executed automated test suite (`02_test_cases_validation.py`) covering edge cases.
- **Data Warehouse (Oracle SQL 19c):**
  - 3 Dimension Tables (`DIM_DEPARTMENT`, `DIM_JOB_ROLE`, `DIM_EDUCATION`).
  - 1 Dimension Entity (`DIM_EMPLOYEE`) & 1 Fact Table (`FACT_ATTRITION`).
  - Performance indexes, constraints, and PL/SQL Alert Procedures.
- **Business Intelligence (Power BI Desktop):**
  - Single-direction Star Schema relationships (`1:*`).
  - 12 production DAX measures and dynamic filtering cards.

---

### Slide 4: Data Profiling & Quality Assurance
- **Headcount Reconciliation:**
  - Total Workforce: **1,470**
  - Active Employees: **1,233**
  - Resigned Staff: **237**
  - Attrition Rate: **16.12%** (Reconciled with 0.00% variance across CSV, SQL, and Power BI).
- **Salary Outliers Treatment:**
  - 114 employees earn > $16,581 (1.5x IQR upper fence).
  - All confirmed as legitimate executive leadership (Managers and Research Directors).
  - Preserved and flagged via `Is_Salary_Outlier = 1`.

---

### Slide 5: Key Finding 1 - The OverTime Burnout Epidemic
- **Stat:** Overtime Attrition Rate = **30.53%** vs Non-Overtime Rate = **10.44%**.
- **Multiplier:** Employees working overtime are **nearly 3x more likely** to leave the company.
- **Compound Factor:** OverTime combined with Frequent Travel elevates attrition to **40.21%**.
- **Visual Evidence:** Supported by `visual_outputs/satisfaction_vs_attrition.png`.

---

### Slide 6: Key Finding 2 - The 2-Year Early Career Flight Window
- **Stat:** 0-2 Years Tenure Attrition Rate = **29.82%** vs 10+ Years Tenure = **8.13%**.
- **Impact:** New hires in their first 2 years constitute 23.3% of the staff but represent **43.04% of all resignations** (102 leavers).
- **Visual Evidence:** Supported by `visual_outputs/attrition_by_tenure_salary.png`.

---

### Slide 7: Key Finding 3 - Frontline Departmental & Role Vulnerability
- **Department Ranking:**
  - Sales: **20.63%** (Highest department risk)
  - Human Resources: **19.05%**
  - Research & Development: **13.84%**
- **Critical Job Role:** Sales Representatives suffer **39.76% attrition**, driven by low entry-level pay ($2,626/month).
- **Visual Evidence:** Supported by `visual_outputs/attrition_by_department.png`.

---

### Slide 8: Interactive Power BI Dashboard Showcase
- **Executive KPI Ribbon:** Total Headcount (1,470), Retained (1,233), Leavers (237), Attrition Rate (16.12%).
- **Interactive Slicers:** Dynamic cross-filtering by **Department** and **Gender**.
- **Risk Heatmap Matrix:** Tenure Band vs Salary Band cross-tabulation visual.
- **Drill-down Capabilities:** Hierarchical navigation from Department into Job Roles.

---

### Slide 9: Automated Edge Case Test Suite Results
- **TC-01 (Missing Tenure):** Handled 44 new hires with 0 tenure; safe fallback into probationary bucket.
- **TC-02 (Salary Outliers):** Robust handling of 114 executive records without arithmetic overflow.
- **TC-03 (Single-Employee Departments):** Safe division prevents `ORA-01476` / `#DIV/0!`.
- **TC-04 (Cross-Tool Reconciliation):** 100% agreement across Python, Oracle, and Power BI.

---

### Slide 10: Strategic Recommendations & Financial ROI
- **1. OverTime Workload Cap:** Rebalance peak laboratory and sales operations workloads.
- **2. 180-Day Mentorship Program:** Structured support during high-risk 0-24 month window.
- **3. Sales Career Progression Ladder:** 12-month milestone promotion path to reduce sales turnover.
- **Estimated ROI:**
  - 25% attrition reduction = 59 fewer departures annually.
  - Average cost per departure = $25,000.
  - **Projected Net Annual Cost Savings: $1,475,000 / year.**

---

### Slide 11: Submission & Repository Links
- **Candidate:** Ranjan Maiti (Roll No: 2500321540146)
- **GitHub Repository:** `https://github.com/RanjanMaiti/HCLTech-Employee-Attrition-Analysis`
- **Demo Video Link:** Documented in `links.txt`
- **LMS Package:** Ready in `2500321540146_RanjanMaiti_EmployeeAttritionAnalysis.zip`
