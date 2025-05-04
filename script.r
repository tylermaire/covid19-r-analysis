# COVID-19 Analysis Script in R using OWID Dataset
# Author: Tyler Maire
# Purpose: Load OWID COVID-19 data and generate visualizations/statistics for portfolio use

# ----------------------
# Load Required Packages
# ----------------------
install.packages(c("tidyverse", "lubridate", "plotly", "zoo", "Kendall"))

library(tidyverse)     # data manipulation and plotting
library(lubridate)     # working with dates
library(plotly)        # interactive plots
library(zoo)           # for rolling averages
library(Kendall)       # Mann-Kendall trend test

# ----------------------
# Load Data
# ----------------------
covid <- read_csv("owid-covid-data.csv")
covid <- covid %>% mutate(date = as_date(date))

# ----------------------
# Define Country Subset
# ----------------------
countries <- c("United States", "India", "Brazil", "United Kingdom", "Germany", "France")
df <- covid %>% filter(location %in% countries)
us <- covid %>% filter(location == "United States")

# ----------------------
# Summary Stats by Country
# ----------------------
summary_stats <- covid %>%
  group_by(location) %>%
  summarize(
    total_cases = max(total_cases, na.rm = TRUE),
    total_deaths = max(total_deaths, na.rm = TRUE),
    max_new_cases = max(new_cases, na.rm = TRUE),
    avg_new_cases = mean(new_cases, na.rm = TRUE)
  )
print(head(summary_stats))

# ----------------------
# US Daily Cases and Deaths Plot
# ----------------------
ggplot(us, aes(x = date)) +
  geom_line(aes(y = new_cases), color = "steelblue", size = 0.8) +
  geom_line(aes(y = new_deaths * 10), color = "darkred", size = 0.8) +
  scale_y_continuous(
    name = "New Cases",
    sec.axis = sec_axis(~./10, name = "New Deaths")
  ) +
  labs(title = "US Daily COVID-19 Cases and Deaths", x = NULL) +
  theme_minimal()

# ----------------------
# US 7-Day Rolling Avg
# ----------------------
us <- us %>% arrange(date) %>% mutate(cases_ma7 = zoo::rollmean(new_cases, 7, fill = NA, align = "right"))
ggplot(us, aes(date)) +
  geom_line(aes(y = cases_ma7), color = "dodgerblue", size = 1.2) +
  labs(title = "US: 7-Day Rolling Avg of New Cases", y = "Cases (7-day avg)") +
  theme_minimal()

# ----------------------
# Multi-Country Comparison (New Cases)
# ----------------------
df5 <- covid %>% filter(location %in% countries)
ggplot(df5, aes(x = date, y = new_cases, color = location)) +
  geom_line(size = 0.8) +
  labs(title = "Daily New Cases: US vs. Other Countries", y = "New Cases", x = NULL) +
  theme_minimal()

# ----------------------
# Policy Stringency Index vs. Cases (US)
# ----------------------
ggplot(us, aes(x = date)) +
  geom_line(aes(y = stringency_index * 1000), color = "purple", size = 0.8) +
  geom_line(aes(y = new_cases), color = "steelblue", size = 0.8) +
  scale_y_continuous(
    name = "New Cases",
    sec.axis = sec_axis(~./1000, name = "Stringency Index")
  ) +
  labs(title = "US: Cases vs. Policy Stringency") +
  theme_minimal()

# ----------------------
# Total Cases (Top Countries)
# ----------------------
top_cases <- covid %>%
  group_by(location) %>%
  summarize(total_cases = max(total_cases, na.rm = TRUE)) %>%
  arrange(desc(total_cases)) %>%
  slice(1:10)

ggplot(top_cases, aes(x = reorder(location, total_cases), y = total_cases / 1e6)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Countries by Total Cases", x = "", y = "Total Cases (millions)") +
  theme_minimal()

# ----------------------
# Case Fatality Rate (CFR)
# ----------------------
deaths_cases <- covid %>%
  group_by(location) %>%
  summarize(
    total_cases = max(total_cases, na.rm = TRUE),
    total_deaths = max(total_deaths, na.rm = TRUE)
  ) %>%
  filter(total_cases > 10000)

ggplot(deaths_cases, aes(x = total_cases, y = total_deaths)) +
  geom_point(color = "tomato", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "gray20") +
  scale_x_log10() + scale_y_log10() +
  labs(title = "Total Deaths vs. Cases (log scale)", x = "Total Cases", y = "Total Deaths") +
  theme_minimal()

# ----------------------
# Vaccination Coverage
# ----------------------
vacc_plot <- covid %>%
  filter(date == max(date) & location %in% countries) %>%
  select(location, people_fully_vaccinated_per_hundred)

ggplot(vacc_plot, aes(x = reorder(location, people_fully_vaccinated_per_hundred), y = people_fully_vaccinated_per_hundred)) +
  geom_col(fill = "darkcyan") +
  coord_flip() +
  labs(title = "% Fully Vaccinated by Country", x = "", y = "% Population") +
  theme_minimal()

# ----------------------
# Statistical Test: t-test for US vs Germany case rates
# ----------------------
usa_cases <- filter(covid, location == "United States")$new_cases_per_million
ger_cases <- filter(covid, location == "Germany")$new_cases_per_million
t.test(usa_cases, ger_cases, alternative = "two.sided", conf.level = 0.95)

# ----------------------
# Mann-Kendall Trend Test on US new cases
# ----------------------
mk <- MannKendall(na.omit(us$new_cases))
print(mk)

# ----------------------
# Correlation Test: Stringency vs Cases (US)
# ----------------------
cor.test(us$stringency_index, us$new_cases, method = "pearson", use = "complete.obs")

# ----------------------
# Done
# ----------------------
message("Analysis complete. Save charts manually or export using ggsave().")

