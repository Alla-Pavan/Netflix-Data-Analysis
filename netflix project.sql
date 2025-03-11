-- NETFLIX TABLE
DROP TABLE  IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title  VARCHAR(150),
	director VARCHAR(208),
	castS	VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating	VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)

);
SELECT * FROM netflix;


SELECT 
	COUNT(*) AS TOTAL_CONTENT
FROM netflix;

SELECT 
	DISTINCT TYPE 
FROM netflix;

--  15 BUSSINESS PROBLEMS 
-- ANALYSIS
---- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix 
GROUP BY TYPE;


--2. Find the most common rating for movies and TV shows
	
SELECT 
	type,
	rating
FROM
(
	
	select 
		type,
		rating,
		COUNT(*),
		RANK()OVER (PARTITION BY type ORDER BY COUNT(*) DESC)AS ranking
	FROM netflix
	GROUP BY 1,2
	
) AS T1
WHERE 
ranking =1



--3. List all movies released in a specific year (e.g., 2020)

SELECT 
*
FROM netflix
WHERE release_year =2020 and type ='Movie';


--4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST (STRING_TO_ARRAY(country,',')) as new_country,
	count(show_id) as  num_of_shows
from netflix 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--5. Identify the longest movie

SELECT * FROM netflix
WHERE type='Movie'
AND
duration = (select MAX(duration) from netflix);



--6. Find content added in the last 5 years
SELECT 
	*
FROM netflix
WHERE TO_DATE(date_added ,'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5YEARS';


SELECT CURRENT_DATE - INTERVAL '5YEARS'

``
--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'



--8. List all TV shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE type='TV Show'
AND
	SPLIT_PART(duration,' ',1)::numeric >5 

--9. Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY (listed_in,','))AS GENRE,
	COUNT(show_id) AS TOTAL_COUNT
FROM NETFLIX
GROUP BY 1



--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS YEAR,
	COUNT(*) AS yearly_contents,
	ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country ='India' ):: numeric * 100 ,2) AS AVG_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1


--11. List all movies that are documentaries

SELECT * FROM netflix 
WHERE listed_in ILIKE '%documentaries%';


--12. Find all content without a director
SELECT* FROM netfLix
WHERE 
director IS NULL


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT 
*
FROM netflix 
WHERE
casts ILIKE '%Salman Khan%'
AND 
release_year >= EXTRACT(YEAR FROM CURRENT_DATE) -10



--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
COUNT(*) AS TOTAL_movies
FROM netflix
WHERE 
	country ILIKE 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10




/*15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/


WITH new_table
AS
(
SELECT
*,
	CASE
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_content'
		ELSE'Good_content'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1


WHERE 
description ILIKE '%kill%' 
OR
description ILIKE '%violence%' 
