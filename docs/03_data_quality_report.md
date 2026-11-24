# Project 10: Employee Attrition Analysis
## Document 03: Enterprise Data Quality & Profiling Report
**Candidate Name:** Ranjan Maiti  
**Candidate Roll No:** 2500321540146  
**Institution / Program:** HCLTech Career Shaper  
**Evaluation Target:** Data Quality, Cleansing & Cross-Tool Reconciliation  

---

### 1. Data Ingestion & Quality Audit Summary
An exhaustive data profiling assessment was performed on the raw IBM HR dataset (`WA_Fn-UseC_-HR-Employee-Attrition.csv`) prior to database modeling and BI reporting.

```
+--------------------------------------+-------------------------+
| Quality Check Dimension              | Result / Status         |
+--------------------------------------+-------------------------+
| Raw Record Count                     | 1,470 Rows              |
| Raw Column Count                     | 35 Columns              |
| Missing / NULL Cells in Raw Data     | 0 (0.00%)               |
| Duplicate Rows                       | 0 (0.00%)               |
| Zero-Variance (Constant) Columns     | 3 Columns Identified    |
| Statistical Salary Outliers (1.5xIQR)| 114 Records (7.76%)     |
| Processed Master Clean Rows          | 1,470 Rows              |
| Final Reconciled Attrition Rate      | 16.1224%                |
+--------------------------------------+-------------------------+
```

---

### 2. Cleansing Actions & Transformations Applied

#### 1. Removal of Zero-Variance Columns
In raw survey data, three columns exhibited zero variance across all 1,470 rows:
- `EmployeeCount`: Uniformly equal to `1` across all rows.
- `Over18`: Uniformly equal to `'Y'` across all rows (no minors employed).
- `StandardHours`: Uniformly equal to `80` across all rows.

*Action:* These 3 columns were pruned from the analytical schema to optimize storage footprint and avoid redundant metadata.

#### 2. Statistical Outlier Detection (Monthly Income)
- **Methodology:** Tukey's Boxplot Interquartile Range (IQR) Rule:
  $$\text{IQR} = Q_3 - Q_1 = \$8,379.00 - \$2,911.00 = \$5,468.00$$
  $$\text{Upper Threshold} = Q_3 + (1.5 \times \text{IQR}) = \$8,379.00 + (1.5 \times \$5,468.00) = \mathbf{\$16,581.00}$$
- **Outlier Audit Findings:** 114 employees earn between \$16,581 and \$19,999.
- **Root Cause & Treatment:** An inspection confirms that these individuals exclusively occupy senior leadership designations (74 Managers and 40 Research Directors). These are legitimate executive salaries and **not** data errors. Rather than discarding them (which would distort headcount and payroll costs), they were retained and flagged via `Is_Salary_Outlier = 1`.

#### 3. Standardized Discretization (Feature Engineering)
- **Salary Bands:**
  - `Low (<3.5k)`: \$1,009 to \$3,499 (472 employees, 32.1%)
  - `Mid (3.5k-7k)`: \$3,500 to \$6,999 (563 employees, 38.3%)
  - `High (7k-12k)`: \$7,000 to \$11,999 (240 employees, 16.3%)
  - `Executive (12k+)`: \$12,000 to \$19,999 (195 employees, 13.3%)
- **Tenure Bands:**
  - `0-2 Years`: Early career / probationary (342 employees, 23.3%)
  - `3-5 Years`: Intermediate stability (434 employees, 29.5%)
  - `6-10 Years`: Experienced tenure (448 employees, 30.5%)
  - `10+ Years`: Senior veteran tenure (246 employees, 16.7%)

---

### 3. Cross-Tool Metric Reconciliation Table
A primary acceptance criterion is proving mathematical reconciliation across the Python pipeline, Oracle SQL tables, and Power BI visual cards.

| Metric | Python Pipeline (`01_data_cleaning_and_eda.py`) | Oracle SQL (`FACT_ATTRITION`) | Power BI Dashboard (`.pbix`) | Reconciliation Variance | Pass / Fail Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Total Headcount** | 1,470 | 1,470 | 1,470 | 0.00% | **PASSED** |
| **Active Workforce** | 1,233 | 1,233 | 1,233 | 0.00% | **PASSED** |
| **Separated Workforce** | 237 | 237 | 237 | 0.00% | **PASSED** |
| **Overall Attrition Rate** | **16.12%** | **16.12%** | **16.12%** | 0.00% | **PASSED** |
| **Sales Dept Attrition** | 20.63% (92 / 446) | 20.63% (92 / 446) | 20.63% (92 / 446) | 0.00% | **PASSED** |
| **HR Dept Attrition** | 19.05% (12 / 63) | 19.05% (12 / 63) | 19.05% (12 / 63) | 0.00% | **PASSED** |
| **R&D Dept Attrition** | 13.84% (133 / 961) | 13.84% (133 / 961) | 13.84% (133 / 961) | 0.00% | **PASSED** |
| **0-2 Yrs Tenure Attrition** | 29.82% (102 / 342) | 29.82% (102 / 342) | 29.82% (102 / 342) | 0.00% | **PASSED** |
| **OverTime Attrition Rate** | 30.53% (127 / 416) | 30.53% (127 / 416) | 30.53% (127 / 416) | 0.00% | **PASSED** |
| **Non-OT Attrition Rate** | 10.44% (110 / 1054) | 10.44% (110 / 1054) | 10.44% (110 / 1054) | 0.00% | **PASSED** |
| **Average Monthly Income** | \$6,502.93 | \$6,502.93 | \$6,502.93 | 0.00% | **PASSED** |

**Conclusion:** All cross-platform checks match with 100% precision.
