
/* Covid-19 Data Exploration

Skills used: Aggregate Functions, Converting Data Types, Joins, Windows Functions, CTE's, Temp Tables, Creating Views

*/

Select *
From
	PortfolioProject..CovidDeaths
Where
	continent is not null
Order by 3,4



Select *
From
	PortfolioProject..CovidVaccinations
Order by 3,4



-- Selecting the Data that we will use


Select 
	location,
	date,
	total_cases,
	new_cases,
	total_deaths, 
	population
From
	PortfolioProject..CovidDeaths
Where
	continent is NOT NULL
Order by 
	1,2



-- Looking at the Total Cases Vs Total Deaths

-- Shows the likilhood of dying if you contract Covid-19 in Ghana


Select 
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases) * 100 As Death_Percentage
From
	PortfolioProject..CovidDeaths
Where
	location like '%Ghana%'
	AND continent is NOT NULL
Order by 
	1,2



-- Selecting another Data that we will Use

-- Looking at the Total Vaccinations Vs Total Tests


Select
	location,
	date,
	total_vaccinations,
	total_tests,
	(total_vaccinations) / (total_tests) * 100 AS Percentage_Vaccinated
From
	PortfolioProject..CovidVaccinations
Where
	continent is not null
	--AND location like '%Ghana%'
Order by
	1,2



-- Looking at the Total Cases Per Million Vs Total Deaths Per Million

-- Shows the likilhood of dying if you contract Covid-19 per million in Ghana


Select 
	location,
	date,
	total_cases_per_million,
	total_deaths_per_million,
	ROUND((total_deaths_per_million/total_cases_per_million),4) * 100 As Death_Per_Million
From
	PortfolioProject..CovidDeaths
Where
	location like '%Ghana%'
	AND continent is NOT NULL
Order by 
	1,2



-- Total Cases Vs Population

-- Shows what Percentage of Population Infected with Covid-19 in Ghana


Select 
	location,
	date,
	total_cases,
	population,
	(total_cases/population) * 100 As PercentInfectedPopulation
From
	PortfolioProject..CovidDeaths
Where
	location like '%Ghana%'
	AND continent is not null
Order by 
	1,2



-- Countries With Highest Infection Rate Compared to Population


Select 
	 location
	,population
	,MAX(total_cases) as HighestInfectionCount
	,Max(total_cases/population) * 100 As PercentInfectedPopulation
From
	PortfolioProject..CovidDeaths
Where
	continent is NOT NULL
Group by
	population,
	location
Order by 
	PercentInfectedPopulation DESC



-- Showing the Countries with the Highest Death Count per Population


Select 
	 location
	,MAX(CAST(total_deaths as int)) As TotalDeathCount
From
	PortfolioProject..CovidDeaths
Where
	continent is not null
Group by
	location
Order by 
	TotalDeathCount DESC



-- Showing the Countries with the Least Death Count per Population


Select 
	 location
	,MIN(CAST(total_deaths as int)) As TotalLowDeathCount
From
	PortfolioProject..CovidDeaths
Where
	continent is not null
Group by
	location
Order by 
	TotalLowDeathCount DESC



-- Showing the Countries With the Highest New Cases per Population


Select 
	 location
	,MAX(CAST(new_cases as int)) As TotalNewCasesCount
From
	PortfolioProject..CovidDeaths
Where
	continent is not null
Group by
	location
Order by 
	TotalNewCasesCount DESC



-- Showing the Countries With the Highest Vaccinations per Population


Select
	location,
	MAX(total_vaccinations) As TotalVaccinationCount
From
	PortfolioProject..CovidVaccinations
Where
	continent is not null
Group by
	location
Order by
	TotalVaccinationCount DESC



-- Let's Break Things Down By Continent

-- Showing The Continent With The Highest Death Count Per Population


Select 
	 continent
	,MAX(CAST(total_deaths as int)) As TotalDeathCount
From
	PortfolioProject..CovidDeaths
Where
	continent is not null
Group by
	continent
Order by 
	TotalDeathCount DESC



-- Showing Continent With The Highest Total Tests


Select 
	 continent
	,MAX(CAST(total_tests as int)) As TotalTestCount
From
	PortfolioProject..CovidVaccinations
Where
	continent is not null
Group by
	continent
Order by 
	TotalTestCount DESC



-- Global Numbers

-- Note: For Death Percentage


Select  
	 SUM(new_cases) as Total_cases, 
	 SUM(CAST(new_deaths as int)) as total_deaths,
	 SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From
	PortfolioProject..CovidDeaths
Where
	 continent is NOT NULL
Order by 
	1,2



-- Global Numbers

-- Note: For Vaccination Percentage


Select  
	 SUM(new_tests) as Total_Tests, 
	 SUM(CAST(new_vaccinations as float)) as total_new_vaccinations,
	 SUM(CAST(new_vaccinations AS float))/SUM(new_tests)*100 as VaccinationPercentage
From
	PortfolioProject..CovidVaccinations
Where
	 continent is NOT NULL
Order by 
	1,2



-- Looking at Total Population Vs Vaccinations

-- This shows Percentage of Population that has recieved at least one Covid Vaccine


Select
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION by dea.location Order by dea.location
	,dea.date) AS RollingPeopleVaccinated
From
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where
	dea.continent is not null
Order by
	2,3



-- Using CTE to perform Calculation on Partition By in previous query


With PopvsVac (
	Continent,
	Location,
	Date,
	Population,
	New_vaccinations,
	RollingPeopleVaccinated
	)
as
	(
	Select
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION by dea.location Order by dea.location
	,dea.date) AS RollingPeopleVaccinated
From
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where
	dea.continent is not null
	)
Select *
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query


Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date Datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
	Select
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION by dea.location Order by dea.location
	,dea.date) AS RollingPeopleVaccinated
From
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where
	dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View To Store Data For Later Visualizations


Create View PercentPopulationsVaccinated as
	Select
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION by dea.location Order by dea.location
	,dea.date) AS RollingPeopleVaccinated
From
	PortfolioProject..CovidDeaths dea
JOIN
	PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where
	dea.continent is not null

Select *
From PercentPopulationsVaccinated