-- 1. Total global COVID-19 cases over time
SELECT date, SUM(new_cases) AS global_new_cases
FROM covid_data
GROUP BY date
ORDER BY date;

-- 2. Top 10 countries with the most total deaths
SELECT location, MAX(total_deaths) AS total_deaths
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths DESC
LIMIT 10;

-- 3. Countries with the highest vaccination rates (latest % fully vaccinated)
SELECT location, MAX(people_fully_vaccinated_per_hundred) AS percent_fully_vaccinated
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY percent_fully_vaccinated DESC
LIMIT 10;

-- 4. Daily new cases for the United States (last 30 days of available data)
SELECT date, new_cases
FROM covid_data
WHERE location = 'United States'
  AND new_cases IS NOT NULL
ORDER BY date DESC
LIMIT 30;

-- 5. Countries with highest deaths per million (peak values)
SELECT location, MAX(total_deaths_per_million) AS deaths_per_million
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY deaths_per_million DESC
LIMIT 10;

-- 6. Global stringency index trend (average by date)
SELECT date, ROUND(AVG(stringency_index), 2) AS avg_stringency_index
FROM covid_data
WHERE stringency_index IS NOT NULL
GROUP BY date
ORDER BY date;

-- 7. Total tests conducted by country (latest available)
SELECT location, MAX(total_tests) AS total_tests
FROM covid_data
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_tests DESC
LIMIT 10;

-- 8. Countries with lowest case fatality rate (CFR = deaths / cases)
SELECT location,
       MAX(total_deaths) / MAX(total_cases) AS case_fatality_rate
FROM covid_data
WHERE total_deaths IS NOT NULL AND total_cases > 100000 AND continent IS NOT NULL
GROUP BY location
ORDER BY case_fatality_rate ASC
LIMIT 10;

-- 9. Total vaccinations given globally by date
SELECT date, SUM(new_vaccinations) AS global_new_vaccinations
FROM covid_data
WHERE new_vaccinations IS NOT NULL
GROUP BY date
ORDER BY date;

-- 10. Top 10 countries with the most ICU patients at any point
SELECT location, MAX(icu_patients) AS peak_icu_patients
FROM covid_data
WHERE icu_patients IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY peak_icu_patients DESC
LIMIT 10;
