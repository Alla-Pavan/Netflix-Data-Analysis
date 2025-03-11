# Netflix Movies And TV Shows Data-Analysis Using Sql
![NetflixLogo](https://github.com/Alla-Pavan/Netflix-Data-Analysis/blob/main/logo.png)
##Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

Objectives
Analyze the distribution of content types (movies vs TV shows).
Identify the most common ratings for movies and TV shows.
List and analyze content based on release years, countries, and durations.
Explore and categorize content based on specific criteria and keywords.
Dataset
The data for this project is sourced from the Kaggle dataset:

Dataset Link: Movies Dataset
Schema
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
Business Problems and Solutions
1. Count the Number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix 
GROUP BY TYPE;
Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows
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


3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT 
*
FROM netflix
WHERE release_year =2020 and type ='Movie';
Objective: Retrieve all movies released in a specific year.

4. Find the Top 5 Countries with the Most Content on Netflix
SELECT 
	UNNEST (STRING_TO_ARRAY(country,',')) as new_country,
	count(show_id) as  num_of_shows
from netflix 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

Objective: Identify the top 5 countries with the highest number of content items.

5. Identify the Longest Movie

SELECT * FROM netflix
WHERE type='Movie'
AND
duration = (select MAX(duration) from netflix);
Objective: Find the movie with the longest duration.

6. Find Content Added in the Last 5 Years
SELECT 
	*
FROM netflix
WHERE TO_DATE(date_added ,'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5YEARS';

Objective: Retrieve content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
Objective: List all content directed by 'Rajiv Chilaka'.

8. List All TV Shows with More Than 5 Seasons

SELECT 
	*
FROM netflix
WHERE type='TV Show'
AND
	SPLIT_PART(duration,' ',1)::numeric >5 
Objective: Identify TV shows with more than 5 seasons.

9. Count the Number of Content Items in Each Genre
SELECT
	UNNEST(STRING_TO_ARRAY (listed_in,','))AS GENRE,
	COUNT(show_id) AS TOTAL_COUNT
FROM NETFLIX
GROUP BY 1

Objective: Count the number of content items in each genre.

10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS YEAR,
	COUNT(*) AS yearly_contents,
	ROUND(COUNT(*)::numeric/ (SELECT COUNT(*) FROM netflix WHERE country ='India' ):: numeric * 100 ,2) AS AVG_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
Objective: Calculate and rank years by the average number of content releases by India.

11. List All Movies that are Documentaries

SELECT * FROM netflix 
WHERE listed_in ILIKE '%documentaries%';

Objective: Retrieve all movies classified as documentaries.

12. Find All Content Without a Director
SELECT* 
FROM netfLix
WHERE 
director IS NULL

Objective: List content that does not have a director.

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT 
*
FROM netflix 
WHERE
casts ILIKE '%Salman Khan%'
AND 
release_year >= EXTRACT(YEAR FROM CURRENT_DATE) -10
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
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

Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
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

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


