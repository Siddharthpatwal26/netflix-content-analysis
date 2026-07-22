# Netflix Content Analysis — Power BI Build Guide

Two data files are provided, pre-cleaned so you can skip most Power Query steps:
- `netflix_titles_clean.csv` — main fact table (8,793 rows, one row per title)
- `netflix_genres.csv` — bridge table (19,297 rows, one row per title-genre pair, for genre analysis)

---

## Step 1: Import the data
1. Open **Power BI Desktop** → **Get Data** → **Text/CSV**
2. Import both `netflix_titles_clean.csv` and `netflix_genres.csv`
3. In Power Query Editor, confirm data types:
   - `date_added` → Date
   - `year_added`, `release_year`, `duration_value` → Whole Number
   - Everything else → Text
4. Click **Close & Apply**

## Step 2: Build the relationship
1. Go to the **Model** view (left sidebar)
2. Drag `show_id` from `netflix_titles_clean` onto `show_id` in `netflix_genres`
3. Set cardinality: **One (titles) to Many (genres)**, cross-filter direction: **Single**

This mirrors the Excel "Genre Data" sheet and the SQL `netflix_genres` table — same star-schema idea.

## Step 3: Add DAX measures
Right-click `netflix_titles_clean` → **New Measure**, add each of these:

```dax
Total Titles = COUNTROWS(netflix_titles_clean)

Total Movies = CALCULATE([Total Titles], netflix_titles_clean[type] = "Movie")

Total TV Shows = CALCULATE([Total Titles], netflix_titles_clean[type] = "TV Show")

% Movies = DIVIDE([Total Movies], [Total Titles])

% TV Shows = DIVIDE([Total TV Shows], [Total Titles])

Countries Represented = DISTINCTCOUNT(netflix_titles_clean[primary_country])

Avg Movie Duration (min) =
CALCULATE(
    AVERAGE(netflix_titles_clean[duration_value]),
    netflix_titles_clean[type] = "Movie",
    netflix_titles_clean[duration_unit] = "min"
)

YoY Titles Added = 
VAR CurrentYear = [Total Titles]
VAR PriorYear =
    CALCULATE([Total Titles], DATEADD(netflix_titles_clean[date_added], -1, YEAR))
RETURN
    DIVIDE(CurrentYear - PriorYear, PriorYear)
```

## Step 4: Build the report page (mirrors the Excel dashboard)

| Visual | Fields | Type |
|---|---|---|
| KPI cards (top row) | `[Total Titles]`, `[Total Movies]`, `[Total TV Shows]`, `[Countries Represented]` | Card |
| Content Mix | `type` (legend), `[Total Titles]` (values) | Donut/Pie chart |
| Content by Rating | `rating` (axis), `[Total Titles]` (values), sort descending, Top N filter = 10 | Bar chart |
| Top 10 Countries | `primary_country` (axis), `[Total Titles]` (values), Top N filter = 10 | Bar chart |
| Top 10 Genres | `genre` (from `netflix_genres` table, axis), count of rows (values), Top N = 10 | Bar chart |
| Titles Added by Year | `year_added` (axis), `type` (legend), `[Total Titles]` (values) | Stacked column chart |

## Step 5: Add slicers (this is where Power BI beats Excel — real interactivity)
Add slicers for:
- `type` (Movie / TV Show)
- `release_year` (range slider)
- `rating`

This lets a viewer filter the whole dashboard live — click "TV Show" and every chart updates. This is the single biggest differentiator to highlight vs. the Excel version in interviews.

## Step 6: Theme
- Use a custom theme with Netflix red (`#B81D24`) and dark gray/black (`#221F1F`) to match the Excel dashboard styling — **Format → Themes → Browse for themes**, or apply colors manually per visual.

## Step 7: Publish (optional)
If you have a Power BI (free) account: **Home → Publish** → publishes to Power BI Service, gives you a shareable link — good for putting directly in your resume/LinkedIn instead of just a screenshot.

---

### Why this matters for your portfolio
Excel shows you can build formula-driven analysis. SQL and Python show query/scripting ability. **Power BI shows you can build interactive, stakeholder-facing dashboards** — the actual deliverable most Data Analyst roles ask for day-to-day. Having all four in one repo covers the full toolset.
