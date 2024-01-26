-- Using DEATHS table --
SELECT * FROM deaths;

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM deaths
ORDER BY 1, 2;

-- Finding death rate in % = (deaths/cases)*100 --
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate
FROM deaths
WHERE location LIKE '%india%'
ORDER BY 1, 2 DESC;

-- Cases per population in % = (total cases/population)*100
SELECT location, date, total_cases, total_deaths, (total_cases/population)*100 AS infection_rate, (total_deaths/total_cases)*100 AS death_rate
FROM deaths
WHERE location LIKE '%india%'
ORDER BY 1, 2;

-- Highest infection rate
SELECT location, population, MAX(total_cases) AS HighestCase, MAX((total_cases/population)*100) AS infection_rate
FROM deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY population DESC;

-- Highest death per population
SELECT location, population, MAX(cast(total_deaths as int)) as TotalDeath, MAX((total_deaths/population)*100) as death_per_population 
FROM deaths
WHERE continent IS NOT NULL 
GROUP BY location, population 
ORDER BY TotalDeath DESC;

-- Continentwise data death data
SELECT location, population, MAX(cast(total_deaths as int)) as TotalDeath
FROM deaths
WHERE continent IS NULL 
GROUP BY location, population 
ORDER BY TotalDeath DESC;

-- Global data --
-- Overall cases and deaths
SELECT SUM(new_cases) as totalcases, SUM(cast(total_deaths as int)) as totaldeaths, SUM(cast(total_deaths as int))/SUM(new_cases) as deathpercent
FROM deaths
WHERE continent IS NOT NULL
ORDER BY 1;

-- Date wise case and deaths
SELECT date, SUM(new_cases) as totalcases, SUM(cast(total_deaths as int)) as totaldeaths, SUM(cast(total_deaths as int))/SUM(new_cases) as deathpercent
FROM deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1;
