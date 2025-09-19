-- 기본 작동은 mode로, 한눈에 보기 쉽게 git으로 정리
-- 1: 기본 세팅
SELECT *
FROM tutorial.us_housing_units;

-- 2: SQL SELECT
SELECT 
  year,
  west,
  south,
  northeast,
  month_name,
  month,
  midwest
FROM tutorial.us_housing_units;

SELECT 
  year AS "Year",
  west AS "West",
  south AS "South",
  northeast AS "Northeast",
  month_name AS "Month_name",
  month AS "Month",
  midwest AS "Midwest"
FROM tutorial.us_housing_units;

-- 3: SQL LIMIT
SELECT 
  year AS "Year",
  west AS "West",
  south AS "South",
  northeast AS "Northeast",
  month_name AS "Month_name",
  month AS "Month",
  midwest AS "Midwest"
FROM tutorial.us_housing_units
LIMIT 15;

-- 5: SQL Comparison Operators
SELECT *
FROM tutorial.us_housing_units
WHERE west > 50;

SELECT *
FROM tutorial.us_housing_units
WHERE south <= 20;

SELECT *
FROM tutorial.us_housing_units
WHERE month_name = 'February';

SELECT *
FROM tutorial.us_housing_units
WHERE month_name < 'O';

SELECT west + south + northeast + midwest  AS sum_regions
FROM tutorial.us_housing_units;

SELECT
  west,
  midwest,
  northeast
FROM tutorial.us_housing_units
WHERE west > (midwest + northeast);

SELECT
  west / (west+northeast+midwest+south)*100 AS per_west,
  south / (west+northeast+midwest+south)*100 AS per_south,
  northeast / (west+northeast+midwest+south)*100 AS per_northeast,
  midwest / (west+northeast+midwest+south)*100 AS per_midwest
FROM tutorial.us_housing_units
WHERE year >= 2000 ;

-- 7: SQL LIKE
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name ilike '%ludacris%';

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name LIKE 'DJ%';

-- 8: SQL IN
# Hammer 이름 확인
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name ILIKE '%Hammer%';

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name IN ('M.C. Hammer', 'Hammer', 'Elvis Presley');

-- 9: SQL BETWEEN
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1985 AND 1990
LIMIT 100;

-- 10: SQL IS NULL
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name IS NULL;

-- 11: SQL AND
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name ILIKE '%ludacris%'
  AND year_rank <= 10;

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank = 1
  AND year IN (1990, 2000, 2010);

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1960 AND 1969
  AND song_name ILIKE '%love%';

-- 12: SQL OR
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10
  AND (group_name ILIKE '%Katy Perry%' OR group_name ILIKE '%Bon Jovi%');

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name ILIKE '%California%'
  AND (year BETWEEN 1970 AND 1979 
    OR year BETWEEN 1990 AND 1999);

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name LIKE '%Dr. Dre%'
  AND (year < 2001 OR year >= 2009);

-- 13: SQL NOT
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013
  AND song_name NOT LIKE '&a&';

-- 14: SQL ORDER BY
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2012
ORDER BY song_name DESC;

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2010
ORDER BY year_rank, artist;

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name LIKE '%T-Pain%'
ORDER BY year_rank DESC;

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank BETWEEN 10 AND 20 -- 10위에서 20위 랭킹
  AND year IN (1993, 2003, 2013) -- 해당 년도 설정 
ORDER BY year, year_rank;
