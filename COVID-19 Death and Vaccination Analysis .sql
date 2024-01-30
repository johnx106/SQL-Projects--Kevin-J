--- All the quires are using data from 2022-2024

--Result1 : Complete Death table From 1/22/2022-1/29/2024

SELECT * FROM deaths; 


-- Result 2: Covid Cases and Deaths in the United States: 

SELECT date, location, population, new_cases, total_cases, total_deaths 
FROM deaths
WHERE 
    location LIKE '%united states%' 
ORDER BY total_cases DESC, total_deaths DESC;

-- Result 3: Finding death rate (%,deaths/cases)*100) in United States 

SELECT date, location,total_cases,total_deaths,
ROUND(CAST(total_deaths * 100/ NULLIF(total_cases,0) AS REAL), 2) || '%' AS  death_rate
FROM deaths
WHERE 
	location like '%united states%'
Order by death_rate DESC;


-- Result 4: Infection Rate and Population Death Rate (%) in the United States:

SELECT  date, location,  population, total_cases, total_deaths, 
    ROUND(CAST(total_cases * 100.0 / NULLIF(population, 0) AS REAL), 2) || '%' AS Infection_Rate,
    ROUND(CAST(total_deaths * 100.0 / NULLIF(total_cases, 0) AS REAL), 2) || '%' AS Population_death_rate
FROM deaths
WHERE location LIKE '%united states%'
GROUP BY location, Infection_Rate
ORDER BY Infection_Rate DESC, Population_death_rate DESC ;


-- Result 5: Avergae Infection Rate of each Countries(%):

WITH CountryData AS (
    SELECT 
        location, 
        population, 
        total_cases,
        ROUND((total_cases * 100.0 / NULLIF(population, 0)), 2) AS infection_rate
    FROM deaths
    WHERE continent IS NOT NULL
)
SELECT 
    location,
    MAX(population) AS population,
    ROUND(AVG(total_cases),0) AS average_cases,
    ROUND(AVG(infection_rate), 2) AS average_infection_rate
FROM CountryData
GROUP BY location
ORDER BY average_infection_rate DESC;


-- Result 6: Highest Deaths Per Country, ranking  Highest to lowest:

SELECT  location, population,
	MAX(CAST(total_deaths AS INT)) AS highest_total_deaths, 
    ROUND(MAX(total_deaths * 100.0 / NULLIF(population, 0)), 2) || '%' AS highest_death_per_population
FROM deaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY highest_death_per_population DESC;


-- Result 7: Listing Continents by Death Rates from Highest to Lowest.

SELECT location, population, 
    MAX(CAST(total_deaths AS INT)) AS total_deaths, 
    ROUND(total_deaths * 100.0 / NULLIF(population, 0), 2) || '%' AS Total_Population_Death_Rate
FROM deaths
WHERE continent IS NULL  
GROUP BY location, population 
ORDER BY Total_Population_Death_Rate DESC;


-- Result 8 The Countries with New Cases and Deaths globally

SELECT 
    location,
    SUM(new_cases) AS total_new_cases,
    SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
    CASE 
        WHEN SUM(new_cases) = 0 THEN 0
        ELSE ROUND((SUM(new_deaths * 1.0) / SUM(new_cases)) * 100, 2)
    END AS New_death_percent
FROM 
    deaths 
WHERE 
    continent IS NOT NULL
GROUP BY 
    location
ORDER BY 
    New_death_percent DESC;



----Vacination Statistics from 2022-2024


--Result 9-  VACCINATION table--

Select * FROM vaccination 
WHERE continent is not null;

--- Result 10 - Total Vacinated (in percentage)  From 1/22/2022-1/29/2024

SELECT 
    dea.location,
    SUM(dea.population) AS Population,
    SUM(CAST(vac.people_fully_vaccinated AS INT)) AS vaccinated,
    CAST(
        COALESCE(
            SUM(CAST(vac.people_fully_vaccinated * 100 AS INT)) / NULLIF(SUM(dea.population), 0), 
            0
        ) AS VARCHAR
    ) + '%' AS Vaccine_percent
FROM 
    deaths AS dea
JOIN 
    vaccination AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
GROUP BY 
    dea.location
ORDER BY 
    Vaccine_percent DESC;
		


-- Result 11-  Average Vacinated (%) per Country 

SELECT 
    dea.location,
    SUM(dea.population) AS Population,
    SUM(CAST(vac.people_fully_vaccinated as INT)) AS vaccinated,
    CAST(
        COALESCE
						(ROUND(AVG(COALESCE(vac.people_fully_vaccinated * 100 / NULLIF(dea.population, 0), 0)), 1), 
            0) 
				AS DECIMAL(18, 0)
    ) + CAST('%' AS VARCHAR) AS Avg_Vaccine_percent
FROM 
    deaths AS dea
JOIN 
    vaccination AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
GROUP BY 
    dea.location
ORDER BY 
    Avg_Vaccine_percent DESC;


		

--- Result 12: Total of Newly Vaccinated Population per Country 

SELECT 
    dea.location,
    SUM(dea.population) AS Population,
    SUM(CAST(vac.new_vaccinations AS INT)) AS Newly_vaccinated,
    CAST(
        COALESCE(
            SUM(CAST(new_vaccinations * 100 AS INT)) / NULLIF(SUM(dea.population), 0), 
            0
        ) AS VARCHAR
    ) + '%' AS Newly_vaccinated_percent
FROM 
    deaths AS dea
JOIN 
    vaccination AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
GROUP BY 
    dea.location
ORDER BY 
    Newly_vaccinated_percent DESC;


--- Results 13: Average of Newly Vaccinated Population per Country 

SELECT 
    dea.location,
    SUM(dea.population) AS Population,
    SUM(CAST(vac.new_vaccinations AS INT)) AS Newly_vaccinated,
    CAST(
        COALESCE(
            ROUND(
                AVG(COALESCE(vac.new_vaccinations * 100.0 / NULLIF(dea.population, 0), 0)), 
                2
            ), 
            0
        ) AS DECIMAL(18, 2)
    ) + '%' AS Avg_Newly_vaccinated_percent 
FROM 
    deaths AS dea
JOIN 
    vaccination AS vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL 
GROUP BY 
    dea.location
ORDER BY 
    Avg_Newly_vaccinated_percent DESC;
