# Power BI Dashboard Build Guide
## Project 10: Employee Attrition Analysis & Workforce Intelligence
**Author:** Ranjan Maiti  
**Roll No:** 2500321540146  
**Institution / Program:** HCLTech Career Shaper  
**Target File:** `EmployeeAttritionAnalysis.pbix`

---

### 1. Overview & Data Import
This guide provides complete instructions to construct the enterprise HR Attrition Power BI Dashboard from either the cleaned CSV files (`data/processed/`) or via direct Oracle SQL connection.

#### Data Source Options:
- **Option A (Local CSV - Recommended for Offline Submission):**
  1. Open **Power BI Desktop**.
  2. Click **Get Data** → **Text/CSV**.
  3. Load the following files from `data/processed/`:
     - `fact_attrition.csv` (Renamed to `Fact_Attrition`)
     - `dim_department.csv` (Renamed to `Dim_Department`)
     - `dim_job_role.csv` (Renamed to `Dim_JobRole`)
     - `dim_education.csv` (Renamed to `Dim_Education`)
     - `dim_employee.csv` (Renamed to `Dim_Employee`)
- **Option B (Direct Oracle Database / SQL View):**
  1. Click **Get Data** → **Oracle Database**.
  2. Enter Server: `localhost:1521/ORCL` and select `VW_HR_ATTRITION_MASTER`.

---

### 2. Star Schema Data Modeling & Relationships
Navigate to the **Model View** in Power BI Desktop and configure the following 1-to-Many (`1:*`) Single Cross-filter relationships:

```
      +------------------+
      |  Dim_Department  |
      +--------+---------+
               | 1
               |
               | * (DepartmentID)
+--------------+-------------+             +---------------+
|        Fact_Attrition      | * -------- 1|  Dim_JobRole  |
+--------------+-------------+ (JobRoleID) +---------------+
               | * (EducationKey)
               |
               | 1
      +--------+---------+
      |  Dim_Education   |
      +------------------+
               |
               | (EmployeeNumber) 1 to 1 / 1 to *
      +--------+---------+
      |   Dim_Employee   |
      +------------------+
```

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Dim_Department` | `DepartmentID` | `Fact_Attrition` | `DepartmentID` | One to Many (`1:*`) | Single |
| `Dim_JobRole` | `JobRoleID` | `Fact_Attrition` | `JobRoleID` | One to Many (`1:*`) | Single |
| `Dim_Education` | `EducationKey` | `Fact_Attrition` | `EducationKey` | One to Many (`1:*`) | Single |
| `Dim_Employee` | `EmployeeNumber` | `Fact_Attrition` | `EmployeeNumber` | One to One (`1:1`) | Both / Single |

---

### 3. Core DAX Measures Table Setup
Create a dedicated table named `_Measures` using **Enter Data** and paste the following DAX calculations:

#### 1. Headcount & Attrition KPIs:
```dax
Total Employees = COUNTROWS(Fact_Attrition)
```
```dax
Attrition Count = SUM(Fact_Attrition[Attrition_Flag])
```
```dax
Active Employees = [Total Employees] - [Attrition Count]
```
```dax
Attrition Rate % = 
DIVIDE([Attrition Count], [Total Employees], 0) * 100
```
```dax
Retention Rate % = 
100 - [Attrition Rate %]
```

#### 2. Compensation & Tenure Metrics:
```dax
Average Monthly Salary = AVERAGE(Fact_Attrition[MonthlyIncome])
```
```dax
Average Tenure Years = AVERAGE(Fact_Attrition[YearsAtCompany])
```
```dax
OverTime Attrition Rate % = 
CALCULATE(
    [Attrition Rate %],
    Fact_Attrition[OverTime] = "Yes"
)
```
```dax
Non-OverTime Attrition Rate % = 
CALCULATE(
    [Attrition Rate %],
    Fact_Attrition[OverTime] = "No"
)
```
```dax
OverTime Impact Delta = [OverTime Attrition Rate %] - [Non-OverTime Attrition Rate %]
```

#### 3. Dynamic Card Title:
```dax
Dynamic Filter Summary = 
"Filtered Attrition View: " & 
SELECTEDVALUE(Dim_Department[DepartmentName], "All Departments") & 
" | " & 
SELECTEDVALUE(Dim_Employee[Gender], "All Genders")
```

---

### 4. Canvas Layout & Visual Configuration (16:9 Canvas)

#### Header Banner:
- **Title Text Box:** "HCLTech Project 10: Enterprise Employee Attrition & Retention Intelligence"
- **Subtitle:** "Candidate: Ranjan Maiti | Roll No: 2500321540146 | Dataset: IBM HR Analytics"
- **Slicers (Top Ribbon):**
  1. **Department Slicer:** `Dim_Department[DepartmentName]` (Dropdown / Tiles)
  2. **Gender Slicer:** `Dim_Employee[Gender]` (Horizontal Buttons)
  3. **Tenure Band Slicer:** `Fact_Attrition[TenureBand]` (Tile selection)
  4. **OverTime Slicer:** `Fact_Attrition[OverTime]` (Tile selection)

#### Row 1: Executive KPI Cards (Across the Top)
1. **Card 1 - Total Headcount:** `[Total Employees]` (Display Value: `1,470`)
2. **Card 2 - Active Workforce:** `[Active Employees]` (Display Value: `1,233` - Accent Green)
3. **Card 3 - Total Leavers:** `[Attrition Count]` (Display Value: `237` - Alert Red)
4. **Card 4 - Overall Attrition Rate:** `[Attrition Rate %]` (Display Value: `16.12%` - Formatted `0.00%`)
5. **Card 5 - OverTime Risk Rate:** `[OverTime Attrition Rate %]` (Display Value: `30.53%`)

#### Row 2: Analytical Visualizations (Middle Section)
- **Visual 1 (Clustered Column Chart):** *Attrition Rate & Headcount by Department*
  - **X-axis:** `Dim_Department[DepartmentName]`
  - **Y-axis:** `[Attrition Rate %]`
  - **Tooltips:** `[Total Employees]`, `[Attrition Count]`, `[Average Monthly Salary]`
  - **Data Labels:** ON (Formatted to 1 decimal place)
- **Visual 2 (Clustered Bar Chart):** *Attrition by Job Role with Department Drill-Down*
  - **Y-axis:** `Dim_JobRole[JobRoleName]`
  - **X-axis:** `[Attrition Rate %]`
  - **Hierarchy Drill-down:** `Dim_Department[DepartmentName]` → `Dim_JobRole[JobRoleName]`

#### Row 3: Matrix & Correlation Drivers (Bottom Section)
- **Visual 3 (Matrix Heatmap):** *Tenure Band vs Salary Band Risk Matrix*
  - **Rows:** `Fact_Attrition[SalaryBand]`
  - **Columns:** `Fact_Attrition[TenureBand]`
  - **Values:** `[Attrition Rate %]`
  - **Conditional Formatting:** Background color gradient from Light Yellow (`#fff7bc`) to Dark Crimson (`#d73027`).
- **Visual 4 (Donut Chart):** *Turnover Breakdown by Job Satisfaction*
  - **Legend:** `JobSatisfactionLabel` (Low, Medium, High, Very High)
  - **Values:** `[Attrition Count]`
- **Visual 5 (Decomposition Tree / Key Influencers):**
  - **Analyze:** `Attrition_Flag`
  - **Explain by:** `OverTime`, `TenureBand`, `SalaryBand`, `MaritalStatus`, `BusinessTravel`

---

### 5. Acceptance Verification Checklist
- [x] **Department Attrition Rate Verified:** Sales = 20.63%, HR = 19.05%, R&D = 13.84%.
- [x] **Tenure Attrition Rate Verified:** 0-2 Years = 29.82%, 10+ Years = 8.13%.
- [x] **Interactive Slicers Tested:** Department and Gender slicers dynamically filter all visual cards.
- [x] **Hierarchy Drill-down Tested:** Clicking into Sales drills down to Sales Representative (39.8%) and Sales Executive (17.5%).
- [x] **Data Reconciliation:** Total row count equals 1,470; leavers equal 237; attrition rate equals 16.12%.
