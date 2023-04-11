SELECT *
FROM CovidDeaths
GROUP BY 3, 4

--select data to be used
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

--Total cases v. Total deaths
--shows the likelihood of dying if you contracted covid in Nigeria
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DEATHPERCENTAGE
FROM CovidDeaths
WHERE Location = 'Nigeria'
ORDER BY 1, 2

--Percentage of the population that contracted covid
Select Location, date, total_cases, Population, (total_cases/population) * 100 as CovidPercentage
FROM CovidDeaths
WHERE Location = 'Nigeria'


--Highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) HighestInfectionCount, MAX((total_cases/population)) * 100  CovidPercentage
FROM covidDeaths
GROUP BY Location, Population
ORDER BY 4 DESC

--Highest Death rate compared to population
SELECT Location,  MAX(CAST(total_deaths as int)) TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Highest Deathrate by continent
 


--African Countries and DeathCount
SELECT Location,  MAX(CAST(total_deaths as int))as AfricaCount
FROM CovidDeaths
WHERE continent = 'Africa'
GROUP BY Location
ORDER BY AfricaCount DESC


SELECT date, SUM(total_cases) as TotalDeaths
FROM CovidDeaths
WHERE continent = 'Africa'
GROUP BY date
ORDER BY TotalDeaths

SELECT date, SUM(total_cases) as TotalDeaths
FROM CovidDeaths
WHERE continent = 'Europe'
GROUP BY date
ORDER BY TotalDeaths

--DAILY GLOBAL NUMBERS
SELECT date, SUM(new_cases) TotalCases, SUM(CAST(new_deaths AS INT)) TotalDeaths,
SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100 DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

--TOTAL CASES AND DEATHS
SELECT SUM(new_cases) TotalCases, SUM(CAST(new_deaths AS INT)) TotalDeaths,
SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100 DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

WITH PopvsVac (Continent, Location, population, new_vaccinations, RollingPeopleVaccinated) 
as
(
--POPULATIONS AND VACCINATION
SELECT DEA.continent, DEA.Location, DEA.population, VAC.new_vaccinations,
SUM(CONVERT(bigint,VAC.new_vaccinations)) OVER (PARTITION BY DEA.Location ORDER BY DEA.Location, DEA.Date) 
as RollingPeopleVaccinated
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *, (RollingPeopleVaccinated/population) * 100 
FROM PopvsVac


