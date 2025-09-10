# Worldwide Box Office Analysis

## Project Overview
The Worldwide Box Office Analysis project dives more into the business angle of many popular films over time from different countries and languages across the world. Based on the two datasets from Kaggle 'movies_metadata' and 'Top_200_Movies_Dataset', Worldwide Box Office Analysis focuses on analyzing box office trends and providing data driven insights.

## Problem Description
The goal of this analysis is to study box office performance and trends by combining the two datasets 'movies_metadata' and 'Top_200_Movies_Dataset'. The former being a large dataset while the latter being a curated dataset. This analysis identifies highest/lowest grossing movies, compares vote average vs. vote count to examine audience reception, measure profitability and return on investment (ROI) across languages, explore genre-based, languages-based, and country-based success patterns, Highlight trends in Indian cinema and re-releases in 2023, and analyze revenue trends over the years (2000-present). This provides insights into factors like (budget, country, genre, language, or release year) that drive box office success.

## Dataset Information
### 1. movies_metadata

Contains global movie details:

- Title, original title, production countries, spoken/original languages

- Budget, revenue, release date, runtime, popularity

- Genres, vote average, vote count, overview

- ~45,000+ movie entries (broad coverage across years and regions).

### 2. Top_200_Movies_Dataset_2023

Focused dataset of the top 200 highest-performing movies in 2023.

Includes:

- Title, Total Gross (revenue), Release Date

- Acts as a modern benchmark to compare against the broader dataset.

## Project Workflow
1. **Data Collection:** Aquired and process the datasets "movies_metadata" and "Top_200_Movies_Dataset" from Kaggle and transfered them to SQL Server Management Studio, executing data integration and reviewing columns with value.

2. **Data Management and Exploratory Analysis:** Queried the two datasets by joining the two tables together to retrieve data that contains information like the most common languages of the movies in the dataset or popular genre at the  box office.

3. **Comparative Analysis:** Comparing variables such as highest ratings and highest votes for each movie to identify whether certain movies have aged well or not among the audiences. If the ratings and votes are equally high, then the movie is liked by the audience. However, If a movie was rated high but with less votes, only a section of audience liked it and hasn't aged well or everyone


## Conclusion:
The analysis reveals key drivers of box office success: budget efficiency (ROI), genre alignment, language reach, and international markets. Combining historical data with the 2023 benchmark highlights evolving audience preferences and the global nature of the film industry.

