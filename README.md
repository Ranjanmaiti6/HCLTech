# Employee Attrition Analysis (Project No. 10)
## HR Workforce Intelligence & Turnover Risk Analytics

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue.svg)](https://www.python.org/)
[![Oracle SQL](https://img.shields.io/badge/Oracle-SQL%2019c-red.svg)](https://www.oracle.com/database/)
[![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-yellow.svg)](https://powerbi.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

### Student & Project Submission Information
- **Student Name:** Ranjan Maiti
- **Roll Number:** 2500321540146
- **Academic Level:** 2nd-Year B.Tech Student
- **Project Number:** Project No. 10
- **Project Name:** Employee Attrition Analysis
- **Domain:** HR & Education / Workforce Analytics
- **Evaluation Platform:** HCLTech Career Shaper LMS
- **Repository Link:** [GitHub Repository](https://github.com/RanjanMaiti/HCLTech-Employee-Attrition-Analysis)

---

## 1. Project Introduction & Problem Statement
Employee attrition refers to the departure of employees from an organization through voluntary resignation or turnover. In modern enterprises, losing skilled workforce talent causes substantial financial losses, operational delays, and loss of institutional knowledge. Industry research indicates that replacing a departing employee costs between **50% to 200% of their annual salary**.

### Problem Statement
Organizations frequently monitor only company-wide aggregate attrition figures (e.g., 16%), failing to identify critical pockets of turnover reaching **30% to 40%** within specific departments, tenure cohorts, and salary bands. Without clear data insights, leadership struggles to deploy effective retention strategies.

### Project Objectives
1. **Analyze** 1,470 employee records from the benchmark IBM HR dataset to uncover key turnover patterns.
2. **Perform Data Cleaning & EDA** in Python using Pandas, NumPy, Matplotlib, and Seaborn.
3. **Build an Oracle SQL 19c Pipeline** with table DDL, analytical queries, and reporting views.
4. **Design a Power BI Dashboard** with 5 executive KPI cards, 6 visualizations, and interactive slicers.
5. **Formulate Data-Backed Recommendations** and calculate projected financial ROI.

---

## 2. Dataset Information & Source
- **Dataset Name:** IBM HR Analytics Employee Attrition & Performance Dataset
- **Publisher:** IBM Watson Analytics / Open Data Initiative
- **Download Link:** [Kaggle Dataset Source](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- **Dataset Verification:**
  - **Total Records:** 1,470 rows
  - **Features:** 35 raw columns, 37 cleaned analytical attributes
  - **Data Quality:** 0 missing values (100% completeness), 0 duplicate rows
  - **Target Variable:** `Attrition` ('Yes' = 237, 'No' = 1,233)
  - **Salary Outliers:** 114 employees earning above $16,581/month (IQR method) were verified as Managers (74) and Research Directors (40) and retained via `Is_Salary_Outlier` to preserve executive leadership representation without distortion.

---

## 3. Clean Project Directory Structure

```text
Employee_Attrition_Analysis/
│
├── dataset/
│   ├── employee_attrition.csv            # Original raw IBM HR dataset (1,470 rows)
│   └── employee_attrition_cleaned.csv    # Cleaned CSV with engineered cohort bands
│
├── python/
│   ├── employee_attrition_analysis.ipynb # 12-step executed Jupyter Notebook with charts
│   └── requirements.txt                  # Python dependencies (pandas, matplotlib, etc.)
│
├── sql/
│   └── employee_attrition_analysis.sql   # Consolidated Oracle SQL script (DDL, queries, views)
│
├── powerbi/
│   ├── dax_measures.txt                  # Complete DAX measures for all KPI cards & charts
│   └── powerbi_build_guide.md            # Step-by-step instructions to build the dashboard
│
├── dashboard/
│   ├── dashboard_screenshot.png          # High-resolution Power BI dashboard overview
│   └── analysis_charts.png               # 6-panel Python exploratory analysis chart
│
├── submission/
│   ├── Employee_Attrition_Analysis_Report.pdf # 7-page comprehensive academic project report
│   ├── Dataset_Details.pdf               # Teacher-required dataset proof & column dictionary
│   └── submission_checklist.md           # HCL Portal evaluation checklist
│
├── README.md                             # Main project guide (this file)
└── .gitignore                            # Clean git exclusion rules
```

---

## 4. How to Run & Verify Each Component

### A. Python Analysis
1. Navigate to the `python/` folder:
   ```bash
   cd python
   pip install -r requirements.txt
   ```
2. Open and run the notebook in VS Code or Jupyter:
   ```bash
   jupyter notebook employee_attrition_analysis.ipynb
   ```
   *Note: All 12 analytical steps, tables, and Seaborn/Matplotlib charts are pre-executed and visible immediately upon opening.*

### B. Oracle SQL Queries
1. Open **Oracle SQL Developer** (or Oracle Live SQL / SQL*Plus) and connect to your database.
2. Open the file `sql/employee_attrition_analysis.sql`.
3. Follow the loading instructions in Section 2 to import `dataset/employee_attrition_cleaned.csv` into `EMPLOYEE_ATTRITION`.
4. Run the queries in Sections 3 to 10 to inspect overall attrition, department breakdown, tenure flight window, and views.

### C. Power BI Dashboard
- **Dashboard Title:** `EMPLOYEE ATTRITION ANALYSIS`
- **Subtitle:** `HR Workforce Intelligence Dashboard`
- **Visual Proof:** Review `dashboard/dashboard_screenshot.png` for the completed dashboard layout.
- **DAX Formulas:** Open `powerbi/dax_measures.txt` for ready-to-use formulas.
- **Desktop Build Guide:** Follow `powerbi/powerbi_build_guide.md` to load the CSV, configure cards, and build charts on any Windows PC with Power BI Desktop.

---

## 5. Key Verified Project Findings (Actual Statistics)

All statistics are strictly calculated from the 1,470 employee records:

| Analytical Dimension | High-Risk Cohort | Baseline / Low-Risk Cohort | Impact & Business Insight |
| :--- | :--- | :--- | :--- |
| **1. Mandatory OverTime** | **30.53%** (127 / 416 left) | **10.44%** (110 / 1,054 left) | **Nearly 3x turnover multiplier** due to workload burnout. |
| **2. Service Tenure** | **29.82%** in Years 0-2 | **8.13%** in Years 10+ | **43.04% of all resignations** happen in the first 2 years. |
| **3. Monthly Salary** | **27.12%** (< $3,500/mo) | **5.64%** ($12,000+/mo) | **54.0% of all exits** occur in the entry-level wage tier. |
| **4. Department** | **20.63%** in Sales | **13.84%** in R&D | Sales Reps within Sales suffer an extreme **39.76%** exit rate. |
| **5. Age Generation** | **27.91%** in Age 18-29 | **9.74%** in Age 40-49 | Early-career mobility drives turnover in younger cohorts. |

---

## 6. Strategic Business Recommendations & ROI

1. **OverTime Capping & Workload Balancing:** Cap consecutive overtime weeks to a maximum of 2 per month per employee; cross-train staff to absorb peak volume. Projected savings: **~38 retained staff/year**.
2. **180-Day "New Hire Concierge" Mentorship:** Pair new hires with experienced peers outside their reporting hierarchy with structured check-ins at 30, 90, and 180 days. Projected savings: **~34 retained staff/year**.
3. **Sales Representative Career Ladder:** Establish a clear 12-month milestone ladder from Sales Representative to Junior Account Executive with progressive compensation.
4. **Estimated Financial ROI:** Reducing turnover by 25% (59 fewer departures at $25,000 avg replacement cost) saves **$1.475 Million annually**.

---

## 7. Submission Deliverables Summary (For HCL Portal)

1. **Dataset Proof PDF:** `submission/Dataset_Details.pdf` (Source link, dictionary, sample records).
2. **Completed Project Report PDF:** `submission/Employee_Attrition_Analysis_Report.pdf` (Cover page, methodology, charts, SQL, dashboard screenshot, insights).
3. **Dashboard Screenshot:** `dashboard/dashboard_screenshot.png` (High-resolution full dashboard visual).
4. **Cleaned Dataset CSV:** `dataset/employee_attrition_cleaned.csv` (Ready for grading and analysis).
