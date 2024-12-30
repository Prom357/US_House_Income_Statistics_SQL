# U.S Household Income Dataset Cleaning

This project involves cleaning and exploring the U.S Household Income dataset and its related statistics. The goal is to ensure data integrity by handling duplicate rows, correcting inconsistent entries, and performing exploratory data analysis (EDA) to uncover patterns and trends.

## Table of Contents
- [Overview](#overview)
- [Dataset Details](#dataset-details)
- [Steps for Data Cleaning](#steps-for-data-cleaning)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
- [SQL Queries](#sql-queries)
- [Key Findings](#key-findings)

---

## Overview
This project includes two datasets:
1. **us_household_income**: Contains household income details for different areas in the U.S.
2. **us_household_income_statistics**: Contains statistical summaries such as mean, median, and others.

Key objectives:
- Ensure data consistency.
- Identify and handle duplicates.
- Perform EDA to analyze patterns in income, land, and water distribution.

## Dataset Details
- `us_household_income` includes columns such as:
  - `id`
  - `State_Name`
  - `County`
  - `City`
  - `Type`
  - `ALand` (Land Area)
  - `AWater` (Water Area)

- `us_household_income_statistics` includes:
  - `id`
  - `Mean`
  - `Median`
  - Other statistical details.

Both datasets are joined on the `id` column.

## Steps for Data Cleaning
1. **Renaming Columns**:
   - Renamed column `ï»¿id` to `id` in the `us_household_income_statistics` table.
   ```sql
   ALTER TABLE us_household_income_statistics
   RENAME COLUMN `ï»¿id` TO `id`;
   ```

2. **Checking Table Counts**:
   Verified the record count in both tables.
   ```sql
   SELECT COUNT(id) FROM us_household_income;
   SELECT COUNT(id) FROM us_household_income_statistics;
   ```

3. **Handling Duplicates**:
   - Identified duplicates using `ROW_NUMBER()`.
   - Deleted duplicate rows from `us_household_income`.
   ```sql
   DELETE FROM us_household_income
   WHERE row_id IN (
     SELECT row_id
     FROM (
       SELECT row_id, id, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
       FROM us_household_income
     ) duplicates
     WHERE row_num > 1
   );
   ```

4. **Correcting State Names**:
   - Fixed state names with incorrect capitalization or spelling (e.g., 'georia' corrected to 'Georgia').
   ```sql
   UPDATE us_household_income
   SET State_Name = 'Georgia'
   WHERE State_Name = 'georia';
   ```

5. **Standardizing Type Values**:
   - Unified entries in the `Type` column (e.g., corrected 'Boroughs' to 'Borough').
   ```sql
   UPDATE us_household_income
   SET Type = 'Borough'
   WHERE Type = 'Boroughs';
   ```

6. **Handling Null or Zero Values**:
   - Checked and fixed missing values in `ALand` and `AWater` columns.
   ```sql
   SELECT ALand, AWater
   FROM us_household_income
   WHERE (ALand = 0 OR ALand = '' OR AWater IS NULL);
   ```

7. **Verifying Data Relationships**:
   - Ensured all `id` values matched between the two datasets.
   ```sql
   SELECT *
   FROM us_household_income ui
   RIGHT JOIN us_household_income_statistics us
   ON ui.id = us.id
   WHERE ui.id IS NULL;
   ```

## Exploratory Data Analysis (EDA)
1. **Land and Water Distribution**:
   - Explored which areas have the most land and water.
   ```sql
   SELECT State_Name, SUM(ALand) AS Total_Land, SUM(AWater) AS Total_Water
   FROM us_household_income
   GROUP BY State_Name
   ORDER BY Total_Water DESC
   LIMIT 10;
   ```

2. **Income Analysis by State**:
   - Analyzed the average mean and median incomes for each state.
   ```sql
   SELECT State_Name, ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
   FROM us_household_income ui
   INNER JOIN us_household_income_statistics us
   ON ui.id = us.id
   WHERE Mean <> 0
   GROUP BY State_Name
   ORDER BY Avg_Mean DESC
   LIMIT 10;
   ```

3. **Income Analysis by Type**:
   - Explored income distribution by `Type`.
   ```sql
   SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
   FROM us_household_income ui
   INNER JOIN us_household_income_statistics us
   ON ui.id = us.id
   WHERE Mean <> 0
   GROUP BY Type
   HAVING COUNT(Type) > 100
   ORDER BY Avg_Median DESC
   LIMIT 20;
   ```

4. **Outlier Detection**:
   - Identified cities with the highest average income.
   ```sql
   SELECT ui.State_Name, City, ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
   FROM us_household_income ui
   JOIN us_household_income_statistics us
   ON ui.id = us.id
   GROUP BY ui.State_Name, City
   ORDER BY Avg_Mean DESC;
   ```

## SQL Queries
All SQL queries used for data cleaning and analysis are provided in the `SQL_Queries.sql` file.

## Key Findings
1. **State-Level Trends**:
   - States with the highest average incomes were identified.
   - Areas with the most land and water were explored.

2. **Income Distribution by Type**:
   - Boroughs and Counties showed significant income variations.

3. **Data Quality Improvements**:
   - Duplicate rows were removed.
   - Spelling errors and inconsistent data entries were corrected.

---

## Conclusion
This project demonstrates the importance of data cleaning and EDA in uncovering meaningful insights. By ensuring data quality and analyzing trends, the dataset can support informed decision-making and policy development.

