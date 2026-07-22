-- ============================================================
-- NETFLIX CONTENT ANALYSIS — SQL VERSION
-- Replicates the Excel dashboard (Dashboard/Summary sheets)
-- Source: Kaggle Netflix Titles dataset
-- Works on MySQL / PostgreSQL (minor syntax notes below)
-- ============================================================

-- ---------------------------------------------------------
-- 1. TABLE SETUP
-- ---------------------------------------------------------
DROP TABLE IF EXISTS netflix_titles;

CREATE TABLE netflix_titles (
    show_id         VARCHAR(10) PRIMARY KEY,
    type            VARCHAR(20),
    title           VARCHAR(255),
    director        VARCHAR(255),
    cast_members    TEXT,
    country         VARCHAR(255),
    date_added      DATE,
    release_year    INT,
    rating          VARCHAR(10),
    duration        VARCHAR(20),
    listed_in       TEXT,
    description     TEXT,
    year_added      INT,
    month_added     VARCHAR(15),
    duration_value  DECIMAL(6,1),
    duration_unit   VARCHAR(15),
    primary_country VARCHAR(100),
    primary_genre   VARCHAR(100)
);

-- Load data (adjust path; MySQL example)
-- LOAD DATA LOCAL INFILE 'netflix_raw_data.csv'
-- INTO TABLE netflix_titles
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- A separate genre-split table (one row per title-genre pair),
-- mirroring the "Genre Data" sheet, since listed_in holds
-- comma-separated genres in one cell.
DROP TABLE IF EXISTS netflix_genres;

CREATE TABLE netflix_genres (
    show_id VARCHAR(10),
    genre   VARCHAR(100),
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id)
);
-- Populate netflix_genres by splitting listed_in per title
-- (done in Python/pandas before load — see python/netflix_analysis.ipynb)


-- ---------------------------------------------------------
-- 2. DASHBOARD METRICS (top KPI cards)
-- ---------------------------------------------------------

-- Total titles, movies, TV shows, countries represented
SELECT
    COUNT(*)                                            AS total_titles,
    SUM(CASE WHEN type = 'Movie'   THEN 1 ELSE 0 END)   AS movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END)   AS tv_shows,
    COUNT(DISTINCT primary_country)                     AS countries_represented
FROM netflix_titles;


-- ---------------------------------------------------------
-- 3. SUMMARY TABLE 1 — Content by Type
-- ---------------------------------------------------------
SELECT
    type,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix_titles), 1) AS pct_of_total
FROM netflix_titles
GROUP BY type
ORDER BY count DESC;


-- ---------------------------------------------------------
-- 4. SUMMARY TABLE 2 — Content by Rating (Top 10)
-- ---------------------------------------------------------
SELECT rating, COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY count DESC
LIMIT 10;


-- ---------------------------------------------------------
-- 5. SUMMARY TABLE 3 — Top 10 Countries by Content Count
-- ---------------------------------------------------------
SELECT primary_country AS country, COUNT(*) AS count
FROM netflix_titles
GROUP BY primary_country
ORDER BY count DESC
LIMIT 10;


-- ---------------------------------------------------------
-- 6. SUMMARY TABLE 4 — Top 10 Genres
-- ---------------------------------------------------------
SELECT genre, COUNT(*) AS count
FROM netflix_genres
GROUP BY genre
ORDER BY count DESC
LIMIT 10;


-- ---------------------------------------------------------
-- 7. SUMMARY TABLE 5 — Titles Added by Year (Movies vs TV Shows)
-- ---------------------------------------------------------
SELECT
    year_added,
    SUM(CASE WHEN type = 'Movie'   THEN 1 ELSE 0 END) AS movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS tv_shows,
    COUNT(*)                                          AS total
FROM netflix_titles
WHERE year_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;


-- ---------------------------------------------------------
-- 8. BONUS — Extra insights not in the Excel version
--    (good talking points for interviews)
-- ---------------------------------------------------------

-- 8a. Average movie duration by decade of release
SELECT
    (release_year / 10) * 10          AS decade,
    ROUND(AVG(duration_value), 1)     AS avg_duration_min
FROM netflix_titles
WHERE type = 'Movie' AND duration_unit = 'min'
GROUP BY decade
ORDER BY decade;

-- 8b. Top director by number of titles (excluding Unknown)
SELECT director, COUNT(*) AS title_count
FROM netflix_titles
WHERE director <> 'Unknown'
GROUP BY director
ORDER BY title_count DESC
LIMIT 10;

-- 8c. Month-of-year seasonality — when does Netflix add the most content?
SELECT month_added, COUNT(*) AS count
FROM netflix_titles
GROUP BY month_added
ORDER BY count DESC;

-- 8d. India-specific deep dive: genre mix for Indian content
SELECT g.genre, COUNT(*) AS count
FROM netflix_titles t
JOIN netflix_genres g ON t.show_id = g.show_id
WHERE t.primary_country = 'India'
GROUP BY g.genre
ORDER BY count DESC
LIMIT 10;
