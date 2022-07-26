USE sakila;

-- 1. How many distinct actor last names are there
SELECT last_name, count(last_name) as num_names
FROM actor
GROUP BY last_name
ORDER BY num_names DESC;

-- 2. Languages
SELECT `language`.`name`
FROM film
JOIN `language`
ON film.language_id=`language`.`language_id`
GROUP BY film.language_id;

-- 3. PG-13
select rating, count(rating)
	from film
    where rating = "PG-13"
    group by rating;
    
-- 4. 10 longest movies from 2006
SELECT title, `length`, release_year
FROM film
WHERE release_year = 2006
order by `length` DESC
LIMIT 10;

-- 5. Days the company has been operating (take the min and max rental date)
SELECT datediff(MAX(rental_date),MIN(rental_date))
FROM rental;

-- 6. rental info month and weekday 
SELECT rental_id, rental_date, MONTH(rental_date) as Month, weekday(rental_date) as Weekday
FROM rental
LIMIT 20;

-- 7. add weekday type
SELECT rental_id, rental_date, MONTH(rental_date) as Month, weekday(rental_date) as Weekday, if(weekday(rental_date) >=5, "Weekend","Workday") as daytype
FROM rental
LIMIT 20;

-- 8. How many rentals in the last month of activity
SELECT count(rental_id)
FROM rental
WHERE rental_date >= (SELECT date_sub(MAX(rental_date), INTERVAL 1 Month) FROM rental);

-- 9. Get film ratings
SELECT rating
FROM film
GROUP by rating;

-- 10. Get release years
SELECT release_year
FROM film
GROUP BY release_year;

-- 11. All films with ARMAGEDDON in the title
SELECT title
FROM film
WHERE title LIKE '%ARMAGEDDON%';

-- 12. APOLLO
SELECT title
FROM film
WHERE title LIKE '%APOLLO%';

-- 13. Ends with Apollo
SELECT title
FROM film
WHERE title REGEXP 'APOLLO$';

-- 14. DATE in the title
SELECT title
FROM film
WHERE title LIKE '%DATE%';

-- 15. 10 films with the longest title
SELECT title, length(title) as tit_length
FROM film
GROUP BY title
ORDER BY tit_length DESC
LIMIT 10;

-- 16. 10 longest films
SELECT title, `length`
FROM film
ORDER BY `length` desc
LIMIT 10;

-- 17. Behind the scenes content
SELECT count(title)
FROM film
WHERE special_features regexp 'behind the scenes';

-- 18. list of films sorted by release year and title
SELECT release_year, title
FROM film
ORDER BY release_year ASC, title ASC;

-- 19. Drop colum
ALTER TABLE staff
DROP COLUMN picture;

-- 20. Insert TAMMY SANDERS into employees and customers
INSERT INTO staff(staff_id, first_name, last_name, address_id, email, store_id, username)
VALUES (34, 'TAMMY', 'SANDERS', 13, 'tammy@sanders.com', 2, 'TammySan');

-- 21. Add rental from Charlotte Hunter
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, staff_id)
VALUES(16050,"2005-08-23 22:50:12", 1, (select customer_id from customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER' LIMIT 1), (select staff_id from staff
where first_name = "MIKE" and last_name = "HILLYER" LIMIT 1));

-- 22. Delete non active users
CREATE TABLE deleted_users AS SELECT * FROM customer WHERE `active`=0;

DELETE FROM customer WHERE `active`=0;