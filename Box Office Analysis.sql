--Overview Page
select *
from [Portfolio].dbo.movies_metadata m

SELECT COUNT(*) AS Total_Count 
FROM
(SELECT CAST(title AS NVARCHAR(MAX)) AS Title
FROM [Portfolio].dbo.movies_metadata
UNION ALL
SELECT CAST(Title AS NVARCHAR(MAX)) AS Title
FROM [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)]) AS t;

SELECT AVG(r.avg_revenue) AS Total_Avg
FROM
(select AVG(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS avg_revenue
From [Portfolio].dbo.movies_metadata
UNION ALL
select AVG(TRY_CAST(CAST(Total_Gross AS NVARCHAR(MAX)) AS BIGINT)) AS avg_revenue
FROM [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)]) AS r

select *
from [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)]

select CAST(production_countries AS NVARCHAR(MAX)) AS countries,
SUM(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS total_revenue
FROM [Portfolio].dbo.movies_metadata
GROUP BY CAST(production_countries AS NVARCHAR(MAX)) 


--Languages of Each Movie
select title, spoken_languages
from [Portfolio].dbo.movies_metadata

Select CAST(spoken_languages AS NVARCHAR(MAX)) as Languages
From [Portfolio].dbo.movies_metadata
Where CAST(spoken_languages AS NVARCHAR(MAX)) <> '[]'
And CAST(spoken_languages AS NVARCHAR(MAX)) NOT LIKE '%?%'

SELECT CAST(spoken_languages AS NVARCHAR(MAX)) AS Languages
FROM [Portfolio].dbo.movies_metadata
WHERE CAST(spoken_languages AS NVARCHAR(MAX)) IS NOT NULL
  AND CAST(spoken_languages AS NVARCHAR(MAX)) <> '[]'  
  AND CAST(spoken_languages AS NVARCHAR(MAX)) NOT LIKE '%?%' 
  AND LEN(CAST(spoken_languages AS NVARCHAR(MAX))) - LEN(REPLACE(CAST(spoken_languages AS NVARCHAR(MAX)), '},{', '')) <= 1
  AND CAST(spoken_languages AS NVARCHAR(MAX)) NOT LIKE '%''name'': ''''%'


--Most Profitable Movies
;WITH MovieData AS 
(SELECT CAST(title AS NVARCHAR(MAX)) AS title, 
TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) AS budget, 
TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) as revenue
from [Portfolio].dbo.[movies_metadata] )
SELECT title, budget, revenue, revenue - budget AS profit
FROM MovieData
WHERE budget != 0 and revenue != 0

--Vote Average vs. Vote Count Comparison
select TOP 150 title, original_title, production_countries, vote_average, vote_count
from [Portfolio].dbo.movies_metadata
where TRY_CAST(CAST(vote_average AS NVARCHAR(MAX)) AS BIGINT) IS NOT NULL
order by TRY_CAST(CAST(vote_average AS NVARCHAR(MAX)) AS BIGINT) DESC

select TOP 150 title, original_title, production_countries, vote_average, vote_count
from [Portfolio].dbo.movies_metadata
where TRY_CAST(CAST(vote_count AS NVARCHAR(MAX)) AS BIGINT) IS NOT NULL
order by TRY_CAST(CAST(vote_count AS NVARCHAR(MAX)) AS BIGINT) DESC

--Indian Cinema Releases
SELECT 
    title, 
    production_countries, 
    release_date, 
    vote_average, 
    vote_count, 
    budget, 
    revenue, 
    runtime, 
    popularity
FROM [Portfolio].dbo.movies_metadata
WHERE 
    TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) != 0 AND
    TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) != 0 AND
    CAST(title AS NVARCHAR(MAX)) IS NOT NULL AND
    TRY_CAST(CAST(vote_average AS NVARCHAR(MAX)) AS FLOAT) IS NOT NULL AND
    TRY_CAST(CAST(vote_count AS NVARCHAR(MAX)) AS BIGINT) IS NOT NULL
    AND LTRIM(RTRIM(CAST(production_countries AS NVARCHAR(MAX)))) = '[{''iso_3166_1'': ''IN'', ''name'': ''India''}]'
ORDER BY 
    TRY_CAST(CAST(vote_average AS NVARCHAR(MAX)) AS FLOAT) DESC,
    TRY_CAST(CAST(vote_count AS NVARCHAR(MAX)) AS BIGINT) DESC;


--Highest and Lowest Grossing Movies
select top 1 title AS highest_grossing_movie, original_title, overview, TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) AS collected_revenue,
TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) AS budget
from [Portfolio].dbo.movies_metadata
order by TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) DESC

select top 1 title AS lowest_grossing_movie, original_title, overview, TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) AS collected_revenue,
TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) AS budget
from [Portfolio].dbo.movies_metadata
where title IS NOT NULL
and TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) != 0
and TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) != 0
order by TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) ASC

--Re-releases in 2023
select *
from [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)]
where Title like '%Re-release%'


--Combining both tables
SELECT CAST(m.title AS NVARCHAR(MAX)) AS Title, TRY_CAST(CAST(m.revenue AS NVARCHAR(MAX)) AS BIGINT) AS Revenue 
FROM [Portfolio].dbo.movies_metadata m 
WHERE CAST(m.title AS NVARCHAR(MAX)) IS NOT NULL AND TRY_CAST(CAST(m.revenue AS NVARCHAR(MAX)) AS BIGINT) IS NOT NULL    

UNION         

SELECT CAST(t.title AS NVARCHAR(MAX)) AS Title, TRY_CAST(CAST(t.Total_Gross AS NVARCHAR(MAX)) AS BIGINT) AS Revenue 
FROM [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)] t
WHERE CAST(t.title AS NVARCHAR(MAX)) IS NOT NULL AND  TRY_CAST(CAST(t.Total_Gross AS NVARCHAR(MAX)) AS BIGINT) IS NOT NULL


--Genre Analysis (Which genres are the most successful at the box office?)
select CAST(genres AS NVARCHAR(MAX)) AS genres,
AVG(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS avg_revenue,
COUNT(*) AS num_movies
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
GROUP BY CAST(genres AS NVARCHAR(MAX))
ORDER BY avg_revenue DESC


--Top 10 Highest Grossing Countries
select TOP 10
CAST(production_countries AS NVARCHAR(MAX)) AS countries,
SUM(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS total_revenue,
COUNT(*) AS movie_count
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
GROUP BY CAST(production_countries AS NVARCHAR(MAX)) 
ORDER BY total_revenue;


--Movies with the Highest Return on Investment
SELECT TOP 10
    title,
    TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) AS budget,
    TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) AS revenue,
    (TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) - TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT)) AS profit,
    CAST(1.0 * TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) / NULLIF(TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT),0) AS DECIMAL(10,2)) AS ROI
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(budget AS NVARCHAR(MAX)) AS BIGINT) > 0
  AND TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
ORDER BY ROI DESC;

--Conclusion Page
select TOP 10
CAST(title AS NVARCHAR(MAX)) AS countries,
SUM(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS total_revenue
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
GROUP BY CAST(title AS NVARCHAR(MAX)) 
ORDER BY total_revenue DESC;


select TOP 45000
CAST(original_language AS NVARCHAR(MAX)) AS language,
SUM(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS total_revenue
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
GROUP BY CAST(original_language AS NVARCHAR(MAX)) 
ORDER BY total_revenue DESC;


select TOP 10
CAST(spoken_languages AS NVARCHAR(MAX)) AS language,
SUM(TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT)) AS total_revenue
FROM [Portfolio].dbo.movies_metadata
WHERE TRY_CAST(CAST(revenue AS NVARCHAR(MAX)) AS BIGINT) > 0
GROUP BY CAST(spoken_languages AS NVARCHAR(MAX)) 
ORDER BY total_revenue DESC;


SELECT 
    YEAR(TRY_CONVERT(DATE, t.release_date, 101)) AS Year,
    SUM(TRY_CAST(CONVERT(NVARCHAR(MAX), t.revenue) AS MONEY)) AS Total_Revenue
FROM
(
    SELECT revenue, release_date
    FROM [Portfolio].dbo.movies_metadata
    UNION ALL
    SELECT Total_Gross AS revenue, Release_Date AS release_date
    FROM [Portfolio].dbo.[Top_200_Movies_Dataset_2023(Cleaned)]
) AS t
WHERE 
    TRY_CONVERT(DATE, t.release_date, 101) IS NOT NULL
    AND YEAR(TRY_CONVERT(DATE, t.release_date, 101)) >= 2000
GROUP BY YEAR(TRY_CONVERT(DATE, t.release_date, 101))
ORDER BY Year;
