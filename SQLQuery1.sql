
select * from PortfolioProject..CovidDeaths$
order by 3,4

select * from PortfolioProject..CovidVaccinations$
order by 3, 4

--select data thatwe are going to be using 

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths$
order by 1,2 desc

-- looking at total cases vs total deaths

select total_cases, total_deaths,(total_deaths/total_cases)*100 as death_percnt
from PortfolioProject..CovidDeaths$
where location like '%Africa%'
order by 3 desc

-- looking at total cases vs population
select location, date, total_cases, Population, (total_cases/population)*100 as DeathPercent
from PortfolioProject..CovidDeaths$
where location like '%Africa%'
order by 3

-- Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as highinfection_count, max((total_cases/population)*100) as DeathPercent
from PortfolioProject..CovidDeaths$
group by location, population
order by 4 desc

select * from PortfolioProject..CovidDeaths$

-- showing countries with highest total death count population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
group by location
order by TotalDeathCount desc

-- CONTINENT
-- cast is used to change the datatype
select location, max(cast(total_deaths as int)) as Totaldeaths
from PortfolioProject..CovidDeaths$
where continent is null
group by location
order by Totaldeaths desc

--GLOBAL NUMBERS

select date, sum(new_cases) as tot_cases, sum(cast(new_deaths as int)) as tot_deaths
from PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2


with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ dea 
join PortfolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

)
select * from PopvsVac

-- TEMP TABLE

DROP table if exists #percent_population_vaccinated
create table #percent_population_vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

select * from #percent_population_vaccinated













