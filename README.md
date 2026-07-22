# Netflix Content Analysis

End-to-end analysis of the Kaggle Netflix Titles dataset (8,793 titles), built four ways — Excel, SQL, Python, and Power BI — to demonstrate the same analysis across the core data analytics toolset.

## Problem Statement
Netflix's content catalog spans thousands of titles across countries, genres, and years. This project answers:
- What's the mix of Movies vs TV Shows?
- Which content ratings and genres dominate the catalog?
- Which countries contribute the most content?
- How has content addition volume changed year over year?

## Dataset
- **Source:** [Kaggle — Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- **Size:** 8,793 titles, 12 raw columns (title, director, cast, country, date_added, rating, duration, listed_in, etc.)

## Tools & Deliverables

| Tool | File | What it shows |
|---|---|---|
| **Excel** | `netflix_analysis.xlsx` | Live dashboard with COUNTIF/COUNTIFS/SUMPRODUCT formulas, 5 linked charts, and a Key Findings summary |
| **SQL** | `sql/netflix_analysis.sql` | Schema + GROUP BY/aggregate queries replicating every dashboard metric, plus 4 bonus queries |
| **Python** | `python/netflix_analysis.ipynb` | pandas cleaning + matplotlib/seaborn charts, built to run in Google Colab |
| **Power BI** | `Netflix_Dashboard.pbix`, `powerbi/` | Interactive dashboard with slicers (type, release year), custom Netflix-themed styling, and DAX measures |

## Key Findings
- **Movies dominate** the catalog at 69.7% (6,129 titles) vs TV Shows at 30.3% (2,664).
- **Mature content leads:** TV-MA (3,205) and TV-14 (2,157) together make up over 60% of all titles.
- **India is the #2 content source** (1,008 titles) behind the U.S. (3,205) — ahead of the UK (627) — showing Netflix's strong investment in Indian content.
- **International Movies (2,752) and Dramas (2,426)** are the top two genres, together over 45% of genre tags.
- **Content additions peaked in 2019** (2,016 titles added) and declined through 2020-21, likely tied to pandemic-era production slowdowns.

## How to Use
- **Excel:** open `netflix_analysis.xlsx`, all charts and summary tables recalculate live from the Raw Data sheet.
- **SQL:** run `sql/netflix_analysis.sql` against MySQL/PostgreSQL after loading `python/netflix_titles.csv` into the `netflix_titles` table.
- **Python:** open `python/netflix_analysis.ipynb` in Google Colab, upload `python/netflix_titles.csv` when prompted, and run all cells.
- **Power BI:** open `Netflix_Dashboard.pbix` in Power BI Desktop. Data sources point to `powerbi/netflix_titles_clean.csv` and `powerbi/netflix_genres.csv` — see `powerbi/POWERBI_GUIDE.md` for the full build steps and DAX measures if rebuilding from scratch.

## Power BI Dashboard Preview
The dashboard includes 4 KPI cards, a content-type donut chart, top genres/countries/ratings bar charts, a year-over-year trend chart, and interactive slicers (content type, release year range), all styled with a custom Netflix red/black theme.

## Skills Demonstrated
Excel (formulas, pivot-style summaries, chart building) · SQL (aggregation, joins, window-style grouping) · Python (pandas, data cleaning, matplotlib/seaborn visualization) · Power BI (data modeling, DAX measures, interactive dashboards, custom theming)

---
*Built by Siddharth as part of data analytics portfolio development.*
