-- Total rows
select count(*) from consumers;
select count(*) from consumer_preferences;
select count(*) from restaurants;
select count(*) from restaurant_cuisines;
select count(*) from ratings;

-- Check NULLs in key columns
SELECT COUNT(*) FROM consumers WHERE Consumer_ID IS NULL;
SELECT COUNT(*) FROM restaurants WHERE Restaurant_ID IS NULL;
SELECT COUNT(*) FROM ratings WHERE Consumer_ID IS NULL OR Restaurant_ID IS NULL;

-- Ratings linked to consumers and restaurants
SELECT COUNT(*)
FROM ratings ra
JOIN consumers c ON ra.Consumer_ID = c.Consumer_ID
JOIN restaurants r ON ra.Restaurant_ID = r.Restaurant_ID;

SELECT COUNT(*) FROM ratings;

-- Using the WHERE clause to filter data based on specific criteria.
-- 1.List all details of consumers who live in the city of 'Cuernavaca'.
select *
from consumers
where city = 'Cuernavaca';

-- Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students'
 -- AND are 'Smokers'.
 select consumer_id, age, occupation
 from consumers
 where occupation ='Student' and smoker = 'Yes';
 -- List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & 
 -- Beer' and have a 'Medium' price level.
 
 select Name, city, Alcohol_service, price
 from restaurants
 where Alcohol_Service = 'Wine & Beer' and price ='Medium';
 
 -- Find the names and cities of all restaurants that are part of a 'Franchise'.
 select name,city
 from restaurants
 where Franchise = 'Yes';
 
 -- Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the
 -- Overall_Rating was 'Highly Satisfactory' (which corresponds to a value of 2, according
 -- to the data dictionary).

 select Consumer_Id, Restaurant_ID, Overall_Rating
 from ratings
 where overall_rating = 2;
 
 -- Questions JOINs with Subqueries
 -- List the names and cities of all restaurants that have an Overall_Rating of 2 
 -- (Highly Satisfactory) from at least one consumer.
 
 select DISTINCT r.name, r.city
 from restaurants r
 join ratings ra
 on r.Restaurant_ID = ra.Restaurant_ID
 where ra.overall_rating = 2;

-- Find the Consumer_ID and Age of consumers who have rated restaurants located in 
-- 'San Luis Potosi'.

select distinct c.consumer_ID, c.Age
from consumers c
join ratings ra
on c.consumer_id = ra.consumer_id
join restaurants r
on r.restaurant_id = ra.restaurant_id
where r.city = 'San Luis Potosi';

-- List the names of restaurants that serve 'Mexican' cuisine and have been rated by 
-- consumer 'U1001'.
Select r.name
from restaurants r
join restaurant_cuisines rc
on r.Restaurant_ID = rc.Restaurant_ID
join ratings ra
on r.Restaurant_ID = ra.Restaurant_ID
where rc.Cuisine = 'Mexican'
AND ra.consumer_id = 'U1001';

-- Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
select distinct c.* 
from consumers c
join consumer_preferences cp
on c.consumer_id = cp.consumer_id
where cp.preferred_cuisine = 'American'
and c.BUdget = 'Medium';

-- List restaurants (Name, City) that have received a Food_Rating lower than the average 
-- Food_Rating across all rated restaurants.

select distinct r.name, r.city
from restaurants r
join ratings ra
on r.restaurant_id = ra. restaurant_id
where (ra.food_rating) < (select avg(food_rating) from ratings);

-- Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant but
-- have NOT rated any restaurant that serves 'Italian' cuisine.
select c.Consumer_ID, c.Age, c.Occupation
from consumers c
join ratings ra
on c.consumer_id = ra.consumer_id
where c.consumer_id not in 
	( select ra.consumer_id
	  from ratings ra
      join restaurant_cuisines rc
      on ra.restaurant_id = rc.restaurant_id
      where rc.cuisine = 'Italian'
      );
-- List restaurants (Name) that have received ratings from consumers older than 30.
select distinct re.name
from restaurants re
join ratings ra
on re.restaurant_id = ra.restaurant_id 
join consumers c 
on ra.consumer_id = c.consumer_id
where c.age > 30;

-- Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' 
-- and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).

select c.consumer_id, c.occupation
from consumers c
join consumer_preferences cp
on c.consumer_id = cp.consumer_id
join ratings ra
on ra.consumer_id = c.consumer_id
where cp.Preferred_Cuisine = 'Mexican'
and ra.Overall_Rating = 0;

-- List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in 
-- a city where at least one 'Student' consumer lives.

select r.name, r.city
from restaurants r
join restaurant_cuisines rc
on r.restaurant_id = rc.restaurant_id
where rc.cuisine = 'Pizzeria'
and r.city in ( select city
from consumers where occupation = 'Student');

-- Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant
-- that has 'No' parking.

SELECT DISTINCT c.Consumer_ID, c.Age
FROM consumers c
JOIN ratings ra
ON c.Consumer_ID = ra.Consumer_ID
JOIN restaurants r
ON ra.Restaurant_ID = r.Restaurant_ID
WHERE c.Drink_Level = 'Social Drinker'
  AND r.Parking = 'No';
-- Questions Emphasizing WHERE Clause and Order of Execution

-- List Consumer_IDs and the count of restaurants they've rated, but only for consumers who 
-- are 'Students'. Show only students who have rated more than 2 restaurants.

select c.consumer_id,count(ra.restaurant_id)
from consumers c
join ratings ra
on c.consumer_id = ra.consumer_id
where c.occupation = 'Student'
group by c.consumer_id
having count(ra.restaurant_id) > 2;

-- We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10
-- (integer division). List the Consumer_ID, Age, and this calculated Engagement_Score, but 
-- only for consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation

select consumer_id, age, age div 10 as Engagement_Score
from consumers
where (age div 10) = 2
and transportation_method = 'Public';


-- For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name,
-- City, and its calculated average Overall_Rating, but only for restaurants located in 
-- 'Cuernavaca' AND whose calculated average Overall_Rating is greater than 1.0.

select r.name, r.city, avg(ra.overall_rating) as Avg_Rating
from restaurants r
join ratings ra
on r.restaurant_id = ra.restaurant_id
where city = 'Cuernavaca'
group by r.restaurant_id,r.Name, r.City
having avg(ra.overall_rating) > 1;

-- Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any 
-- restaurant is equal to their Service_Rating for that same restaurant, but only consider 
-- ratings where the Overall_Rating was 2.

select c.consumer_id, c.age
from consumers c
join ratings ra
on c.consumer_id = ra.consumer_id
where c.marital_status = 'Married'
      and ra.overall_rating = 2
      and ra.food_rating = ra.service_rating;

-- List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers
--  who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located 
-- in 'Ciudad Victoria'.

select c.consumer_id, c.age, r.name
from consumers c
join ratings ra
on c.consumer_id = ra.consumer_id
join restaurants r
on ra.restaurant_id = r.restaurant_id
where c.occupation = 'Employed'
 and ra.food_rating = 0
 and r.city = 'Ciudad Victoria';

-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures

-- Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, 
-- Age, and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.

with SLP_Consumers As(
     select consumer_id, age
	 from consumers 
     where city = 'San Luis Potosi'
     )
select s.consumer_id, s.age, r.name
from SLP_Consumers s
join ratings ra 
on s.consumer_id = ra.consumer_id
join restaurants r
on r.restaurant_id = ra. restaurant_id
join restaurant_cuisines rc 
on r.Restaurant_ID = rc.Restaurant_ID
where rc.cuisine = 'Mexican'
  AND ra.Overall_Rating = 2;
;
 
-- For each Occupation, find the average age of consumers. Only consider consumers who have 
-- made at least one rating. (Use a derived table to get consumers who have rated). 
select c.occupation, AVG(c.age) as Avg_Age
from(
select distinct consumer_id
from ratings) RatedConsumers
join consumers c 
on RatedConsumers.Consumer_ID = c.Consumer_ID
group by c.occupation;

-- Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings within
-- each restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID,
-- Overall_Rating, and the RatingRank.

with Rated_restaurrant as(
SELECT r.Restaurant_ID, ra.Consumer_ID, ra.Overall_Rating
    FROM restaurants r
    JOIN ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT *,
       RANK() OVER (
           PARTITION BY Restaurant_ID
           ORDER BY Overall_Rating DESC
       ) AS RatingRank
FROM  Rated_restaurrant;

-- For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the 
-- average Overall_Rating given by that specific consumer across all their ratings.

select Consumer_ID,
    Restaurant_ID,
    Overall_Rating,
    avg(overall_rating) over(partition by consumer_id) as Consumer_Avg_Rating
    from ratings;
    
-- Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, 
-- list their top 3 most preferred cuisines based on the order they appear in the 
-- Consumer_Preferences table (assuming no explicit preference order, use Consumer_ID, 
-- Preferred_Cuisine to define order for ROW_NUMBER).

with Student_Budget as (
select consumer_id from 
consumers 
where occupation = 'Student'
and budget = 'Low'),
RankedPreferences as (
select cp.consumer_id,
cp.preferred_cuisine,
row_number() over(
        PARTITION BY cp.Consumer_ID
            ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine
        ) AS rn
FROM consumer_preferences cp
    JOIN Student_Budget lbs
    ON cp.Consumer_ID = lbs.Consumer_ID
)
SELECT Consumer_ID, Preferred_Cuisine
FROM RankedPreferences
WHERE rn <= 3;
	
 -- Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the 
 -- Restauranterall_Rating, and the Overall_Rating of the next restaurant they rated (if any),
 -- ordered by Restaurant_ID (as a proxy for time if rating time isn't available).
 -- Use a derived table to filter for the consumer's ratings first.
 
 SELECT
    Restaurant_ID,
    Overall_Rating,
    LEAD(Overall_Rating) OVER (ORDER BY Restaurant_ID) AS Next_Overall_Rating
FROM (
    SELECT Restaurant_ID, Overall_Rating
    FROM ratings
    WHERE Consumer_ID = 'U1008'
) AS U1008_Ratings;

-- Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, 
-- and City of all Mexican restaurants that have an average Overall_Rating greater than 1.5.

create view  HighlyRatedMexicanRestaurants as
select  r.Restaurant_ID, r.Name, r.City
from restaurants r
join restaurant_cuisines rc
on   r.Restaurant_ID =   rc.Restaurant_ID
join ratings ra
on   r.Restaurant_ID =   ra.Restaurant_ID
where rc.Cuisine = 'Mexican'
Group by r.r.Restaurant_ID, r.Name, r.City
Having avg(ra.overall_rating) > 1.5;

select * from highlyratedmexicanrestaurants;
select * from restaurants;

 -- First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. Then, using a CTE 
 -- to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who 
 -- have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.

 -- checking the view
select * from highlyratedmexicanrestaurants;
 
 with MexicanLovers as(
      select distinct consumer_id
      from consumer_preferences
    WHERE Preferred_Cuisine = 'Mexican'
)
select ml.consumer_id
from MexicanLovers ml
WHERE NOT EXISTS (
    SELECT r.Consumer_ID
    FROM ratings r
    JOIN HighlyRatedMexicanRestaurants h
        ON r.Restaurant_ID = h.Restaurant_ID
    WHERE r.Consumer_ID = ml.Consumer_ID
);
-- Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID 
-- and a minimum Overall_Rating as input. It should return the Consumer_ID, Overall_Rating,
-- Food_Rating, and Service_Rating for that restaurant where the Overall_Rating meets or
--  exceeds the threshold.

Delimiter //

create procedure  GetRestaurantRatingsAboveThreshold (
    IN p_restaurant_id INT,
    IN p_min_rating INT
    )
    Begin
    select 
        Consumer_ID,
        Overall_Rating,
        Food_Rating,
        Service_Rating
    FROM ratings
    where restaurant_id =  p_restaurant_id
    and   Overall_Rating >= p_min_rating;
    END //
    Delimiter ;

Call GetRestaurantRatingsAboveThreshold(101,2);

-- Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type.
--  If there are ties in rating, include all tied restaurants. Display Cuisine, 
-- Restaurant_Name, City, and Overall_Rating.

WITH RestaurantAvgRatings AS (
    SELECT
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name AS Restaurant_Name,
        r.City,
        AVG(ra.Overall_Rating) AS Overall_Rating
    FROM restaurants r
    JOIN restaurant_cuisines rc
        ON r.Restaurant_ID = rc.Restaurant_ID
    JOIN ratings ra
        ON r.Restaurant_ID = ra.Restaurant_ID
    GROUP BY
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name,
        r.City
),
RankedRestaurants AS (
    SELECT
        Cuisine,
        Restaurant_Name,
        City,
        Overall_Rating,
        RANK() OVER (
            PARTITION BY Cuisine
            ORDER BY Overall_Rating DESC
        ) AS Cuisine_Rank
    FROM RestaurantAvgRatings
)
SELECT
    Cuisine,
    Restaurant_Name,
    City,
    Overall_Rating
FROM RankedRestaurants
WHERE Cuisine_Rank <= 2;

-- First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their
-- average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by 
-- their average overall rating. For these top 5 consumers, list their Consumer_ID, their 
-- average rating, and the number of 'Mexican' restaurants they have rated.

WITH TopConsumers AS (
    SELECT
        Consumer_ID,
        Avg_Overall_Rating
    FROM ConsumerAverageRatings
    ORDER BY Avg_Overall_Rating DESC
    LIMIT 5
)
SELECT
    tc.Consumer_ID,
    tc.Avg_Overall_Rating,
    COUNT(DISTINCT r.Restaurant_ID) AS Mexican_Restaurant_Count
FROM TopConsumers tc
LEFT JOIN ratings ra
    ON tc.Consumer_ID = ra.Consumer_ID
LEFT JOIN restaurant_cuisines rc
    ON ra.Restaurant_ID = rc.Restaurant_ID
    AND rc.Cuisine = 'Mexican'
LEFT JOIN restaurants r
    ON ra.Restaurant_ID = r.Restaurant_ID
GROUP BY
    tc.Consumer_ID,
    tc.Avg_Overall_Rating;
-- Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a
-- Consumer_ID as input.
-- The procedure should:
-- Determine the consumer's "Spending Segment" based on their Budget:
-- 'Low' -> 'Budget Conscious'
-- 'Medium' -> 'Moderate Spender'
-- 'High' -> 'Premium Spender'
-- NULL or other -> 'Unknown Budget'

Delimiter //
 create procedure GetConsumerSegmentAndRestaurantPerformance 
    ( IN input_Consumer_ID varchar(30))
    -- Determine consumer's spending segment
    Begin
    select
    Consumer_id,
    budget,
    CASE
       WHEN Budget = 'Low' THEN 'Budget Conscious'
       WHEN Budget = 'Medium' THEN 'Moderate Spender'
       WHEN Budget = 'High' THEN 'Premium Spender'
	   ELSE 'Unknown Budget'
       END AS Spending_Segment
   from consumers
   where Consumer_id = input_consumer_id;

-- 2.For all restaurants rated by this consumer:
-- List all restaurants rated by the consumer with performance info
      -- Calculate restaurant performance efficiently
    WITH RestaurantAverage AS (
        SELECT 
            Restaurant_ID,
            AVG(Overall_Rating) AS Avg_Rating_All_Consumers
        FROM ratings
        GROUP BY Restaurant_ID
    )
    SELECT 
        r.Name AS Restaurant_Name,
        ra.Overall_Rating AS Consumer_Rating,
        ra_avg.Avg_Rating_All_Consumers,
        CASE
            WHEN ra.Overall_Rating > ra_avg.Avg_Rating_All_Consumers THEN 'Above Average'
            WHEN ra.Overall_Rating = ra_avg.Avg_Rating_All_Consumers THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,
        RANK() OVER (ORDER BY ra.Overall_Rating DESC) AS Rating_Rank
    FROM ratings ra
    JOIN restaurants r ON ra.Restaurant_ID = r.Restaurant_ID
    JOIN RestaurantAverage ra_avg ON ra.Restaurant_ID = ra_avg.Restaurant_ID
    WHERE ra.Consumer_ID = input_Consumer_ID;
End //
Delimiter ; 

CALL GetConsumerSegmentAndRestaurantPerformance('U1001');

