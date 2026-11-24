# Project 10: Employee Attrition Analysis
## Document 01: Problem Statement & KPI Definitions
**Candidate Name:** Ranjan Maiti  
**Candidate Roll No:** 2500321540146  
**Institution / Program:** HCLTech Career Shaper  
**Submission Domain:** HR and Education Analytics  

---

### 1. Executive Summary & Problem Statement
Employee turnover represents one of the largest hidden operational costs and disruption factors in modern enterprise management. According to industry benchmarks (SHRM, Gallup), replacing a salaried professional costs between 50% to 200% of their annual salary due to lost productivity, recruiting overhead, onboarding, and knowledge loss.

In this project, an organization's HR leadership is experiencing voluntary attrition across several key business units. Without quantitative analytics, HR leaders rely on anecdotal exit interviews, leading to ineffective blanket compensation hikes that fail to stop talent drain.

#### Core Business Objectives:
1. **Quantify Attrition Dynamics:** Establish an exact, audited headcount baseline across the organization (1,470 employees).
2. **Identify Primary Risk Vectors:** Pinpoint whether turnover is driven by compensation disparities, job dissatisfaction, lack of career progression, or burnout from excessive overtime.
3. **Multi-Dimensional Segmentation:** Analyze turnover across Departments, Tenure cohorts, and Salary bands.
4. **Actionable Predictive Interventions:** Provide executive leadership with actionable workforce retention strategies and early-warning alert thresholds.

---

### 2. Standardized KPI Definitions & Mathematical Formulas

| KPI Name | Business Definition | Mathematical Formula | Target Benchmark |
| :--- | :--- | :--- | :--- |
| **Total Headcount ($N_{total}$)** | Total active and separated workforce in the reporting window. | $N_{total} = \sum \text{Employee Records}$ | 1,470 Staff |
| **Active Employees ($N_{active}$)** | Employees currently employed in good standing. | $N_{active} = \sum (\text{Attrition} = 0)$ | 1,233 Staff |
| **Attrition Count ($N_{attr}$)** | Total employees who voluntarily separated from the firm. | $N_{attr} = \sum (\text{Attrition} = 1)$ | 237 Leavers |
| **Overall Attrition Rate ($R_{attr}$)** | Proportion of the workforce lost during the period. | $R_{attr} = \left(\frac{N_{attr}}{N_{total}}\right) \times 100$ | **16.12%** |
| **Retention Rate ($R_{ret}$)** | Proportion of the workforce successfully retained. | $R_{ret} = 100\% - R_{attr}$ | **83.88%** |
| **Early-Tenure Attrition Rate** | Attrition rate among employees with less than 3 years tenure. | $R_{early} = \left(\frac{\text{Leavers with Tenure } < 3}{\text{Total Staff with Tenure } < 3}\right) \times 100$ | Baseline: **29.82%** |
| **OverTime Attrition Spread ($\Delta_{OT}$)** | Percentage-point gap in turnover between OverTime and Non-OverTime workers. | $\Delta_{OT} = R_{attr}(\text{OverTime}) - R_{attr}(\text{No OverTime})$ | Baseline: **+20.09% Gap** |
| **Average Monthly Compensation** | Arithmetic mean of base monthly salary across cohort. | $\bar{S} = \frac{1}{N}\sum \text{MonthlyIncome}_i$ | Baseline: **\$6,502.93** |
| **Average Tenure at Company** | Average number of continuous completed years at the firm. | $\bar{T} = \frac{1}{N}\sum \text{YearsAtCompany}_i$ | Baseline: **7.01 Years** |

---

### 3. Acceptance & Deliverable Verification Criteria
To fulfill HCLTech project submission requirements, the project delivers:
- **Verified Metrics:** Attrition rate reconciled within 0.00% across CSV, Oracle SQL, and Power BI.
- **Analytical Coverage:** Departmental, tenure-band, and salary-band aggregations.
- **Dimensional Slicing:** Dedicated dynamic slicers for Department and Gender.
- **Enterprise Star Schema:** Dimension and fact data structures optimized for BI reporting.
- **Test Scenarios:** Documented test cases for missing tenure, salary outliers, and single-employee departments.
