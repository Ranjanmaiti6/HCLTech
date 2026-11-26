# Power BI Dashboard Build Guide
## Project 10: Employee Attrition Analysis
**Student:** Ranjan Maiti | **Roll No:** 2500321540146  
**Institution:** HCLTech Career Shaper (2nd-Year B.Tech)  
**Target Dashboard:** `Employee_Attrition_Dashboard.pbix`  
**Reference Screenshot:** `dashboard/dashboard_screenshot.png`  

---

### Environment & Platform Notice
> **Important Note:** Power BI Desktop is exclusively available on Microsoft Windows. In macOS / Linux environments where Power BI Desktop cannot be run locally, we provide:
> 1. Complete verified cleaned data source (`dataset/employee_attrition_cleaned.csv`).
> 2. Full set of production DAX measures (`powerbi/dax_measures.txt`).
> 3. High-resolution visual proof of the finished dashboard (`dashboard/dashboard_screenshot.png`).
> 4. Exact click-by-click instructions below to create, configure, and save `Employee_Attrition_Dashboard.pbix` on any Windows PC.

---

### Step-by-Step Build Instructions

#### Step 1: Ingest Cleaned Dataset
1. Launch **Power BI Desktop** on Windows.
2. On the ribbon, select **Get Data** > **Text/CSV**.
3. Select `dataset/employee_attrition_cleaned.csv`.
4. Click **Load**. (Table name: `EMPLOYEE_ATTRITION`).

#### Step 2: Create Central Measures Table
1. In the **Home** tab, click **Enter Data**.
2. Name the table `_Measures` and click **Load**.
3. Right-click `_Measures` > **New Measure**.
4. Copy-paste the DAX formulas from [dax_measures.txt](file:///Users/ranjanmaiti/Desktop/HCL%20PROJECT/2500321540146_RanjanMaiti_EmployeeAttritionAnalysis%202/powerbi/dax_measures.txt):
   - `Total Employees = COUNTROWS('EMPLOYEE_ATTRITION')`
   - `Active Employees = CALCULATE(COUNTROWS('EMPLOYEE_ATTRITION'), 'EMPLOYEE_ATTRITION'[Attrition] = "No")`
   - `Employees Who Left = CALCULATE(COUNTROWS('EMPLOYEE_ATTRITION'), 'EMPLOYEE_ATTRITION'[Attrition] = "Yes")`
   - `Overall Attrition Rate % = DIVIDE([Employees Who Left], [Total Employees], 0) * 100`
   - `Average Employee Age = ROUND(AVERAGE('EMPLOYEE_ATTRITION'[Age]), 1)`

#### Step 3: Page Setup & Corporate Dark Navy Styling
1. Click on the canvas, open the **Format Page** pane.
2. Under **Canvas Background**, set Color to **Dark Navy** (`#0B192C` or `#1E2A38`), transparency `0%`.
3. Insert a **Text Box** at the top:
   - Title: **EMPLOYEE ATTRITION ANALYSIS** (Font: Segoe UI, Size: 22, Bold, White)
   - Subtitle: **HR Workforce Intelligence Dashboard** (Size: 12, Light Slate `#A0AEC0`)

#### Step 4: Build the 5 Top KPI Cards
Insert 5 **Card** visuals across the top row (white background card containers, dark navy labels):
1. **Total Employees**: Card field = `[Total Employees]` -> Displays `1,470`
2. **Active Employees**: Card field = `[Active Employees]` -> Displays `1,233`
3. **Employees Who Left**: Card field = `[Employees Who Left]` -> Displays `237`
4. **Attrition Rate**: Card field = `[Overall Attrition Rate %]` -> Displays `16.1%`
5. **Average Employee Age**: Card field = `[Average Employee Age]` -> Displays `36.9`

#### Step 5: Build the 6 Analytical Charts
1. **Attrition by Department** (Clustered Bar Chart):
   - Y-Axis: `Department`
   - X-Axis: `[Overall Attrition Rate %]`
   - Data Labels: On (Displays 20.6% for Sales, 19.0% for HR, 13.8% for R&D)
2. **Attrition by Gender** (Clustered Column Chart):
   - X-Axis: `Gender`
   - Y-Axis: `[Overall Attrition Rate %]`
   - Data Labels: On (Displays 17.0% for Male, 14.8% for Female)
3. **Attrition by Age Group** (Clustered Column Chart):
   - X-Axis: `AgeGroup` (`18-29`, `30-39`, `40-49`, `50+`)
   - Y-Axis: `[Overall Attrition Rate %]`
   - Data Labels: On (Highlights 18-29 peak at 27.9%)
4. **Attrition by Salary Band** (Clustered Column Chart):
   - X-Axis: `SalaryBand` (`Low (<3.5k)`, `Mid (3.5k-7k)`, `High (7k-12k)`, `Executive (12k+)`)
   - Y-Axis: `[Overall Attrition Rate %]`
   - Data Labels: On (Highlights Low salary peak at 27.1%)
5. **Attrition by Years at Company** (Clustered Column Chart):
   - X-Axis: `TenureBand` (`0-2 Years`, `3-5 Years`, `6-10 Years`, `10+ Years`)
   - Y-Axis: `[Overall Attrition Rate %]`
   - Data Labels: On (Highlights 0-2 Years flight window at 29.8%)
6. **Overtime vs Attrition** (Donut / Bar Chart):
   - Legend / X-Axis: `OverTime` (`Yes`, `No`)
   - Values: `[Overall Attrition Rate %]`
   - Data Labels: On (Shows 30.5% for Overtime vs 10.4% for Non-Overtime)

#### Step 6: Add Interactive Slicers
Insert 3 Slicer visuals in the filter area:
- **Department**: Single/Multi-select dropdown
- **Gender**: Single/Multi-select dropdown
- **Job Role**: Dropdown

#### Step 7: Save File
- Click **File** > **Save As** > Save as `powerbi/Employee_Attrition_Dashboard.pbix`.
