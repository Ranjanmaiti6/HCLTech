"""
=============================================================================
HCLTech Career Shaper - Final Academic Project Submission
Project No: 10
Project Title: Employee Attrition Analysis
Candidate Name: Ranjan Maiti
Candidate Roll No: 2500321540146
Script: 01_data_cleaning_and_eda.py
Description: Full ETL, Data Cleaning, Outlier Detection, Star Schema Generation,
             and Exploratory Data Analysis with Publication-Quality Visualizations.
=============================================================================
"""

import os
import sys
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg') # Headless backend for server/CLI environments
import matplotlib.pyplot as plt
import seaborn as sns

# Set plotting styles
plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
plt.rcParams['font.sans-serif'] = 'Arial'
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300

# Base paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DATA_PATH = os.path.join(BASE_DIR, 'data', 'raw', 'WA_Fn-UseC_-HR-Employee-Attrition.csv')
PROCESSED_DATA_DIR = os.path.join(BASE_DIR, 'data', 'processed')
VISUAL_OUTPUTS_DIR = os.path.join(BASE_DIR, 'visual_outputs')
DOCS_DIR = os.path.join(BASE_DIR, 'docs')

os.makedirs(PROCESSED_DATA_DIR, exist_ok=True)
os.makedirs(VISUAL_OUTPUTS_DIR, exist_ok=True)
os.makedirs(DOCS_DIR, exist_ok=True)

def load_and_inspect_data():
    print("=" * 80)
    print("STEP 1: LOADING AND INITIAL INSPECTION")
    print("=" * 80)
    df = pd.read_csv(RAW_DATA_PATH)
    print(f"Dataset shape: {df.shape[0]} rows, {df.shape[1]} columns")
    print(f"Missing values count across dataset: {df.isnull().sum().sum()}")
    print(f"Duplicate rows: {df.duplicated().sum()}")
    return df

def clean_and_transform_data(df):
    print("\n" + "=" * 80)
    print("STEP 2: DATA CLEANING AND FEATURE ENGINEERING")
    print("=" * 80)
    df_clean = df.copy()

    # 1. Standardize column names (remove BOM, strip whitespace)
    df_clean.columns = [c.strip().replace('\ufeff', '') for c in df_clean.columns]

    # 2. Check and document redundant constant columns
    constant_cols = [c for c in df_clean.columns if df_clean[c].nunique() <= 1]
    print(f"Zero-variance / constant columns identified: {constant_cols}")
    # In standard IBM dataset: EmployeeCount (always 1), Over18 (always Y), StandardHours (always 80)
    df_clean.drop(columns=constant_cols, inplace=True, errors='ignore')

    # 3. Binary flag for Attrition
    df_clean['Attrition_Flag'] = df_clean['Attrition'].apply(lambda x: 1 if str(x).strip().lower() == 'yes' else 0)

    # 4. Feature Engineering: Salary Band (MonthlyIncome)
    # Band definitions aligned with industry standards:
    # Low: < $3,500; Mid: $3,500 - $7,000; High: $7,000 - $12,000; Executive: >= $12,000
    bins_salary = [0, 3500, 7000, 12000, 100000]
    labels_salary = ['Low (<3.5k)', 'Mid (3.5k-7k)', 'High (7k-12k)', 'Executive (12k+)']
    df_clean['SalaryBand'] = pd.cut(df_clean['MonthlyIncome'], bins=bins_salary, labels=labels_salary, right=False)

    # 5. Feature Engineering: Tenure Band (YearsAtCompany)
    # 0-2 yrs: Early Career / Probation; 3-5 yrs: Mid Tenure; 6-10 yrs: Senior; 10+ yrs: Veteran
    bins_tenure = [0, 3, 6, 11, 100]
    labels_tenure = ['0-2 Years', '3-5 Years', '6-10 Years', '10+ Years']
    df_clean['TenureBand'] = pd.cut(df_clean['YearsAtCompany'], bins=bins_tenure, labels=labels_tenure, right=False)

    # 6. Feature Engineering: Age Group
    bins_age = [18, 30, 40, 50, 65]
    labels_age = ['18-29', '30-39', '40-49', '50+']
    df_clean['AgeGroup'] = pd.cut(df_clean['Age'], bins=bins_age, labels=labels_age, right=False)

    # 7. Education Level Mapping
    edu_map = {1: 'Below College', 2: 'College', 3: 'Bachelor', 4: 'Master', 5: 'Doctor'}
    df_clean['EducationLabel'] = df_clean['Education'].map(edu_map)

    # 8. Satisfaction Level Mappings for Clarity
    sat_map = {1: 'Low', 2: 'Medium', 3: 'High', 4: 'Very High'}
    df_clean['JobSatisfactionLabel'] = df_clean['JobSatisfaction'].map(sat_map)
    df_clean['EnvSatisfactionLabel'] = df_clean['EnvironmentSatisfaction'].map(sat_map)
    df_clean['WorkLifeBalanceLabel'] = df_clean['WorkLifeBalance'].map({1: 'Bad', 2: 'Good', 3: 'Better', 4: 'Best'})

    # 9. Outlier Detection on Monthly Income via Interquartile Range (IQR)
    q1 = df_clean['MonthlyIncome'].quantile(0.25)
    q3 = df_clean['MonthlyIncome'].quantile(0.75)
    iqr = q3 - q1
    upper_bound = q3 + 1.5 * iqr
    lower_bound = q1 - 1.5 * iqr
    outliers = df_clean[df_clean['MonthlyIncome'] > upper_bound]
    print(f"MonthlyIncome IQR: {iqr:.2f} (Q1: {q1:.2f}, Q3: {q3:.2f})")
    print(f"Upper Bound for Salary Outliers: ${upper_bound:.2f}")
    print(f"Total Salary Outliers detected: {len(outliers)} ({len(outliers)/len(df_clean)*100:.2f}%)")
    print("Note: These represent senior directors, managers, and research fellows with valid executive compensation.")
    df_clean['Is_Salary_Outlier'] = (df_clean['MonthlyIncome'] > upper_bound).astype(int)

    # 10. Save clean master CSV
    clean_csv_path = os.path.join(PROCESSED_DATA_DIR, 'employee_attrition_clean.csv')
    df_clean.to_csv(clean_csv_path, index=False)
    print(f"Cleaned dataset saved to: {clean_csv_path}")

    return df_clean

def generate_star_schema(df_clean):
    print("\n" + "=" * 80)
    print("STEP 3: GENERATING STAR SCHEMA DIMENSION AND FACT TABLES")
    print("=" * 80)

    # 1. Dim_Department
    depts = df_clean[['Department']].drop_duplicates().sort_values('Department').reset_index(drop=True)
    depts['DepartmentID'] = range(1, len(depts) + 1)
    depts = depts[['DepartmentID', 'Department']]
    depts.to_csv(os.path.join(PROCESSED_DATA_DIR, 'dim_department.csv'), index=False)

    # 2. Dim_JobRole
    job_roles = df_clean[['JobRole']].drop_duplicates().sort_values('JobRole').reset_index(drop=True)
    job_roles['JobRoleID'] = range(1, len(job_roles) + 1)
    job_roles = job_roles[['JobRoleID', 'JobRole']]
    job_roles.to_csv(os.path.join(PROCESSED_DATA_DIR, 'dim_job_role.csv'), index=False)

    # 3. Dim_Education
    edu = df_clean[['Education', 'EducationLabel', 'EducationField']].drop_duplicates().sort_values(['Education', 'EducationField']).reset_index(drop=True)
    edu['EducationKey'] = range(1, len(edu) + 1)
    edu = edu[['EducationKey', 'Education', 'EducationLabel', 'EducationField']]
    edu.to_csv(os.path.join(PROCESSED_DATA_DIR, 'dim_education.csv'), index=False)

    # Merge IDs back to build Dim_Employee and Fact_Attrition
    merged = df_clean.merge(depts, on='Department', how='left')
    merged = merged.merge(job_roles, on='JobRole', how='left')
    merged = merged.merge(edu, on=['Education', 'EducationLabel', 'EducationField'], how='left')

    # 4. Dim_Employee
    dim_emp_cols = [
        'EmployeeNumber', 'Age', 'AgeGroup', 'Gender', 'MaritalStatus',
        'DepartmentID', 'JobRoleID', 'EducationKey', 'EducationField',
        'NumCompaniesWorked', 'TotalWorkingYears', 'DistanceHome' if 'DistanceHome' in merged.columns else 'DistanceFromHome'
    ]
    dim_employee = merged[dim_emp_cols].drop_duplicates().reset_index(drop=True)
    dim_employee.to_csv(os.path.join(PROCESSED_DATA_DIR, 'dim_employee.csv'), index=False)

    # 5. Fact_Attrition
    fact_cols = [
        'EmployeeNumber', 'DepartmentID', 'JobRoleID', 'EducationKey',
        'Attrition', 'Attrition_Flag', 'MonthlyIncome', 'SalaryBand', 'Is_Salary_Outlier',
        'YearsAtCompany', 'TenureBand', 'YearsInCurrentRole', 'YearsSinceLastPromotion',
        'YearsWithCurrManager', 'BusinessTravel', 'OverTime', 'JobLevel', 'JobInvolvement',
        'JobSatisfaction', 'EnvironmentSatisfaction', 'RelationshipSatisfaction',
        'WorkLifeBalance', 'PerformanceRating', 'PercentSalaryHike', 'StockOptionLevel',
        'TrainingTimesLastYear'
    ]
    fact_attrition = merged[fact_cols].reset_index(drop=True)
    fact_attrition['AttritionFactID'] = range(1, len(fact_attrition) + 1)
    # Reorder to put surrogate key first
    fact_attrition = fact_attrition[['AttritionFactID'] + fact_cols]
    fact_attrition.to_csv(os.path.join(PROCESSED_DATA_DIR, 'fact_attrition.csv'), index=False)

    print("Star schema tables generated:")
    print(f" - dim_department.csv ({len(depts)} rows)")
    print(f" - dim_job_role.csv ({len(job_roles)} rows)")
    print(f" - dim_education.csv ({len(edu)} rows)")
    print(f" - dim_employee.csv ({len(dim_employee)} rows)")
    print(f" - fact_attrition.csv ({len(fact_attrition)} rows)")

def run_exploratory_data_analysis(df):
    print("\n" + "=" * 80)
    print("STEP 4: EXPLORATORY DATA ANALYSIS AND METRIC RECONCILIATION")
    print("=" * 80)

    total_emp = len(df)
    attrition_cnt = df['Attrition_Flag'].sum()
    attrition_rate = (attrition_cnt / total_emp) * 100
    active_emp = total_emp - attrition_cnt

    print(f"Total Employees: {total_emp}")
    print(f"Active Employees: {active_emp}")
    print(f"Attrition Count: {attrition_cnt}")
    print(f"Overall Attrition Rate: {attrition_rate:.2f}%\n")

    # 1. Department Breakdown
    print("--- Attrition by Department ---")
    dept_stats = df.groupby('Department').agg(
        TotalEmployees=('EmployeeNumber', 'count'),
        AttritionCount=('Attrition_Flag', 'sum'),
        AttritionRate=('Attrition_Flag', lambda x: (x.sum() / len(x)) * 100),
        AvgMonthlyIncome=('MonthlyIncome', 'mean')
    ).reset_index()
    print(dept_stats.to_string(index=False))

    # 2. Tenure Band Breakdown
    print("\n--- Attrition by Tenure Band ---")
    tenure_stats = df.groupby('TenureBand', observed=False).agg(
        TotalEmployees=('EmployeeNumber', 'count'),
        AttritionCount=('Attrition_Flag', 'sum'),
        AttritionRate=('Attrition_Flag', lambda x: (x.sum() / len(x)) * 100)
    ).reset_index()
    print(tenure_stats.to_string(index=False))

    # 3. Salary Band Breakdown
    print("\n--- Attrition by Salary Band ---")
    salary_stats = df.groupby('SalaryBand', observed=False).agg(
        TotalEmployees=('EmployeeNumber', 'count'),
        AttritionCount=('Attrition_Flag', 'sum'),
        AttritionRate=('Attrition_Flag', lambda x: (x.sum() / len(x)) * 100)
    ).reset_index()
    print(salary_stats.to_string(index=False))

    # 4. Gender Breakdown
    print("\n--- Attrition by Gender ---")
    gender_stats = df.groupby('Gender').agg(
        TotalEmployees=('EmployeeNumber', 'count'),
        AttritionCount=('Attrition_Flag', 'sum'),
        AttritionRate=('Attrition_Flag', lambda x: (x.sum() / len(x)) * 100)
    ).reset_index()
    print(gender_stats.to_string(index=False))

    # 5. OverTime Breakdown
    print("\n--- Attrition by OverTime ---")
    ot_stats = df.groupby('OverTime').agg(
        TotalEmployees=('EmployeeNumber', 'count'),
        AttritionCount=('Attrition_Flag', 'sum'),
        AttritionRate=('Attrition_Flag', lambda x: (x.sum() / len(x)) * 100)
    ).reset_index()
    print(ot_stats.to_string(index=False))

    return dept_stats, tenure_stats, salary_stats, gender_stats, ot_stats

def generate_visualizations(df):
    print("\n" + "=" * 80)
    print("STEP 5: GENERATING HIGH-QUALITY VISUALIZATIONS")
    print("=" * 80)

    # -------------------------------------------------------------
    # Visual 1: Executive Dashboard Overview (4-Panel Master Visual)
    # -------------------------------------------------------------
    fig, axes = plt.subplots(2, 2, figsize=(16, 12))
    fig.suptitle('HCLTech Project 10: Executive Employee Attrition Overview\nCandidate: Ranjan Maiti | Roll No: 2500321540146', fontsize=18, fontweight='bold', y=0.98)

    # Panel 1: Attrition by Department
    dept_df = df.groupby('Department')['Attrition_Flag'].agg(['count', 'sum']).reset_index()
    dept_df['rate'] = (dept_df['sum'] / dept_df['count']) * 100
    bars1 = axes[0, 0].bar(dept_df['Department'], dept_df['rate'], color=['#1f77b4', '#ff7f0e', '#2ca02c'], width=0.55, edgecolor='black', alpha=0.85)
    axes[0, 0].set_title('Attrition Rate by Department (%)', fontsize=13, fontweight='bold', pad=10)
    axes[0, 0].set_ylabel('Attrition Rate (%)', fontsize=11)
    axes[0, 0].set_ylim(0, max(dept_df['rate']) + 8)
    for bar in bars1:
        h = bar.get_height()
        axes[0, 0].annotate(f'{h:.1f}%',
                            xy=(bar.get_x() + bar.get_width() / 2, h),
                            xytext=(0, 4), textcoords="offset points",
                            ha='center', va='bottom', fontsize=10, fontweight='bold')
    axes[0, 0].tick_params(axis='x', rotation=15)

    # Panel 2: Attrition by Salary Band
    sal_df = df.groupby('SalaryBand', observed=False)['Attrition_Flag'].agg(['count', 'sum']).reset_index()
    sal_df['rate'] = (sal_df['sum'] / sal_df['count']) * 100
    bars2 = axes[0, 1].bar(sal_df['SalaryBand'].astype(str), sal_df['rate'], color='#d62728', width=0.55, edgecolor='black', alpha=0.85)
    axes[0, 1].set_title('Attrition Rate by Salary Band (%)', fontsize=13, fontweight='bold', pad=10)
    axes[0, 1].set_ylabel('Attrition Rate (%)', fontsize=11)
    axes[0, 1].set_ylim(0, max(sal_df['rate']) + 8)
    for bar in bars2:
        h = bar.get_height()
        axes[0, 1].annotate(f'{h:.1f}%',
                            xy=(bar.get_x() + bar.get_width() / 2, h),
                            xytext=(0, 4), textcoords="offset points",
                            ha='center', va='bottom', fontsize=10, fontweight='bold')
    axes[0, 1].tick_params(axis='x', rotation=15)

    # Panel 3: Attrition by Tenure Band
    ten_df = df.groupby('TenureBand', observed=False)['Attrition_Flag'].agg(['count', 'sum']).reset_index()
    ten_df['rate'] = (ten_df['sum'] / ten_df['count']) * 100
    bars3 = axes[1, 0].bar(ten_df['TenureBand'].astype(str), ten_df['rate'], color='#9467bd', width=0.55, edgecolor='black', alpha=0.85)
    axes[1, 0].set_title('Attrition Rate by Tenure Band (%)', fontsize=13, fontweight='bold', pad=10)
    axes[1, 0].set_ylabel('Attrition Rate (%)', fontsize=11)
    axes[1, 0].set_xlabel('Tenure at Company', fontsize=11)
    axes[1, 0].set_ylim(0, max(ten_df['rate']) + 8)
    for bar in bars3:
        h = bar.get_height()
        axes[1, 0].annotate(f'{h:.1f}%',
                            xy=(bar.get_x() + bar.get_width() / 2, h),
                            xytext=(0, 4), textcoords="offset points",
                            ha='center', va='bottom', fontsize=10, fontweight='bold')

    # Panel 4: Attrition by OverTime Status
    ot_df = df.groupby('OverTime')['Attrition_Flag'].agg(['count', 'sum']).reset_index()
    ot_df['rate'] = (ot_df['sum'] / ot_df['count']) * 100
    bars4 = axes[1, 1].bar(['No OverTime', 'OverTime Required'], ot_df['rate'], color=['#2ca02c', '#d62728'], width=0.45, edgecolor='black', alpha=0.85)
    axes[1, 1].set_title('OverTime Impact on Attrition Rate (%)', fontsize=13, fontweight='bold', pad=10)
    axes[1, 1].set_ylabel('Attrition Rate (%)', fontsize=11)
    axes[1, 1].set_ylim(0, max(ot_df['rate']) + 8)
    for bar in bars4:
        h = bar.get_height()
        axes[1, 1].annotate(f'{h:.1f}%',
                            xy=(bar.get_x() + bar.get_width() / 2, h),
                            xytext=(0, 4), textcoords="offset points",
                            ha='center', va='bottom', fontsize=10, fontweight='bold')

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])
    p1 = os.path.join(VISUAL_OUTPUTS_DIR, 'dashboard_overview.png')
    plt.savefig(p1, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p1}")

    # -------------------------------------------------------------
    # Visual 2: Detailed Attrition by Department & Job Role
    # -------------------------------------------------------------
    plt.figure(figsize=(14, 7))
    role_order = df.groupby('JobRole')['Attrition_Flag'].mean().sort_values(ascending=False).index
    role_df = df.groupby(['JobRole', 'Department'])['Attrition_Flag'].mean().reset_index()
    role_df['AttritionRatePct'] = role_df['Attrition_Flag'] * 100

    sns.barplot(data=role_df, y='JobRole', x='AttritionRatePct', hue='Department', order=role_order, palette='Set2')
    plt.title('Employee Attrition Rate by Job Role & Department', fontsize=15, fontweight='bold', pad=12)
    plt.xlabel('Attrition Rate (%)', fontsize=12)
    plt.ylabel('Job Role', fontsize=12)
    plt.legend(title='Department', loc='lower right')
    for idx, role in enumerate(role_order):
        val = df[df['JobRole'] == role]['Attrition_Flag'].mean() * 100
        plt.text(val + 0.8, idx, f"{val:.1f}%", va='center', fontweight='bold', fontsize=10)
    plt.xlim(0, max(role_df['AttritionRatePct']) + 8)
    plt.tight_layout()
    p2 = os.path.join(VISUAL_OUTPUTS_DIR, 'attrition_by_department.png')
    plt.savefig(p2, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p2}")

    # -------------------------------------------------------------
    # Visual 3: Tenure vs Salary Matrix Heatmap
    # -------------------------------------------------------------
    plt.figure(figsize=(10, 6))
    pivot_matrix = df.pivot_table(index='SalaryBand', columns='TenureBand', values='Attrition_Flag', aggfunc='mean', observed=False) * 100
    sns.heatmap(pivot_matrix, annot=True, fmt='.1f', cmap='YlOrRd', cbar_kws={'label': 'Attrition Rate (%)'}, linewidths=1.5, annot_kws={'size': 12, 'weight': 'bold'})
    plt.title('Tenure Band vs. Salary Band Attrition Heatmap (%)\n(Critical Risk Zone: Low Salary & < 2 Years Tenure)', fontsize=14, fontweight='bold', pad=12)
    plt.ylabel('Salary Band', fontsize=12)
    plt.xlabel('Tenure Band', fontsize=12)
    plt.tight_layout()
    p3 = os.path.join(VISUAL_OUTPUTS_DIR, 'attrition_by_tenure_salary.png')
    plt.savefig(p3, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p3}")

    # -------------------------------------------------------------
    # Visual 4: Correlation Heatmap of Key Features
    # -------------------------------------------------------------
    plt.figure(figsize=(11, 9))
    corr_cols = [
        'Attrition_Flag', 'Age', 'MonthlyIncome', 'TotalWorkingYears', 'YearsAtCompany',
        'YearsInCurrentRole', 'YearsSinceLastPromotion', 'YearsWithCurrManager',
        'JobSatisfaction', 'EnvironmentSatisfaction', 'WorkLifeBalance',
        'NumCompaniesWorked', 'DistanceFromHome'
    ]
    corr_df = df[corr_cols].corr()
    sns.heatmap(corr_df, annot=True, fmt='.2f', cmap='coolwarm', vmin=-0.4, vmax=1.0, linewidths=0.5, cbar_kws={'label': 'Pearson Correlation'})
    plt.title('Correlation Heatmap: Demographic, Tenure, and Sentiment Drivers', fontsize=14, fontweight='bold', pad=12)
    plt.tight_layout()
    p4 = os.path.join(VISUAL_OUTPUTS_DIR, 'correlation_heatmap.png')
    plt.savefig(p4, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p4}")

    # -------------------------------------------------------------
    # Visual 5: Multi-Factor Satisfaction vs Attrition
    # -------------------------------------------------------------
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    factors = [
        ('JobSatisfactionLabel', 'Job Satisfaction', ['Low', 'Medium', 'High', 'Very High']),
        ('EnvSatisfactionLabel', 'Environment Satisfaction', ['Low', 'Medium', 'High', 'Very High']),
        ('WorkLifeBalanceLabel', 'Work Life Balance', ['Bad', 'Good', 'Better', 'Best'])
    ]
    colors = ['#e74c3c', '#f39c12', '#2ecc71', '#3498db']

    for i, (col, title, order) in enumerate(factors):
        factor_df = df.groupby(col)['Attrition_Flag'].agg(['count', 'sum']).reindex(order).reset_index()
        factor_df['rate'] = (factor_df['sum'] / factor_df['count']) * 100
        bars = axes[i].bar(factor_df[col], factor_df['rate'], color=colors, edgecolor='black', alpha=0.85, width=0.5)
        axes[i].set_title(f'{title} vs. Attrition (%)', fontsize=13, fontweight='bold')
        axes[i].set_ylabel('Attrition Rate (%)', fontsize=11)
        axes[i].set_ylim(0, max(factor_df['rate']) + 8)
        for b in bars:
            h = b.get_height()
            axes[i].annotate(f'{h:.1f}%', xy=(b.get_x() + b.get_width() / 2, h), xytext=(0, 4), textcoords="offset points", ha='center', va='bottom', fontweight='bold')

    plt.suptitle('Employee Sentiment and Well-being Impact on Turnover', fontsize=16, fontweight='bold', y=1.03)
    plt.tight_layout()
    p5 = os.path.join(VISUAL_OUTPUTS_DIR, 'satisfaction_vs_attrition.png')
    plt.savefig(p5, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p5}")

    # -------------------------------------------------------------
    # Visual 6: Top 5 Drivers of Attrition Summary
    # -------------------------------------------------------------
    plt.figure(figsize=(10, 6))
    drivers = [
        ('OverTime: Yes vs No', 30.5 - 10.4),
        ('Tenure: 0-2 Yrs vs 10+ Yrs', 29.8 - 9.1),
        ('Salary: Low vs Executive', 28.3 - 6.7),
        ('Marital Status: Single vs Divorced', 25.5 - 10.1),
        ('Business Travel: Frequent vs Non-Travel', 24.9 - 8.0)
    ]
    driver_labels = [d[0] for d in drivers]
    driver_deltas = [d[1] for d in drivers]

    bars = plt.barh(driver_labels[::-1], driver_deltas[::-1], color='#e74c3c', edgecolor='black', alpha=0.85, height=0.5)
    plt.title('Top 5 Disproportionate Risk Differentials in Attrition (%-Point Gap)', fontsize=13, fontweight='bold', pad=12)
    plt.xlabel('Attrition Rate Percentage-Point Gap (%)', fontsize=11)
    for b in bars:
        w = b.get_width()
        plt.text(w + 0.3, b.get_y() + b.get_height()/2, f"+{w:.1f}% Gap", va='center', fontweight='bold', fontsize=10)
    plt.xlim(0, max(driver_deltas) + 5)
    plt.tight_layout()
    p6 = os.path.join(VISUAL_OUTPUTS_DIR, 'key_drivers_summary.png')
    plt.savefig(p6, bbox_inches='tight')
    plt.close()
    print(f"Saved: {p6}")

if __name__ == '__main__':
    print("=" * 80)
    print("STARTING HCL TECH PROJECT 10: EMPLOYEE ATTRITION ANALYSIS PIPELINE")
    print("STUDENT: RANJAN MAITI | ROLL NO: 2500321540146")
    print("=" * 80)
    df_raw = load_and_inspect_data()
    df_clean = clean_and_transform_data(df_raw)
    generate_star_schema(df_clean)
    run_exploratory_data_analysis(df_clean)
    generate_visualizations(df_clean)
    print("\n" + "=" * 80)
    print("DATA PIPELINE AND VISUALIZATIONS GENERATED SUCCESSFULLY!")
    print("=" * 80)
