# COVID-19 SQL Project

This project demonstrates how to ingest and analyze the [Our World in Data (OWID)](https://docs.owid.io/projects/covid/en/latest/) COVID-19 dataset using **MySQL Server 9.3** via the Windows command line. The dataset contains global COVID-19 data such as cases, deaths, testing, vaccinations, stringency index, and demographic factors.

> ✅ Over 429,000 rows imported and queryable locally with SQL.

---

## 📁 Files Included

- `script.sql` – Creates the database and table, and loads the OWID CSV into MySQL.
- `owid-covid-data.csv` – The original dataset from OWID. [Download it here](https://covid.ourworldindata.org/data/owid-covid-data.csv)
- `queries.sql` – 10 analytical SQL queries exploring deaths, vaccinations, testing, CFR, and ICU usage.

---

## 🧰 Tools Used

- **MySQL Server 9.3**
- **Windows 11 (Command Prompt)**
- Optional extensions: Power BI / R for visualization

---

## ⚙️ How to Run

### Step 1: Enable `local_infile`

Open MySQL and run:

```sql
SET GLOBAL local_infile = 1;

