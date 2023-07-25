--COVID19 PERSONAL PROJECTS
--EMMANUEL OGAR

Select *
From SQLProjects..Covid19Project
Where continent is not null 
order by 3,4


--SELECT DATA THAT I WILL BE STARTING WITH

Select Location, date, total_cases, total_deaths, population
From SQLProjects..Covid19Project
Where continent is not null 
order by 1,2


--TOTAL CASES VS NEW CASES

Select Location, date, total_cases, new_cases, (new_cases/total_cases)*100 as NewPercentage
From SQLProjects..Covid19Project
where continent = 'Asia'
order by 1,2

--TOTAL CASES VS TOTAL DEATHS

Select Location, Date, Total_cases, Total_deaths, (total_deaths/total_cases)*100 as NewPercentage
From SQLProjects..Covid19Project
--where continent = 'Asia'
order by 1,2

--TOTAL CASES VS POPULATION
--Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From SQLProjects..Covid19Project
--Where continent like 'Asia'
order by 1,2


--CONUTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, Population, MAX(Total_cases) as HighestInfectionCount, Max((Total_cases/population))*100 as PercentPopulationInfected 
From SQLProjects..Covid19Project
--Where Location like 'Afghanistan'
Group by Location, Population
order by PercentPopulationInfected desc

--SHOWING CONTINTENTS WITH THE HIGHEST DEATH PER POPULATION

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From SQLProjects..Covid19Project
--Where continent like 'Asia'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--CONUTRIES CONTINTENTS WITH THE HIGHEST DEATH PER POPULATION

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From SQLProjects..Covid19Project
--Where continent like 'Asia'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- GLOBAL

Select SUM(Total_cases) as TotalCases, SUM(Total_deaths) as TotalDeaths, SUM(Total_deaths)/SUM(Total_cases)*100 as DeathPercentage
From SQLProjects..Covid19Project
--Where continent like 'Asia'
order by 1,2



-- TOTAL POPULATION VS TOTAL DEATHS

Select pro.continent, pro.location, pro.date, pro.population, pro.total_deaths
, SUM(CONVERT(int,pro.total_deaths)) OVER (Partition by pro.Location Order by pro.location, pro.Date) as TotalDeaths
From SQLProjects..Covid19Project pro
where pro.continent is not null 
order by 2,3


--USING TEMP TABLE TO PERFORM CALCULATION

DROP Table if exists #Covid19ProjectDeaths
Create Table #Covid19ProjectDeaths
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
Total_deaths numeric
)

Insert into #Covid19ProjectDeaths
Select pro.continent, pro.location, pro.date, pro.population, prj.total_deaths
, SUM(CONVERT(int,pro.total_deaths)) OVER (Partition by pro.Location Order by pro.location, pro.Date) as deaths
From SQLProjects..Covid19Project pro
Join SQLProjects..Covid19Projects prj
	On pro.location = prj.location
	and pro.date = prj.date
where dea.continent is not null 
order by 2,3

Select *, (deaths/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From SQLProjects..Covid19Project pro
Join SQLProjects..Covid19Projects prj
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


