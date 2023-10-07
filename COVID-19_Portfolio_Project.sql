
SELECT *
FROM PortfolioProject..CovidDeaths$
ORDER BY 3,4

SELECT location, date, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL
ORDER BY 1,2




SELECT location, date, total_cases, total_deaths, (total_Deaths/Total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE Location Like 'Sudan'
AND continent is not NULL
ORDER BY 1,2


SELECT location, date, Population, total_cases,  (Total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--WHERE Location Like 'Sudan'
WHERE continent is not NULL
ORDER BY 1,2

SELECT location, Population, MAX(total_cases) as HighestInfectedCount,  MAX((Total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--WHERE Location Like 'Sudan'
WHERE continent is not NULL
GROUP BY location, Population
ORDER BY PercentPopulationInfected DESC

SELECT continent, MAX(cast(Total_Deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths$
--WHERE Location Like 'Sudan'
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


SELECT  date, total_cases, total_deaths, (total_Deaths/Total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL
ORDER BY 1,2

SELECT  SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not NULL
ORDER BY 1,2



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidDeaths$ dea
 jOIN PortfolioProject..CovidVaccinations$ vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent is NOT NULL
 ORDER BY 2,3

 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as int)) 
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
 WHERE dea.continent is NOT NULL
 ORDER BY 2,3

 CREATE TABLE #PercentPopulationVaccinated(
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 INSERT INTO #PercentPopulationVaccinated 
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as int)) 
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
 WHERE dea.continent is NOT NULL
 ORDER BY 2,3

 SELECT * ,(RollingPeopleVaccinated/Population)*100
 FROM #PercentPopulationVaccinated


CREATE VIEW PercentPopulationVaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(cast(vac.new_vaccinations as int)) 
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date ) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
 JOIN PortfolioProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
 WHERE dea.continent is NOT NULL
-- ORDER BY 2,3
