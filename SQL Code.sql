#Task 1.

SELECT MIN(date) AS oldest_date
FROM bigquery-public-data.chicago_crime.crime;


#Task 2

SELECT EXTRACT(YEAR FROM date) AS year, COUNT(*) AS crime_count
FROM bigquery-public-data.chicago_crime.crime
GROUP BY year
ORDER BY crime_count DESC
LIMIT 1;


#Task 3

WITH crime_counts AS (
  SELECT primary_type, COUNT(*) AS total_crimes
  FROM bigquery-public-data.chicago_crime.crime
  WHERE EXTRACT(YEAR FROM date) = 2020
  GROUP BY primary_type
  ORDER BY total_crimes DESC
  LIMIT 5
),
arrest_counts AS (
  SELECT primary_type, COUNT(*) AS arrest_count
  FROM bigquery-public-data.chicago_crime.crime
  WHERE EXTRACT(YEAR FROM date) = 2020 AND arrest = true
  GROUP BY primary_type
)
SELECT cc.primary_type, cc.total_crimes, ac.arrest_count, ac.arrest_count / cc.total_crimes AS arrest_rate
FROM crime_counts cc
JOIN arrest_counts ac ON cc.primary_type = ac.primary_type;


#Task 4

WITH arrest_rates AS (
  SELECT EXTRACT(YEAR FROM date) AS year,
         COUNT(*) AS total_crimes,
         SUM(CAST(arrest AS INT64)) AS total_arrests,
         SUM(CAST(arrest AS INT64)) / COUNT(*) AS arrest_rate
  FROM bigquery-public-data.chicago_crime.crime
  GROUP BY year
)
SELECT year, total_crimes, total_arrests, arrest_rate
FROM arrest_rates
ORDER BY arrest_rate DESC;


#Task 5

WITH arrests_per_year AS (
  SELECT EXTRACT(YEAR FROM date) AS year,
         COUNT(*) AS total_arrests
  FROM bigquery-public-data.chicago_crime.crime
  WHERE arrest = true
  GROUP BY year
)
SELECT year, total_arrests
FROM arrests_per_year
ORDER BY total_arrests DESC;