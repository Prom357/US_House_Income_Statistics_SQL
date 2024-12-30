-- Fixing Column Name
ALTER TABLE us_household_income_statistics
RENAME COLUMN `ï»¿id` TO `id`;

-- Joining and Viewing Data
SELECT * 
FROM us_household_income uhi
JOIN us_household_income_statistics uhis
ON uhi.row_id = uhis.id;

-- Counting Rows in Each Table
SELECT COUNT(id) FROM us_household_income;
SELECT COUNT(id) FROM us_household_income_statistics;

-- Checking for Duplicates
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

-- Identifying Duplicate Rows
SELECT * 
FROM (
    SELECT row_id, id,
           ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
    FROM us_household_income
) duplicates
WHERE row_num > 1;

-- Deleting Duplicate Rows
DELETE FROM us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id, id,
               ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS row_num
        FROM us_household_income
    ) duplicates
    WHERE row_num > 1
);

-- Fixing State Name Issues
SELECT DISTINCT State_name
FROM us_household_income
ORDER BY 1;

UPDATE us_household_income
SET State_Name = 'Georgia' 
WHERE State_Name = 'georia';

UPDATE us_household_income
SET State_Name = 'Alabama' 
WHERE State_Name = 'Alabama';

-- Fixing Place Names
SELECT * 
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

-- Checking and Fixing 'Type' Column
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
ORDER BY 1;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Checking Land and Water Data
SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 OR ALand = '' OR AWater IS NULL;

-- Exploring Land and Water Trends by State
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

-- Joining Income and Statistics Data
SELECT * 
FROM us_household_income ui
JOIN us_household_income_statistics us
ON ui.id = us.id;

SELECT * 
FROM us_household_income ui
RIGHT JOIN us_household_income_statistics us
ON ui.id = us.id
WHERE ui.id IS NULL;

SELECT * 
FROM us_household_income ui
INNER JOIN us_household_income_statistics us
ON ui.id = us.id
WHERE Mean <> 0;

-- Exploring State-Level Income Data
SELECT ui.State_Name, AVG(Mean), AVG(Median)
FROM us_household_income ui
INNER JOIN us_household_income_statistics us
ON ui.id = us.id
WHERE Mean <> 0
GROUP BY ui.State_Name;

SELECT ui.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income ui
INNER JOIN us_household_income_statistics us
ON ui.id = us.id
WHERE Mean <> 0
GROUP BY ui.State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Exploring Trends by Type
SELECT Type, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income ui
INNER JOIN us_household_income_statistics us
ON ui.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 3 DESC
LIMIT 20;

-- Removing Outliers if Needed
SELECT ui.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM us_household_income ui
JOIN us_household_income_statistics us
ON ui.id = us.id
GROUP BY ui.State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC;
