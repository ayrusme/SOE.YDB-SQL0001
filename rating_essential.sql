use movie_db;

-- Find the titles of all movies directed by Steven Spielberg.

SELECT title
FROM Movie
WHERE director = "Steven Spielberg";

-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT distinct year
FROM Movie, Rating
WHERE Movie.mID = Rating.mID and stars > 3
ORDER BY year;

-- Find the titles of all movies that have no ratings.

SELECT title
FROM Movie
WHERE mID not in (SELECT mID
from Rating)

-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT name
FROM Reviewer
WHERE rID in (SELECT rID
FROM Rating
WHERE ratingDate is null)

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

SELECT Reviewer.name as "reviewer name", Movie.title as "movie title", Rating.stars as stars, Rating.ratingDate as ratingDate
FROM Rating, Movie, Reviewer
WHERE Rating.rID = Reviewer.rID and Rating.mID = Movie.mID
ORDER BY Reviewer.name, Movie.title, Rating.stars

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

SELECT name, title
FROM Movie
    JOIN Rating r1        USING (mID)
    JOIN Rating r2        USING (rID, mID)
    JOIN Reviewer USING (rID) 
WHERE r1.ratingDate < r2.ratingDate and r1.stars < r2.stars;

-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

SELECT title, max(stars)
FROM movie
    JOIN rating USING (mID) 
GROUP BY title
ORDER BY title

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

SELECT title, max(stars)-min(stars) as "rating spread"
FROM movie
    JOIN Rating USING (mID) 
GROUP BY title
ORDER BY "rating spread" desc, title


-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

SELECT avg(first.stars) - avg(second.stars)
FROM
    (
    SELECT avg(stars) as stars
    from Movie
        JOIN Rating using (mID) 
    GROUP BY title, year
    HAVING year < 1980
    ) as first,
    (
        SELECT avg(stars) as stars
    from Movie
        JOIN Rating using (mID) 
    GROUP BY title, year
    HAVING year > 1980
    ) as second;