-- Covid 19 Data Exploration 

-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


SELECT 
    *
FROM
    portfolio_project.covid_death
WHERE
    location = 'Nigeria';

-- The percentage of total people who has covid-19 each day from in Nigeria from 2020 - 2021 
SELECT 
    date,
    location,
    population,
    total_cases,
    new_cases,
    FORMAT((total_cases / population) * 100,
        9) AS Percentage
FROM
    covid_death
WHERE
    location = 'Nigeria';



-- The maximum percentage of people having covid-19 each day in Nigeria from 2020 - 2021 
SELECT 
    MAX(FORMAT((total_cases / population) * 100 ,
        9))  higest_percentage
FROM
    covid_death
WHERE
    location = 'Nigeria';
--------------------------------------
SELECT *
FROM covid_death
WHERE (total_cases/population) * 100 = 0.110511400;

-- Using Subquery to combinee the code above 
SELECT *
FROM covid_death
WHERE (total_cases/population) * 100 = 
(SELECT 
    MAX(FORMAT((total_cases / population) * 100 ,
        9))  higest_percentage
FROM
    covid_death
WHERE
    location = 'Nigeria');



-- Location that has the highest infection rate with other information among country chosen.
SELECT 
    MAX(FORMAT((total_cases / population) * 100,
        9))
FROM
    covid_death;
-----------------------------------------------------
SELECT 
    *
FROM
    covid_death
WHERE
    (total_cases / population) * 100 = 9.990005700;

-- Using subquery to combine the code
SELECT 
    *
FROM
    covid_death
WHERE
    (total_cases / population) * 100 = (SELECT 
            MAX(FORMAT((total_cases / population) * 100,
                    9))
        FROM
            covid_death);


-- The percentage risk of one dying if infected with covid 19 in Nigeria from 2020 - 2021
SELECT 
    location,
    date,
    total_deaths,
    total_cases,
    FORMAT((total_deaths / total_cases) * 100,
        9) AS 'Covid Death Percentage'
FROM
    covid_death
WHERE
    location = 'Nigeria';

-- The highest percentage risk of one dying if infected with covid in Nigeria from 2020 - 2021
SELECT 
    MAX(FORMAT((total_deaths / total_cases) * 100,
        9)) AS Highest_Percentage_Risk
FROM
    covid_death
WHERE
    location = 'Nigeria';
-------------------------------------------------------
SELECT 
    *
FROM
    covid_death
WHERE
    (total_deaths / total_cases) * 100 = 9.375000000;

-- Using subquery to combine code to find the date
SELECT 
    *
FROM
    covid_death
WHERE
    (total_deaths / total_cases) * 100 = (SELECT 
            MAX(FORMAT((total_deaths / total_cases) * 100,
                    9)) AS Highest_Percentage_Risk
        FROM
            covid_death
        WHERE
            location = 'Nigeria');

-- The percentage risk of having a new case of covid-19 in each day from 2020-2021
SELECT 
    date,
    population,
    new_cases,
    FORMAT((new_cases / population) * 100,
        9) AS Percentage_Risk
FROM
    covid_death
WHERE
    location = 'Nigeria';


-- The highest percentage of having a new case of covid-19 from 2020-2021 in Nigeria
SELECT 
    FORMAT(MAX(new_cases / population) * 100,
        9) AS Percentage_Risk
FROM
    covid_death
WHERE
    location = 'Nigeria';
------------------------------------------------------------------
SELECT 
    *
FROM
    covid_death
WHERE
    (new_cases / population) * 100 = 0.001846300;

-- Using sub-query to combine code
SELECT 
    *
FROM
    covid_death
WHERE
    (new_cases / population) * 100 = (SELECT 
            FORMAT(MAX(new_cases / population) * 100,
                    9) AS Percentage_Risk
        FROM
            covid_death
        WHERE
            location = 'Nigeria');
 

-- Highest covid-19 Infection rate per location from 2020-2021
SELECT 
    location,
    population,
    MAX(total_cases) AS HighestCountInfection,
    MAX((total_cases / population) * 100) AS CovidInfectionPercentage
FROM
    covid_death
GROUP BY location , population
ORDER BY CovidInfectionPercentage DESC;


-- Highest percengtage of dying of covid-19 per location from 2020-2021
SELECT 
    location,
    population,
    MAX(total_deaths) AS HighestDeath,
    MAX(((total_deaths / population) * 100)) AS DeathPerPopulationPercentage
FROM
    covid_death
GROUP BY location , population
ORDER BY 3 DESC;

-- Highest percengtage of dying of covid-19 per continent from 2020-2021
SELECT 
    continent,
    MAX(total_deaths) AS HighestDeath,
    MAX(((total_deaths / population) * 100)) AS DeathPerPopulationPercentage
FROM
    covid_death
GROUP BY continent
ORDER BY 3 DESC;



-- New cases per day in Canada France Germany Italy Nigeria United Kingdom United States
SELECT 
    date, SUM(new_cases) AS Sum_New_case
FROM
    covid_death
GROUP BY date;

-- Calculating the maximum sum of the new cases using a sub-query this won't return date

    SELECT 
    MAX(Sum_New_case) 
FROM
    (SELECT 
        date, SUM(new_cases) AS Sum_New_case
    FROM
        covid_death
    GROUP BY date) AS sum_subquery;
    
   
    
-- Finding the date that has the highest number of new cases
SELECT 
    date, SUM(new_cases)
FROM
    covid_death
GROUP BY date
HAVING SUM(new_cases) = 1164351;



-- Using CTE to Find the date that has the highest number of new cases
WITH CTE_X AS (
SELECT date, SUM(new_cases) AS  sum_new_cases
 FROM covid_death
 GROUP BY date)
 
SELECT 
    *
FROM
    CTE_X
WHERE
    sum_new_cases = (SELECT 
            MAX(sum_new_cases)
        FROM
            CTE_X);

    


-- Death Percentage per day from 2020 -2021
SELECT 
    date,
    SUM(new_deaths) AS sum_new_death,
    SUM(new_cases) AS Sum_New_case,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS percentage
FROM
    covid_death
GROUP BY date;

SELECT 
    *
FROM
    covid_vac;

-- an inner join of covid_death table and covid_vac table
SELECT 
    *
FROM
    covid_death dea
        JOIN
    covid_vac vac USING (date , location);
    
    
-- total population vs total vaccinations
SELECT 
    SUM(DISTINCT (population)) Total_Population,
    SUM(new_vaccinations) Total_Vaccination
FROM
    covid_vac vac
        LEFT JOIN
    covid_death dea ON dea.date = vac.date
        AND dea.location = vac.location;

-- percentage of total vaccination vs total population  
SELECT 
    SUM(DISTINCT (population)) Total_Population,
    SUM(new_vaccinations) Total_Vaccination,
    (SUM(new_vaccinations) / SUM(DISTINCT (population))) * 100 AS total_vaccination_per_population_percentage
FROM
    covid_vac vac
        LEFT JOIN
    covid_death dea ON dea.date = vac.date
        AND dea.location = vac.location;
    
-- total population vs total vaccinations per location
SELECT 
    location,
    SUM(population) Total_Population,
    SUM(new_vaccinations) Total_Vaccination
FROM
    covid_death dea
        JOIN
    covid_vac vac USING (date , location)
GROUP BY population , location;

-- percentage of total vaccination vs total population per location
SELECT 
    location,
    SUM(population) Total_Population,
    SUM(new_vaccinations) Total_Vaccination,
    (SUM(new_vaccinations) / SUM(DISTINCT (population))) * 100 AS total_vaccination_per_population_percentage
FROM
    covid_vac vac
        LEFT JOIN
    covid_death dea USING (date , location)
GROUP BY location
HAVING Total_Population IS NOT NULL
ORDER BY total_vaccination_per_population_percentage;

-- Having a cummulative sum of vaccinnations per location and date 
SELECT location, date, population, new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY  date ) AS Cumulative_sum
FROM covid_death dea
JOIN covid_vac vac
	USING (date, location);

-- if you try using 'WHERE Cumulative_sum = 0', it would give an error because we cannot reference a window function in a where clause

-- Using Temporary Table
CREATE TEMPORARY TABLE Temp_cum (
    location VARCHAR(20), 
    date DATE, 
    population INT, 
    new_vaccinations INT, 
    Cumulative_sum INT
);

INSERT INTO Temp_cum
SELECT location, date, population, new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY  date ) AS Cummulative_sum
FROM covid_death dea
JOIN covid_vac vac
	USING (date, location);

SELECT 
    *
FROM
    Temp_cum
WHERE
    Cumulative_sum <> 0;

-- Using CTE to get the cummulative sum of vaccinations
WITH CTE_cum AS(
SELECT location, date, population, new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY  date ) AS Cumulative_sum
FROM covid_death dea
JOIN covid_vac vac
	USING (date, location)
)
SELECT 
    *
FROM
    CTE_cum
WHERE
    Cumulative_sum <> 0;

