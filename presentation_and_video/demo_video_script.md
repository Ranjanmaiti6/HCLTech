# Professional Demo Video Presentation Script (3 to 5 Minutes)
## Project 10: Employee Attrition Analysis
**Candidate Name:** Ranjan Maiti  
**Roll No:** 2500321540146  
**Program:** HCLTech Career Shaper Project Submission  

---

### Video Metadata
- **Target Duration:** 3 Minutes 30 Seconds to 4 Minutes 30 Seconds
- **Screen Layout:** Full Screen Screen-recording (Power BI Dashboard & Terminal/SQL Output) with webcam picture-in-picture in the top-right corner.
- **Audio:** Clear, spoken English with professional cadence.

---

### Scene-by-Scene Script

#### Scene 1: Introduction & Project Overview (0:00 - 0:45)
- **Visual:** Title Slide displaying:
  * *HCLTech Career Shaper Project 10: Employee Attrition Analysis*
  * *Candidate: Ranjan Maiti | Roll No: 2500321540146*
- **Speaker (Ranjan Maiti):**
  > "Hello everyone and respected evaluators. My name is Ranjan Maiti, Roll Number 2500321540146. Today, I am presenting my final capstone project for the HCLTech Career Shaper program — **Project 10: Employee Attrition Analysis**.
  > 
  > In today's competitive corporate landscape, employee turnover imposes immense financial and operational costs on organizations. In this project, I have developed an end-to-end data analytics and business intelligence solution using Python, Oracle SQL, and Power BI to analyze 1,470 employee records from the benchmark IBM HR dataset, identify the root drivers of attrition, and deliver actionable workforce retention strategies."

#### Scene 2: Data Pipeline & Data Quality Assurance (0:45 - 1:30)
- **Visual:** Split screen showing Python code in VS Code (`01_data_cleaning_and_eda.py`) and execution in Terminal.
- **Speaker (Ranjan Maiti):**
  > "Starting with the data engineering pipeline in Python:
  > First, we performed thorough exploratory data analysis and data cleansing. We eliminated three constant zero-variance attributes — EmployeeCount, Over18, and StandardHours.
  > 
  > Next, using Tukey's Interquartile Range method, we detected 114 salary outliers earning above $16,581. Our audit confirmed these are legitimate executive compensation packages for Managers and Research Directors, which we flagged and preserved.
  > 
  > Finally, we transformed the raw data into an enterprise **Star Schema**, generating three dimension tables — Department, Job Role, and Education — along with Dim_Employee and Fact_Attrition, fully indexed and loaded into Oracle SQL."

#### Scene 3: Oracle SQL Advanced Analytics & PL/SQL Stored Procedures (1:30 - 2:30)
- **Visual:** Terminal or SQL Developer showing `03_oracle_attrition_queries.sql` and `query_execution_results.txt`.
- **Speaker (Ranjan Maiti):**
  > "Moving to the database tier in Oracle SQL:
  > We implemented advanced analytical queries utilizing window functions such as `RANK()`, `DENSE_RANK()`, and `RATIO_TO_REPORT()`.
  > 
  > As demonstrated in our spooled output, the company-wide headcount reconciles perfectly at 1,470 employees with 237 voluntary leavers, yielding an exact **16.12% attrition rate**.
  > 
  > Furthermore, we authored an automated PL/SQL procedure — `PRC_CHECK_ATTRITION_ALERT` — which automatically audits departments against an organizational threshold of 15%. When executed, it immediately flags Sales at 20.63% and Human Resources at 19.05% as high-risk breach zones."

#### Scene 4: Power BI Interactive Dashboard Walkthrough (2:30 - 3:45)
- **Visual:** Power BI Desktop showing the interactive Dashboard (`visual_outputs/dashboard_overview.png`). Click the **Department** slicer, select 'Sales', then click the **Gender** slicer.
- **Speaker (Ranjan Maiti):**
  > "Now, let's explore our executive Power BI Dashboard.
  > Across the top, dynamic KPI cards present real-time totals: Total Headcount of 1,470, Active Workforce of 1,233, Attrition Count of 237, and an Overall Attrition Rate of 16.12%.
  > 
  > Our analysis highlights three critical insights:
  > 1. **OverTime Burnout:** Employees working regular overtime experience an attrition rate of **30.53%**, compared to only 10.44% for non-overtime staff — nearly a three-fold increase.
  > 2. **Early Tenure Flight Risk:** Over 43% of all resignations occur within the first two years of employment, where the attrition rate spikes to **29.82%**.
  > 3. **Role-Specific Vulnerability:** Sales Representatives face an attrition rate of **39.76%**, driven by low entry-level compensation.
  > 
  > Notice as I toggle the Department and Gender slicers, all KPI cards and charts respond dynamically with zero lag."

#### Scene 5: Test Cases Sign-off & Conclusion (3:45 - 4:15)
- **Visual:** Test cases summary slide showing 4 PASSED test cases (`docs/05_test_cases_and_verification.md`).
- **Speaker (Ranjan Maiti):**
  > "All key test cases mandated in the project specification — including missing tenure fallback, salary outlier integrity, and zero-division protection for single-employee departments — have achieved 100% automated test pass status.
  > 
  > By capping overtime and introducing a 180-day new-hire mentorship program, we project the organization can retain 59 additional employees per year, yielding an estimated net annual cost savings of **$1.47 million**.
  > 
  > All source code, SQL DDL scripts, documentation, and Power BI guides are available in my GitHub repository. Thank you very much for your time and guidance!"

---

### Recording Tips for Ranjan:
1. Speak clearly and maintain an enthusiastic, confident tone.
2. If using OBS Studio or Windows Game Bar (`Win + G`) or Mac QuickTime (`Cmd + Shift + 5`), record full HD 1080p.
3. Save the resulting MP4 file as `2500321540146_RanjanMaiti_DemoVideo.mp4`.
4. Upload to Google Drive (set access to "Anyone with the link can view") or YouTube (set to "Unlisted"), and paste the URL into `links.txt`.
