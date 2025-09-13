/*
Select *
From [Portfolio].dbo.archive

Select *
From [Portfolio].dbo.cases_deaths

Select *
From [Portfolio].dbo.country_income_classification

Select *
From [Portfolio].dbo.oxcgrt_policy

Select *
From [Portfolio].dbo.tracking_r
*/

--Overview Page
Select SUM(TRY_CAST(CAST(total_deaths AS NVARCHAR(MAX)) AS BIGINT)) AS total_deaths
From [Portfolio].dbo.archive

Select SUM(TRY_CAST(CAST(total_cases AS NVARCHAR(MAX)) AS BIGINT)) AS total_global_cases
From [Portfolio].dbo.archive

select country, COUNT(DISTINCT total_cases) AS count_cases, COUNT(DISTINCT total_deaths) AS count_deaths
from [Portfolio].dbo.archive
group by country

Select date, COUNT(DISTINCT new_cases) AS new_cases
From [Portfolio].dbo.[archive]
group by date

select date, COUNT(DISTINCT total_deaths) as daily_deaths
from [Portfolio].dbo.archive
group by date

--Separating the countries based on their income classification
Select country
From [Portfolio].dbo.country_income_classification
Where income_group LIKE '%Low Income%'

Select country
From [Portfolio].dbo.country_income_classification
Where income_group LIKE '%High Income%'

Select country
From [Portfolio].dbo.country_income_classification
Where income_group LIKE '%middle income%'

-- India Cases
Select CAST(country AS NVARCHAR(255)) AS country, date, total_vaccinations
From [Portfolio].dbo.cases_deaths
Where CAST(country AS NVARCHAR(255)) LIKE '%India%'

Select CAST(country AS NVARCHAR(255)) AS country, COUNT(total_vaccinations) AS Vaccinations_in_India
From [Portfolio].dbo.cases_deaths
Where CAST(country AS NVARCHAR(255)) LIKE '%India%'
GROUP BY CAST(country AS NVARCHAR(255))

Select CAST(country AS NVARCHAR(255)) AS country, COUNT(*) AS Cases_with_2B_vaccinations
From [Portfolio].dbo.cases_deaths
Where CAST(country AS NVARCHAR(255)) LIKE '%India%'
AND total_vaccinations > 2000000000
GROUP BY CAST(country AS NVARCHAR(255))

Select CAST(country AS NVARCHAR(255)) AS country, SUM(daily_vaccinations) AS total_daily_vaccinations
From [Portfolio].dbo.cases_deaths
Where CAST(country AS NVARCHAR(255)) LIKE '%India%'
GROUP BY CAST(country AS NVARCHAR(255))



--Iraq Cases
Select CAST(country AS NVARCHAR(255)) AS country, COUNT(*) AS Cases_in_Iraq
FROM [Portfolio].dbo.cases_deaths
WHERE CAST(country AS NVARCHAR(255)) LIKE '%Iraq%'
AND total_vaccinations > 100000
GROUP BY CAST(country AS NVARCHAR(255))


-- Income group and infectious days of each country
Select CAST(c.country AS NVARCHAR(255)) AS country, CAST(c.income_group AS NVARCHAR(255)) AS income_group, COUNT(t.days_infectious) AS total_days_infectious
From [Portfolio].dbo.country_income_classification AS c
LEFT OUTER JOIN [Portfolio].dbo.tracking_r AS t
ON CAST(c.country AS NVARCHAR(255)) = CAST(t.country AS NVARCHAR(255))
GROUP BY CAST(c.country AS NVARCHAR(255)), CAST(c.income_group AS NVARCHAR(255))

-- Total Cases and Deaths, People vaccinated and unvaccinated for each day
Select YEAR(a.date) AS year, a.total_cases, a.total_deaths, c_d.people_vaccinated, c_d.people_unvaccinated
From [Portfolio].dbo.archive AS a
Left Join (
	SELECT date, SUM(people_vaccinated) AS people_vaccinated, SUM(people_vaccinated) AS people_unvaccinated
	FROM [Portfolio].dbo.cases_deaths
	GROUP BY date) AS c_d
On a.date = c_d.date


--Which countries implemented lockdowns only after their total cases crossed 1,000?
WITH Countries AS (
	SELECT DISTINCT country
	FROM [Portfolio].dbo.archive
)

SELECT c.country,
	
	(Select MIN(a2.date)
	From [Portfolio].dbo.archive a2
	Where CAST(a2.country AS NVARCHAR(255)) = CAST(c.country AS NVARCHAR(255))
	And a2.total_cases >= 1000) 
	AS first_case_1000_date,

	(Select MIN(p.date)
	FROM [Portfolio].dbo.oxcgrt_policy p
	Where CAST(p.country AS NVARCHAR(255)) = CAST(c.country AS NVARCHAR(255))
	And p.stringency_index >= 50)

From Countries c
Where 

(Select MIN(p.date)
	FROM [Portfolio].dbo.oxcgrt_policy p
	Where CAST(p.country AS NVARCHAR(255)) = CAST(c.country AS NVARCHAR(255))
	And p.stringency_index >= 50) 

	>
(Select MIN(a2.date)
	From [Portfolio].dbo.archive a2
	Where CAST(a2.country AS NVARCHAR(255)) = CAST(c.country AS NVARCHAR(255))
	And a2.total_cases >= 1000 

	);


-- Simpler Version of the subquery
SELECT DISTINCT country
FROM [Portfolio].dbo.archive

Where

(Select MIN(p.date)
	FROM [Portfolio].dbo.oxcgrt_policy p
	Where CAST(p.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
	And p.stringency_index >= 50) 

	>
(Select MIN(a2.date)
	From [Portfolio].dbo.archive a2
	Where CAST(a2.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
	And a2.total_cases >= 1000 

	);

--Which countries saw a decrease in new cases two weeks after lockdown?
SELECT DISTINCT country
FROM [Portfolio].dbo.archive
WHERE
	(SELECT AVG(a2.new_cases)
	 FROM [Portfolio].dbo.archive a2
	 WHERE CAST(a2.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
		AND a2.date BETWEEN
			(SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a2.country AS NVARCHAR(255)) AND p.stringency_index >= 50)
			AND DATEADD(day, 14, (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a2.country AS NVARCHAR(255)) AND p.stringency_index >= 50))
	 )
	 <
	 (SELECT AVG(a3.new_cases)
	  FROM [Portfolio].dbo.archive a3
	  WHERE CAST(a3.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
		AND a3.date BETWEEN
	       DATEADD(day, -14, (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a3.country AS NVARCHAR(255)) AND p.stringency_index >= 50))
           AND (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a3.country AS NVARCHAR(255)) AND p.stringency_index >= 50)
			);

--Which countries implemented lockdown before a COVID-19 death?
SELECT DISTINCT country
FROM [Portfolio].dbo.archive 
WHERE
	(SELECT min(a2.date)
	FROM [Portfolio].dbo.archive a2
	WHERE CAST(a2.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
	AND a2.total_deaths > 0
	)
	>
	(SELECT MIN(p.date)
	FROM [Portfolio].dbo.oxcgrt_policy p
	WHERE CAST(p.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
	AND stringency_index >= 50
	);

--What was the highest stringency index each country reached?
	SELECT DISTINCT TOP 250 a.country, 
		(SELECT MAX(stringency_index)
		FROM [Portfolio].dbo.oxcgrt_policy p
		WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a.country AS NVARCHAR(255))
		) AS max_stringency_index
	FROM [Portfolio].dbo.archive a
	ORDER BY country

--Inner Join Query Version of (What was the highest stringency index each country reached?).
SELECT DISTINCT a.country, MAX(p.stringency_index) as max_stringency_index
FROM [Portfolio].dbo.archive a
INNER JOIN [Portfolio].dbo.oxcgrt_policy p
ON CAST(a.country AS NVARCHAR(255)) = CAST(p.country AS NVARCHAR(255))
GROUP BY a.country
ORDER BY country

--INNER JOIN version of (Which countries implemented lockdown before a COVID-19 death?)
 SELECT CAST(f.country AS NVARCHAR(255)) AS Country, f.Covid_death_date, l.Lockdown_date
 FROM 
 (SELECT CAST(country AS NVARCHAR(255)) AS country, MIN(date) AS Covid_death_date
 FROM [Portfolio].dbo.archive
 WHERE total_deaths > 0
 GROUP BY CAST(country AS NVARCHAR(255))
 ) f
 INNER JOIN
 (SELECT CAST(country AS NVARCHAR(255)) AS country, MIN(date) AS lockdown_date
 FROM [Portfolio].dbo.oxcgrt_policy
 WHERE stringency_index >= 50
 GROUP BY CAST(country AS NVARCHAR(255))
 ) l
 ON f.country = l.country

 WHERE l.lockdown_date < f.Covid_death_date;

 --What are the poverty levels for each country?
 SELECT CAST(p.country AS NVARCHAR(255)) AS country, MAX(CAST(CAST(extreme_poverty AS NVARCHAR(255)) AS FLOAT)) AS extreme_poverty,
	(SELECT TOP 1 CAST(income_group AS NVARCHAR(255)) 
	FROM [Portfolio].dbo.country_income_classification cic
	WHERE CAST(cic.country AS NVARCHAR(255)) = CAST(p.country AS NVARCHAR(255))) AS income_group

 FROM [Portfolio].dbo.oxcgrt_policy p
 WHERE extreme_poverty IS NOT NULL
 GROUP BY CAST(p.country AS NVARCHAR(255))
 ORDER BY extreme_poverty ASC

 --INNER JOIN Query Version of (What are the poverty levels for each country?) 
 SELECT TOP 155 CAST(p.country AS NVARCHAR(255)) AS country, MAX(CAST(CAST(extreme_poverty AS NVARCHAR(255)) AS FLOAT)) as extreme_poverty, CAST(cic.income_group AS NVARCHAR(255)) AS income_group
 FROM [Portfolio].dbo.oxcgrt_policy p
 INNER JOIN [Portfolio].dbo.country_income_classification cic
 ON CAST(p.country AS NVARCHAR(255)) = CAST(cic.country AS NVARCHAR(255))
 WHERE extreme_poverty IS NOT NULL
 GROUP BY CAST(p.country AS NVARCHAR(255)), CAST(cic.income_group AS NVARCHAR(255))
 ORDER BY extreme_poverty 


 --WITH statement version of (Which countries implemented lockdown before a covid-19 death?)
 
 WITH lockdown_date AS (SELECT CAST(country AS NVARCHAR(255)) as country, MIN(date) as lockdown_start_date
	FROM [Portfolio].dbo.oxcgrt_policy 
	WHERE stringency_index >= 50
	GROUP BY CAST(country AS NVARCHAR(255))),

	 covid_death_date AS (SELECT CAST(country AS NVARCHAR(255)) as country, min(date) as first_death_date
	FROM [Portfolio].dbo.archive 
	WHERE total_deaths > 0
	GROUP BY CAST(country AS NVARCHAR(255)))

SELECT l.country
FROM lockdown_date l
JOIN covid_death_date c
ON l.country = c.country
WHERE l.lockdown_start_date < c.first_death_date


--WITH statement version of (Which countries saw a decrease in new cases two weeks after lockdown?)
SELECT DISTINCT country
FROM [Portfolio].dbo.archive
WHERE
	(SELECT AVG(a2.new_cases)
	 FROM [Portfolio].dbo.archive a2
	 WHERE CAST(a2.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
		AND a2.date BETWEEN
			(SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a2.country AS NVARCHAR(255)) AND p.stringency_index >= 50)
			AND DATEADD(day, 14, (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a2.country AS NVARCHAR(255)) AND p.stringency_index >= 50))
	 )
	 <
	 (SELECT AVG(a3.new_cases)
	  FROM [Portfolio].dbo.archive a3
	  WHERE CAST(a3.country AS NVARCHAR(255)) = CAST([Portfolio].dbo.archive.country AS NVARCHAR(255))
		AND a3.date BETWEEN
	       DATEADD(day, -14, (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a3.country AS NVARCHAR(255)) AND p.stringency_index >= 50))
           AND (SELECT MIN(p.date) FROM [Portfolio].dbo.oxcgrt_policy p WHERE CAST(p.country AS NVARCHAR(255)) = CAST(a3.country AS NVARCHAR(255)) AND p.stringency_index >= 50)
	);

WITH 
	lockdown_dates AS (SELECT CAST(country AS NVARCHAR(255)) as country, MIN(date) as lockdown_start_date
	FROM [Portfolio].dbo.oxcgrt_policy 
	WHERE stringency_index >= 50
	GROUP BY CAST(country AS NVARCHAR(255))),
	
	post_new_cases AS (SELECT a.country, AVG(new_cases) as avg_post_cases
	FROM [Portfolio].dbo.archive a
	JOIN lockdown_dates l
	ON CAST(a.country as NVARCHAR(255)) = l.country
	WHERE date BETWEEN
			l.lockdown_start_date AND DATEADD(day, 14, l.lockdown_start_date)
			GROUP BY a.country
	 ),

	 pre_new_cases AS(SELECT a.country, AVG(new_cases) as avg_pre_cases
	 FROM [Portfolio].dbo.archive a
	 JOIN lockdown_dates l
	 ON CAST(a.country AS NVARCHAR(255)) = l.country
		WHERE date BETWEEN
	       DATEADD(day, -14, l.lockdown_start_date) AND l.lockdown_start_date
		   GROUP BY a.country
	)

	SELECT pre.country
	FROM pre_new_cases pre
	JOIN post_new_cases post
	ON pre.country = post.country
	WHERE post.avg_post_cases < pre.avg_pre_cases



--Comparing countries, dates, and total cases from the archive and oxcgrt_policy tables
Select CAST(country AS NVARCHAR(255)) AS country, date, CAST(total_cases AS NVARCHAR(255)) AS total_cases
From [Portfolio].dbo.archive

UNION 

Select CAST(country AS NVARCHAR(255)) AS country, date, CAST(total_cases AS NVARCHAR(255)) AS total_cases
From [Portfolio].dbo.oxcgrt_policy


Select CAST(country AS NVARCHAR(255)) AS country, date, CAST(total_cases AS NVARCHAR(255)) AS total_cases
From [Portfolio].dbo.archive

UNION ALL

Select CAST(country AS NVARCHAR(255)) AS country, date, CAST(total_cases AS NVARCHAR(255)) AS total_cases
From [Portfolio].dbo.oxcgrt_policy


--Compare the latest cases and the total number of cases in each listed country from 2020-2025
SELECT DISTINCT CAST(country AS NVARCHAR(255)) AS country, CAST(date AS NVARCHAR(255)) AS date, new_cases, LEFT(date, 4) AS year
FROM [Portfolio].dbo.archive
GROUP BY country, date, new_cases
ORDER BY year

SELECT DISTINCT CAST(country AS NVARCHAR(255)) AS country, CAST(date AS NVARCHAR(255)) AS date, new_deaths, LEFT(date, 4) AS year
FROM [Portfolio].dbo.archive
GROUP BY country, date, new_deaths
ORDER BY year

--Compare the latest deaths and the total number of deaths in each listed country from 2020-2025
SELECT DISTINCT CAST(country AS NVARCHAR(255)) AS country, CAST(date AS NVARCHAR(255)) AS date, total_cases, LEFT(date, 4) AS year
FROM [Portfolio].dbo.archive
GROUP BY country, date, total_cases
ORDER BY year

SELECT DISTINCT CAST(country AS NVARCHAR(255)) AS country, CAST(date AS NVARCHAR(255)) AS date, total_deaths, LEFT(date, 4) AS year
FROM [Portfolio].dbo.archive
GROUP BY country, date, total_deaths
ORDER BY year



--Conclusion Page
SELECT CAST(continent AS NVARCHAR(MAX)) AS continent, COUNT(DISTINCT total_cases) AS total_cases
FROM [Portfolio].dbo.oxcgrt_policy
group by CAST(continent AS NVARCHAR(MAX))

SELECT 
    Year([date]) as year,
    SUM(CAST(total_deaths AS BIGINT)) * 1.0 / SUM(CAST(total_cases AS BIGINT)) AS death_case_ratio
FROM [Portfolio].dbo.archive
GROUP BY Year([date])