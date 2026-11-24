# HCLTech Career Shaper Capstone Project
# Project 10: Enterprise Employee Attrition Analysis & Workforce Intelligence

[![Python 3.10+](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Oracle SQL 19c](https://img.shields.io/badge/Oracle-SQL%2019c-red.svg)](https://www.oracle.com/database/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-yellow.svg)](https://powerbi.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

### Candidate & Submission Information
- **Candidate Name:** Ranjan Maiti
- **Candidate Roll No:** 2500321540146
- **Project Number:** Project 10
- **Project Title:** Employee Attrition Analysis
- **Domain:** HR and Workforce Analytics
- **Evaluation Platform:** HCLTech Career Shaper LMS

---

## 1. Project Overview & Business Problem
Employee attrition represents a major source of operational disruption and direct financial loss, with replacement costs averaging 50% to 200% of an annual salary per departure. 

This project delivers an enterprise-grade analytics and business intelligence solution analyzing **1,470 employee profiles** from the benchmark IBM HR dataset. Using a modern analytics stack (**Python, Oracle SQL, and Power BI**), this project quantifies turnover drivers across departments, tenure cohorts, and salary bands, delivering actionable workforce retention strategies and a net projected annual cost savings of **$1.475 Million**.

---

## 2. Industry-Grade Deliverables Included

| Deliverable Area | Artifact / File Location | Description |
| :--- | :--- | :--- |
| **Problem Statement & KPIs** | [`docs/01_problem_statement_and_kpis.md`](docs/01_problem_statement_and_kpis.md) | Business context, mathematical formulas, and KPI definitions. |
| **Star Schema Blueprint** | [`docs/02_er_and_star_schema_diagram.md`](docs/02_er_and_star_schema_diagram.md) | Dimensional data model, data dictionaries, and ER architecture. |
| **Data Quality Report** | [`docs/03_data_quality_report.md`](docs/03_data_quality_report.md) | Data profiling, 114 salary outlier audit, and cross-tool reconciliation. |
| **Strategic Insights** | [`docs/04_insights_summary_and_recommendations.md`](docs/04_insights_summary_and_recommendations.md) | Top 3 visual insights, turnover risk matrix, and ROI recommendations. |
| **Test Cases Sign-Off** | [`docs/05_test_cases_and_verification.md`](docs/05_test_cases_and_verification.md) | Automated validation of missing tenure, salary outliers, and division safety. |
| **Python Pipeline** | [`python/01_data_cleaning_and_eda.py`](python/01_data_cleaning_and_eda.py) | Full ETL, outlier detection, star-schema generation, and plot rendering. |
| **Automated Tests** | [`python/02_test_cases_validation.py`](python/02_test_cases_validation.py) | Automated test suite verifying edge cases and cross-tool reconciliation. |
| **Interactive Notebook** | [`python/Employee_Attrition_Analysis.ipynb`](python/Employee_Attrition_Analysis.ipynb) | End-to-end interactive Jupyter Notebook with narrative and visuals. |
| **Oracle SQL DDL** | [`sql/01_oracle_ddl_star_schema.sql`](sql/01_oracle_ddl_star_schema.sql) | Enterprise DDL with constraints, PK/FK, sequences, and indexes. |
| **Oracle SQL ETL** | [`sql/02_oracle_data_load.sql`](sql/02_oracle_data_load.sql) | Staging transformation scripts and SQL*Loader control specifications. |
| **Oracle Analytical SQL** | [`sql/03_oracle_attrition_queries.sql`](sql/03_oracle_attrition_queries.sql) | Advanced analytical queries utilizing `RANK`, `DENSE_RANK`, `RATIO_TO_REPORT`, and `ROLLUP`. |
| **Oracle Views & PL/SQL** | [`sql/04_oracle_views_plsql.sql`](sql/04_oracle_views_plsql.sql) | Production BI views, `PRC_CHECK_ATTRITION_ALERT`, and `FN_CALC_ATTRITION_RISK_INDEX`. |
| **Oracle Spool Output** | [`sql/query_execution_results.txt`](sql/query_execution_results.txt) | Complete SQL*Plus execution log proving query results and PL/SQL execution. |
| **Power BI Build Guide** | [`powerbi/powerbi_build_guide.md`](powerbi/powerbi_build_guide.md) | Step-by-step canvas design guide, slicers, cards, and drill-down setup. |
| **DAX Measures** | [`powerbi/dax_measures.txt`](powerbi/dax_measures.txt) | 12 production DAX measures formatted and ready to paste into Power BI. |
| **High-Res Visuals** | [`visual_outputs/`](visual_outputs/) | 6 publication-quality charts (Overview, Dept, Tenure/Salary, Heatmap, Sentiment). |
| **Demo Video Script** | [`presentation_and_video/demo_video_script.md`](presentation_and_video/demo_video_script.md) | Minute-by-minute speaking cues for a 3-5 minute presentation video. |
| **Presentation Deck** | [`presentation_and_video/project_presentation_slides.md`](presentation_and_video/project_presentation_slides.md) | 11-slide capstone evaluation presentation deck. |
| **Submission Links** | [`links.txt`](links.txt) | Centralized reference containing GitHub repo link and demo video link. |

---

## 3. Repository Architecture

```
2500321540146_RanjanMaiti_EmployeeAttritionAnalysis/
├── data/
│   ├── raw/
│   │   └── WA_Fn-UseC_-HR-Employee-Attrition.csv      # Authentic IBM benchmark dataset (1,470 rows)
│   └── processed/
│       ├── employee_attrition_clean.csv               # Master cleaned dataset
│       ├── dim_department.csv                         # Department dimension
│       ├── dim_job_role.csv                           # Job Role dimension
│       ├── dim_education.csv                          # Education dimension
│       ├── dim_employee.csv                           # Employee demographic dimension
│       └── fact_attrition.csv                         # Central attrition fact table
├── python/
│   ├── 01_data_cleaning_and_eda.py                    # Main data engineering & plotting pipeline
│   ├── 02_test_cases_validation.py                    # Automated test case verification suite
│   ├── Employee_Attrition_Analysis.ipynb              # Complete interactive Jupyter Notebook
│   └── requirements.txt                               # Python dependency manifest
├── sql/
│   ├── 01_oracle_ddl_star_schema.sql                  # Star schema DDL & indexes
│   ├── 02_oracle_data_load.sql                        # Data loading & staging transformations
│   ├── 03_oracle_attrition_queries.sql                # Window functions & advanced aggregations
│   ├── 04_oracle_views_plsql.sql                      # Views, stored procedures & functions
│   ├── 05_oracle_test_cases.sql                       # Edge-case test queries
│   └── query_execution_results.txt                    # Formatted SQL*Plus execution log
├── powerbi/
│   ├── powerbi_build_guide.md                         # Click-by-click dashboard construction guide
│   ├── dax_measures.txt                               # Production DAX measures
│   └── model_relationship_guide.md                   # Star schema relationship guide
├── docs/
│   ├── 01_problem_statement_and_kpis.md               # Business context & KPI definitions
│   ├── 02_er_and_star_schema_diagram.md               # ER diagrams & data dictionary
│   ├── 03_data_quality_report.md                      # Data profiling & 100% reconciliation table
│   ├── 04_insights_summary_and_recommendations.md     # Top insights, risk matrix & ROI
│   └── 05_test_cases_and_verification.md              # Test case execution & sign-off
├── visual_outputs/
│   ├── dashboard_overview.png                         # Master 4-panel dashboard visual
│   ├── attrition_by_department.png                    # Attrition by job role & department
│   ├── attrition_by_tenure_salary.png                 # Tenure vs Salary risk heatmap
│   ├── correlation_heatmap.png                        # Correlation matrix of numeric features
│   ├── satisfaction_vs_attrition.png                  # Multi-factor sentiment vs attrition
│   └── key_drivers_summary.png                        # Disproportionate risk factor gaps
├── presentation_and_video/
│   ├── demo_video_script.md                           # Professional presentation script (3-5 min)
│   └── project_presentation_slides.md                 # 11-slide capstone presentation outline
├── links.txt                                          # GitHub & Demo Video links
├── README.md                                          # Master documentation portal
└── .gitignore                                         # Version control ignore rules
```

---

## 4. Key Analytical Insights Summary

```
=============================================================================
OVERALL WORKFORCE BASELINE:
Total Employees: 1,470 | Active: 1,233 | Leavers: 237 | Attrition Rate: 16.12%
=============================================================================
```

### Insight 1: OverTime is the #1 Turnover Multiplier (30.53% vs 10.44%)
- Staff required to work regular overtime suffer an attrition rate of **30.53%** (127 leavers out of 416), nearly triple the rate of non-overtime staff (**10.44%**).
- When combined with frequent travel, turnover reaches **40.21%**.

### Insight 2: The Two-Year Flight Window (43.0% of all Leavers)
- Employees in their first 2 years of tenure exhibit a **29.82% attrition rate**.
- Although 0-2 year staff represent only 23.3% of the headcount, they account for **43.04% of all resignations** (102 leavers).

### Insight 3: Sales Department & Entry Roles Face Severe Turnover
- **Sales Department:** 20.63% attrition rate (highest among all departments).
- **Sales Representatives:** Experience an alarming **39.76% attrition rate**, primarily driven by entry-level compensation ($2,626/month).

---

## 5. Automated Test Cases & Acceptance Criteria Verification

All four mandatory test cases passed with zero regressions:

| Test ID | Scope | Verification Logic | Status |
| :--- | :--- | :--- | :--- |
| **TC-01** | Missing Tenure & 0-Tenure Bounds | Handled 44 new hires with 0 tenure; safe fallback into probationary bucket. | **PASSED** |
| **TC-02** | Salary Outliers & Boundary Robustness | 114 executive outliers detected (> $16,581); validated as legitimate Managers/Directors. | **PASSED** |
| **TC-03** | Single-Employee Department Edge Case | Verified safe division (`NULLIF`, `NVL`, `DIVIDE`) to prevent zero division. | **PASSED** |
| **TC-04** | Cross-Tool Metric Reconciliation | 1,470 total rows, 237 leavers, 16.12% attrition rate match across Python, SQL, and Power BI. | **PASSED** |

---

## 6. How to Run the Project Locally

### Prerequisites
- Python 3.10+
- Oracle Database 19c / 21c (or SQL Developer / LiveSQL)
- Power BI Desktop

### 1. Python Environment Setup & Execution
```bash
# 1. Install dependencies
pip install -r python/requirements.txt

# 2. Run data engineering, cleaning, and plot generation
python python/01_data_cleaning_and_eda.py

# 3. Run automated test cases
python python/02_test_cases_validation.py
```

### 2. Oracle Database Setup
```sql
-- Connect as HR_ANALYTICS in SQL*Plus or Oracle SQL Developer:
@sql/01_oracle_ddl_star_schema.sql
@sql/02_oracle_data_load.sql
@sql/03_oracle_attrition_queries.sql
@sql/04_oracle_views_plsql.sql
@sql/05_oracle_test_cases.sql

-- Run the PL/SQL Alert Procedure:
SET SERVEROUTPUT ON;
EXEC PRC_CHECK_ATTRITION_ALERT(15.0);
```

### 3. Power BI Dashboard Setup
Follow the step-by-step instructions in [`powerbi/powerbi_build_guide.md`](powerbi/powerbi_build_guide.md) to load the processed CSV files, configure the Star Schema relationships, create DAX measures from [`powerbi/dax_measures.txt`](powerbi/dax_measures.txt), and lay out the executive dashboard canvas.

---

## 7. How to Push this Project to Your GitHub Repository

```bash
# 1. Configure your Git credentials
git config user.name "Ranjan Maiti"
git config user.email "your_email@example.com"

# 2. Add all project files
git add .

# 3. Commit the enterprise project
git commit -m "feat: complete HCLTech Project 10 - Employee Attrition Analysis"

# 4. Link your remote GitHub repository and push
git remote add origin https://github.com/RanjanMaiti/HCLTech-Employee-Attrition-Analysis.git
git branch -M main
git push -u origin main
```

---

## 8. LMS Submission Instructions for Ranjan Maiti

To submit your project on the HCLTech Career Shaper LMS:
1. Ensure your submission folder is named: `2500321540146_RanjanMaiti_EmployeeAttritionAnalysis`.
2. Generate the single consolidated ZIP package:
   ```bash
   zip -r 2500321540146_RanjanMaiti_EmployeeAttritionAnalysis.zip . -x "*.git*"
   ```
3. Upload `2500321540146_RanjanMaiti_EmployeeAttritionAnalysis.zip` to the **"Project Submission - Output Files"** assignment on Moodle.
4. Verify your status changes from *Draft* to **"Submitted for grading"**.

---
*Developed with excellence by Ranjan Maiti (Roll No: 2500321540146) for HCLTech Career Shaper Project Evaluation.*
