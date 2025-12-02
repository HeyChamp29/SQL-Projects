CREATE DATABASE NETFLIX;

USE NETFLIX;

SELECT * FROM netflix_credits;
SELECT * FROM netflix_titles;




-- ************ QUERIES *****************

-- What were the top 10 movies according to IMDB score?

CREATE VIEW TOP10_MOVIES AS 

SELECT 
	TITLE,
    TYPE,
    IMDB_SCORE
FROM netflix_titles
WHERE TYPE = 'MOVIE'
ORDER BY imdb_score DESC
LIMIT 10;

SELECT * FROM TOP10_MOVIES;

-- Top 10 Shows

CREATE VIEW TOP10_SHOWS AS 

SELECT 
	TITLE,
    TYPE,
    DESCRIPTION,
    RELEASE_YEAR,
    imdb_score
FROM 
netflix_titles
WHERE TYPE = 'SHOW'
ORDER BY imdb_score DESC
LIMIT 10;

SELECT * FROM TOP10_SHOWS;

-- Bottom 10 Movies

CREATE VIEW BOTTOM10_MOVIES AS

SELECT title, 
type, 
imdb_score
FROM netflix_titles
WHERE type = 'MOVIE' AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

SELECT * FROM BOTTOM10_MOVIES;

-- What were the bottom 10 shows according to IMDB score? 


CREATE VIEW BOTTOM10_SHOWS AS 

SELECT 
	TITLE,
    TYPE,
    DESCRIPTION,
    RELEASE_YEAR,
    imdb_score
FROM 
netflix_titles
WHERE TYPE = 'SHOW' AND imdb_score IS NOT NULL
ORDER BY imdb_score 
LIMIT 10;

SELECT * FROM BOTTOM10_SHOWS;


-- 2. How many movies and shows fall in each decade in Netflix's library?

CREATE VIEW DECADE_WISE_SELECTION AS

SELECT CONCAT(FLOOR(release_year/10)*10,'s') AS Decade,
	   COUNT(*) AS movies_shows_count
FROM netflix_titles
GROUP BY CONCAT(FLOOR(release_year/10)*10,'s') 
ORDER BY DECADE;

SELECT * FROM DECADE_WISE_SELECTION;

-- 3. How did age-certifications impact the dataset?

CREATE VIEW AGE_CERTIFICATION_IMPACT AS

SELECT DISTINCT age_certification,
	   ROUND(AVG(imdb_score),2) as imdb_score,
       ROUND(AVG(tmdb_score),2) as tmdb_score
FROM netflix_titles
GROUP BY age_certification
ORDER BY imdb_score DESC;

SELECT * FROM AGE_CERTIFICATION_IMPACT;


-- What were the average IMDB and TMDB scores for shows and movies? 

CREATE VIEW AVG_IMDB_TMDB AS 

SELECT 
	Type,
	ROUND(AVG(imdb_score),2) as AVG_IMDB_SCORE,
    ROUND(AVG(tmdb_score),2) as AVG_TMDB_SCORE
FROM netflix_titles
GROUP BY type;

SELECT * FROM AVG_IMDB_TMDB;


-- What were the 5 most common age certifications for movies?
    
CREATE VIEW TOP5_BY_AGE_CERTIFICATIONS AS
SELECT age_certification,
	   COUNT(*) as certification_count
FROM netflix_titles
WHERE TYPE = 'MOVIE' AND 
age_certification IS NOT NULL
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;

SELECT * FROM TOP5_BY_AGE_CERTIFICATIONS;

-- Who were the top 20 actors that appeared the most in movies/shows? 

CREATE VIEW TOP20_ACTORS AS

SELECT 
	NAME,
    COUNT(*) AS MOST_APPEARED
FROM netflix_credits
WHERE ROLE = 'ACTOR'
GROUP BY NAME
ORDER BY MOST_APPEARED DESC
LIMIT 20;

SELECT * FROM TOP20_ACTORS;


-- Who were the top 20 directors that directed the most movies/shows? 

CREATE VIEW TOP20_DIRECTORS AS

SELECT 
	NAME,
    COUNT(*) AS MOST_APPEARED
FROM netflix_credits
WHERE ROLE = 'DIRECTOR'
GROUP BY NAME
ORDER BY MOST_APPEARED DESC
LIMIT 20;


SELECT * FROM TOP20_DIRECTORS;

-- Calculating the average runtime of movies and TV shows separately

-- METHOD - 1


SELECT
    type,
    CASE 
        WHEN type = 'Movie' THEN ROUND(AVG(runtime),2) 
        WHEN type = 'Show'  THEN ROUND(AVG(runtime),2) 
    END AS avg_runtime
FROM netflix_titles
GROUP BY type;

-- METHOD - 2

SELECT 
    'Movies' AS content_type,
    ROUND(AVG(runtime),2) AS avg_runtime_min
FROM netflix_titles
WHERE type = 'Movie'
UNION ALL
SELECT 
    'Show' AS content_type,
    ROUND(AVG(runtime),2) AS avg_runtime_min
FROM netflix_titles
WHERE type = 'Show';

-- Finding the titles and  directors of movies released on or after 2010

CREATE VIEW MOVIE_RELEASED_AFTER_2019 AS 

SELECT 
	t.title,
    c.name AS director,
    t.release_year
FROM netflix_titles as t
JOIN netflix_credits as c
ON c.id = t.id
WHERE t.type = 'MOVIE'
AND t.release_year >= '2010' 
AND c.role = 'DIRECTOR'
ORDER BY RELEASE_YEAR DESC;

SELECT * FROM MOVIE_RELEASED_AFTER_2019;


-- Which shows on Netflix have the most seasons?

CREATE VIEW MOST_SEASON_ON_NETFLIX AS 

SELECT 
	TITLE,
    SUM(SEASONS) AS MOST_SEASONS
FROM netflix_titles
WHERE TYPE = 'SHOW'
GROUP BY TITLE
ORDER BY MOST_SEASONS DESC;

SELECT * FROM MOST_SEASON_ON_NETFLIX;

-- Which genres had the most movies? 

CREATE VIEW MOST_MOVIES_BY__GENRES AS

SELECT 
	GENRES,
    COUNT(*) AS MOST_MOVIES
FROM NETFLIX_TITLES
WHERE TYPE = 'MOVIE' AND
GENRES IS NOT NULL
GROUP BY GENRES
ORDER BY MOST_MOVIES DESC;

SELECT * FROM MOST_MOVIES_BY__GENRES;

-- Which genres had the most shows? 

CREATE VIEW MOST_SHOWS_BY__GENRES AS

SELECT 
	GENRES,
    COUNT(*) AS MOST_MOVIES
FROM NETFLIX_TITLES
WHERE TYPE = 'SHOW' AND
GENRES IS NOT NULL
GROUP BY GENRES
ORDER BY MOST_MOVIES DESC;

SELECT * FROM MOST_SHOWS_BY__GENRES;


-- Titles and Directors of movies with high IMDB scores (>7.5) and high TMDB popularity scores (>80) 

CREATE VIEW title_director_high_ratings AS
SELECT 
	t.title,
    c.name as DIRECTORS,
    imdb_score,
    tmdb_score
FROM netflix_titles t
JOIN netflix_credits c
ON t.id = c.id
WHERE t.type = 'MOVIE'
AND c.role = 'DIRECTOR'
AND t.imdb_score > 7.5 
AND t.tmdb_score > 8;

SELECT * FROM title_director_high_ratings;

-- What were the total number of titles for each year? 

CREATE VIEW total_titles_by_year AS 
SELECT 
    release_year,
    COUNT(*) as Total_Title
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year DESC;

SELECT * FROM total_titles_by_year;


-- Actors who have starred in the most highly rated movies or shows

CREATE VIEW ACTORS_WITH_HIGHLY_RATED_MOVIES_SHOWS AS 

SELECT c.name AS actor, 
COUNT(*) AS num_highly_rated_titles
FROM netflix_credits AS c
JOIN netflix_titles AS t 
ON c.id = t.id
WHERE c.role = 'actor'
AND (t.type = 'Movie' OR t.type = 'Show')
AND t.imdb_score > 8.0
AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;

SELECT * FROM ACTORS_WITH_HIGHLY_RATED_MOVIES_SHOWS;



-- Which actors/actresses played the same character in multiple movies or TV shows? 

CREATE VIEW Actor_Actress_same_character AS

SELECT c.name AS actor_actress, 
c.character, 
COUNT(DISTINCT t.title) AS num_titles
FROM netflix_credits AS c
JOIN netflix_titles AS t 
ON c.id = t.id
WHERE c.role = 'actor' OR c.role = 'actress'
GROUP BY c.name, c.character
HAVING COUNT(DISTINCT t.title) > 1;

SELECT * FROM Actor_Actress_same_character;
 

-- What were the top 3 most common genres?

CREATE VIEW TOP3_GENRE AS 
SELECT 
	genres,
    COUNT(*) as Count_Genres
FROM netflix_titles
WHERE TYPE = 'MOVIE'
GROUP BY genres
ORDER BY Count_Genres DESC
LIMIT 3;

SELECT * FROM TOP3_GENRE;

-- Average IMDB score for leading actors/actresses in movies or shows 

CREATE VIEW Average_IMDB_score_for_leading_actors_actress AS

SELECT c.name as actors_actress,
	   ROUND(AVG(t.imdb_score),2) as average_imdb_score
FROM netflix_credits c 
JOIN netflix_titles t
ON c.id = t.id
WHERE c.role = 'ACTOR' OR c.role = 'ACTRESS'
AND c.character = 'leading role'
GROUP BY c.name
ORDER BY average_imdb_score DESC;

SELECT * FROM Average_IMDB_score_for_leading_actors_actress;




    

