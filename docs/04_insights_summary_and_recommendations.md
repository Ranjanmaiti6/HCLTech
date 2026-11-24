# Project 10: Employee Attrition Analysis
## Document 04: Executive Insights Summary & Business Recommendations
**Candidate Name:** Ranjan Maiti  
**Candidate Roll No:** 2500321540146  
**Institution / Program:** HCLTech Career Shaper  
**Target Audience:** HR Leadership, CHRO, and Department Heads  

---

### 1. Executive Summary
Analysis of 1,470 employee profiles reveals an overall organizational attrition rate of **16.12%** (237 voluntary separations). While 16% appears manageable on aggregate, deep segmentation across tenure, compensation tiers, and working conditions reveals critical risk pockets reaching nearly **40%**. 

Turnover is primarily concentrated in frontline sales roles, new hires within their first 24 months, and staff subjected to mandatory overtime.

---

### 2. Top 3 Strategic Insights Supported by Visuals

#### Insight 1: OverTime is the #1 Predictive Multiplier of Turnover (Nearly 3x Risk)
*Supported by Visual:* `visual_outputs/dashboard_overview.png` (Panel 4) & `visual_outputs/satisfaction_vs_attrition.png`
- **Quantitative Finding:** Employees who work regular overtime suffer an attrition rate of **30.53%** (127 leavers out of 416 staff), compared to just **10.44%** (110 leavers out of 1,054 staff) among those without overtime obligations.
- **Combined Factor:** When frequent business travel is combined with overtime, the attrition rate surges to **40.21%**.
- **Root Cause:** Analysis of work-life balance scores reveals that staff in this bracket report an average score of only 2.65/4.0. The organization is suffering chronic burnout-induced talent loss rather than voluntary disengagement.

#### Insight 2: The "Two-Year Flight Window" (43.0% of All Leavers Resign in Years 0-2)
*Supported by Visual:* `visual_outputs/dashboard_overview.png` (Panel 3) & `visual_outputs/attrition_by_tenure_salary.png`
- **Quantitative Finding:** Employees with **0-2 years of tenure** exhibit a staggering **29.82% attrition rate** (102 leavers out of 342 staff). In contrast, staff with 10+ years at the company exhibit only an **8.13% attrition rate**.
- **Disproportionate Impact:** While employees in their first 2 years constitute only 23.3% of the total headcount, they account for **43.04% of all resignations**.
- **Root Cause:** Exit data indicates a steep drop in satisfaction during the transition from the initial honeymoon period into independent execution, highlighting inadequate onboarding, unclear promotion paths, and mentor disengagement.

#### Insight 3: Frontline Sales Roles Face an Attrition Crisis (39.8% Turnover)
*Supported by Visual:* `visual_outputs/attrition_by_department.png` & `visual_outputs/dashboard_overview.png` (Panel 1)
- **Quantitative Finding:** The **Sales Department** has the highest overall department attrition at **20.63%**, followed closely by **Human Resources at 19.05%**, whereas **R&D** maintains a relatively stable **13.84%**.
- **Role-Level Drilldown:** Inside Sales, **Sales Representatives** suffer an alarming **39.76% attrition rate** (33 leavers out of 83 staff). 
- **Compensation Disparity:** Sales Representatives earn an average of only **\$2,626/month**, falling squarely into the lowest compensation tier, where turnover across the firm is 27.12%.

---

### 3. Cross-Tabulation Risk Matrix: Tenure Band vs Salary Band

| Salary Band \ Tenure Band | 0-2 Years (High Risk) | 3-5 Years | 6-10 Years | 10+ Years (Stable) |
| :--- | :--- | :--- | :--- | :--- |
| **Low (<$3.5k)** | **38.4% (Critical)** | 23.1% | 18.2% | 11.1% |
| **Mid ($3.5k-$7k)** | 22.5% | 11.8% | 8.9% | 6.8% |
| **High ($7k-$12k)** | 16.7% | 14.3% | 15.2% | 13.6% |
| **Executive ($12k+)**| 9.1% | 7.7% | 5.3% | **4.9% (Safest)** |

> **Key Observation:** The single highest flight-risk cohort in the entire company consists of **entry-level staff in their first 2 years earning below \$3,500/month**, where attrition reaches **38.4%**.

---

### 4. Actionable Business Recommendations & ROI

#### Recommendation 1: Implement an "OverTime Cap & Workload Balancing" Policy
- **Action:** Cap consecutive overtime weeks to a maximum of 2 per month for any individual contributor. Implement cross-training in laboratory technician and sales operations roles to distribute peak workloads.
- **Projected Impact:** Reducing overtime-related turnover by just 30% saves 38 separations per year.

#### Recommendation 2: Launch a 180-Day "New Hire Concierge & Mentorship" Program
- **Action:** Pair all new hires with senior colleagues outside their direct reporting hierarchy for their first 6 months. Establish mandatory milestone check-ins at 30, 90, and 180 days.
- **Projected Impact:** Lowering 0-2 year tenure attrition from 29.8% down to 20% retains approximately 34 high-potential junior professionals annually.

#### Recommendation 3: Sales Representative Career Progression & Commission Restructuring
- **Action:** Establish a structured 12-month ladder enabling top-performing Sales Representatives to progress to Junior Account Executives, providing an earlier financial uplift without requiring a multi-year wait.
- **Projected Impact:** Reduces Sales Representative turnover by an estimated 15-20 percentage points.

#### Financial ROI Estimate:
- Average cost of replacing an employee: **\$25,000** (conservative 50% of annual salary).
- Total annual leavers: **237**.
- Target reduction of 25% (59 fewer resignations per year):
  $$\text{Net Annual Savings} = 59 \times \$25,000 = \mathbf{\$1,475,000 \text{ / year}}$$
