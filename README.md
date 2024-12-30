U.S Household Income Dataset Cleaning
This project involves cleaning and exploring the U.S Household Income dataset and its related statistics. The goal is to ensure data integrity by handling duplicate rows, correcting inconsistent entries, and performing exploratory data analysis (EDA) to uncover patterns and trends.
Table of Contents
•	Overview
•	Dataset Details
•	Steps for Data Cleaning
•	Exploratory Data Analysis (EDA)
•	SQL Queries
•	Key Findings
________________________________________
Overview
This project includes two datasets:
1.	us_household_income: Contains household income details for different areas in the U.S.
2.	us_household_income_statistics: Contains statistical summaries such as mean, median, and others.
Key objectives:
•	Ensure data consistency.
•	Identify and handle duplicates.
•	Perform EDA to analyze patterns in income, land, and water distribution.
Dataset Details
•	us_household_income includes columns such as:
o	id
o	State_Name
o	County
o	City
o	Type
o	ALand (Land Area)
o	AWater (Water Area)
•	us_household_income_statistics includes:
o	id
o	Mean
o	Median
o	Other statistical details.
Both datasets are joined on the id column.
Steps for Data Cleaning
1.	Renaming Columns:
o	Renamed column ï»¿id to id in the us_household_income_statistics table.
2.	ALTER TABLE us_household_income_statistics
3.	RENAME COLUMN `ï»¿id` TO `id`;
4.	Checking Table Counts: Verified the record count in both tables.
5.	SELECT COUNT(id) FROM us_household_income;
6.	SELECT COUNT(id) FROM us_household_income_statistics;
7.	Handling Duplicates:
o	Identified duplicates using ROW_NUMBER().
o	Deleted duplicate rows from us_household_income.
8.	DELETE FROM us_household_income
9.	WHERE row_id IN (
10.	  SELECT row_id
11.	  FROM (
12.	    SELECT row_id, id, ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
13.	    FROM us_household_income
14.	  ) duplicates
15.	  WHERE row_num > 1
16.	);
17.	Correcting State Names:
o	Fixed state names with incorrect capitalization or spelling (e.g., 'georia' corrected to 'Georgia').
18.	UPDATE us_household_income
19.	SET State_Name = 'Georgia'
20.	WHERE State_Name = 'georia';
21.	Standardizing Type Values:
o	Unified entries in the Type column (e.g., corrected 'Boroughs' to 'Borough').
22.	UPDATE us_household_income
23.	SET Type = 'Borough'
24.	WHERE Type = 'Boroughs';
25.	Handling Null or Zero Values:
o	Checked and fixed missing values in ALand and AWater columns.
26.	SELECT ALand, AWater
27.	FROM us_household_income
28.	WHERE (ALand = 0 OR ALand = '' OR AWater IS NULL);
29.	Verifying Data Relationships:
o	Ensured all id values matched between the two datasets.
30.	SELECT *
31.	FROM us_household_income ui
32.	RIGHT JOIN us_household_income_statistics us
33.	ON ui.id = us.id
34.	WHERE ui.id IS NULL;
Exploratory Data Analysis (EDA)
1.	Land and Water Distribution:
o	Explored which areas have the most land and water.
2.	SELECT State_Name, SUM(ALand) AS Total_Land, SUM(AWater) AS Total_Water
3.	FROM us_household_income
4.	GROUP BY State_Name
5.	ORDER BY Total_Water DESC
6.	LIMIT 10;
7.	Income Analysis by State:
o	Analyzed the average mean and median incomes for each state.
8.	SELECT State_Name, ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
9.	FROM us_household_income ui
10.	INNER JOIN us_household_income_statistics us
11.	ON ui.id = us.id
12.	WHERE Mean <> 0
13.	GROUP BY State_Name
14.	ORDER BY Avg_Mean DESC
15.	LIMIT 10;
16.	Income Analysis by Type:
o	Explored income distribution by Type.
17.	SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
18.	FROM us_household_income ui
19.	INNER JOIN us_household_income_statistics us
20.	ON ui.id = us.id
21.	WHERE Mean <> 0
22.	GROUP BY Type
23.	HAVING COUNT(Type) > 100
24.	ORDER BY Avg_Median DESC
25.	LIMIT 20;
26.	Outlier Detection:
o	Identified cities with the highest average income.
27.	SELECT ui.State_Name, City, ROUND(AVG(Mean), 1) AS Avg_Mean, ROUND(AVG(Median), 1) AS Avg_Median
28.	FROM us_household_income ui
29.	JOIN us_household_income_statistics us
30.	ON ui.id = us.id
31.	GROUP BY ui.State_Name, City
32.	ORDER BY Avg_Mean DESC;
SQL Queries
All SQL queries used for data cleaning and analysis are provided in the SQL_Queries.sql file.
Key Findings
1.	State-Level Trends:
o	States with the highest average incomes were identified.
o	Areas with the most land and water were explored.
2.	Income Distribution by Type:
o	Boroughs and Counties showed significant income variations.
3.	Data Quality Improvements:
o	Duplicate rows were removed.
o	Spelling errors and inconsistent data entries were corrected.
________________________________________
Conclusion
This project demonstrates the importance of data cleaning and EDA in uncovering meaningful insights. By ensuring data quality and analyzing trends, the dataset can support informed decision-making and policy development.

