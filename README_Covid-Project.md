# Covid Cases From 2020 - Present

## Project Overview
The 'Covid Cases From 2020 - Present' Project focuses on analyzing the global impact of the pandemic by integrating multiple datasets that capture different aspects of the crisis. It includes information on confirmed cases and  deaths, government policy responses, vaccination progress, and country level income classifications to provide a comprehensive idea of how the virus spread and countries responded. By combining indicators like the effective reproduction number (R) with socioeconomic dimensions, the projectoffers insights into transmission dynamics, policy effectiveness, and variation in pandemic outcomes across regions.

## Project Description
This project utilizes publicly available datasets from Kaggle such as cases_deaths, oxcgrt_policy, tracking_r, vaccinations_global, and country_income_classification to build an analytical framework for understanding COVID-19 trends. The data enables exploration of key questions such as how infection rates evolved over time, how government interventions correlated with changes in transmission, and how vaccination coverage influenced case and death trajectories. The inclusion of income classification further allows for comparisons across different economic contexts and highlighting inequities in resources and outcomes. The main objective of this project is to deliver interactive dashboards and data visualizations throuhg PowerBI that simplify complex data, making it easier for doctors, healthcare professionals, and public health officials to track pandemic progression, evaluate responses, and derive actionable insights.

## Dataset Information 

The dataset used for this project is called "COVID-19 Global Policy Impact Analysis", using the dataset to go more in depth on topics like the effect of policies like lockdown, country and economic comparisons, correlations between policies and health outcomes, and many more.

- **cases_deaths:** Tracks the number of confirmed COVID-19 cases and deaths over time
- **compact:** Provides a simplified dataset version with key COVID-19 indicators for quick analysis
- **country_income_classification:** Groups countries by income levels (low income, lower middle income, upper middle income, high income) 
- **oxcgrt_policy:** Captures government policy responses to COVID-19, including lockdowns and restrictions
- **tracking_r:** Estimates the effective reproduction number (R) representing the average number of people infected by one case at a specific point of time
- **vaccinations_global:** Records global vaccination progress, including total doses administered, people fully vaccinated, and percentage of population covered

### Project Workflow

1. **Data Collection:** Aquired and process the datasets "COVID-19 Global Policy Impact Analysis" from Kaggle and transfered it to SQL Server Management Studio.

2. **Data Management and Exploratory Analysis:** Queried multiple tables within the dataset to access data containing total cases and deaths, countries' income levels, vaccination updates, and other key indicators.

3. **Data Visualization:** Developed interactive Power BI dashboards by transforming SQL queries into visualizations that clearly communicate key insights from the data. Due to storage constraints, the visualizations were divided into three parts for efficient access and analysis.  The first part of the visualization can be accessed via this link [here](https://1drv.ms/u/c/b847d98b1a59977d/EY2ze-Nq3fFJu_H_G55PxMYB8D8evPKQRBC-aZIaWIqGJQ?e=u2EtJK), while Parts 2 and 3 are available on GitHub. Part 2 is titled COVID Cases From 2020–Present and Part 3 is titled COVID Cases From 2020–Present Pt. 2; the titles could not be updated due to a system error.

### Conclusion
This project demonstrates how integrating diverse COVID-19 datasets into interactive dashboards can uncover critical insights on transmission, policy responses, and vaccination progress. By simplifying complex data, it empowers healthcare professionals and public health officials to make more informed decisions in managing and responding to the pandemic.
