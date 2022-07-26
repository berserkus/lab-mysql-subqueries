USE sakila;

-- 1. Number of copies
SELECT count(inventory.inventory_id) as copies
FROM film
JOIN inventory
ON inventory.film_id=film.film_id
WHERE title="HUNCHBACK IMPOSSIBLE";

-- 2. All films whose lenght is longer than average
SELECT	title, length
	FROM film
	WHERE length > (SELECT AVG(length) FROM film);
    
-- 3. Actors from Alone Trip with joins
SELECT actor.actor_id, first_name, last_name
FROM actor
JOIN film_actor
ON actor.actor_id=film_actor.actor_id
JOIN film
ON film.film_id=film_actor.film_id
WHERE title="Alone Trip";

-- 3. Actors from Alone Trip with subqueries
SELECT actor.actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (Select actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title="Alone Trip"));

-- 4. Family movies
SELECT title
FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id= (SELECT category_id FROM category WHERE `name`="Family"));

-- 5. Name and email from Canada with subqueries
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country="Canada")));

-- 5. Name and email from Canada with joins
SELECT first_name, last_name, email
FROM customer
JOIN address
ON customer.address_id=address.address_id
JOIN city
ON address.city_id=city.city_id
JOIN country
ON country.country_id=city.country_id
WHERE country.country="Canada";

-- 6. Most prolific actor
SELECT title, first_name, last_name
FROM actor
JOIN film_actor
ON film_actor.actor_id=actor.actor_id
JOIN film
ON film.film_id=film_actor.film_id
WHERE actor.actor_id = (SELECT actor_id FROM (SELECT actor_id, count(film_id) as num_films FROM film_actor GROUP BY actor_id ORDER BY num_films DESC LIMIT 1) AS hola);

-- 7. Films rented by most profitable customer
SELECT hola.customer_id, film.title
FROM (SELECT rental.customer_id, sum(payment.amount) as tot_rent
FROM rental
JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY rental.customer_id
ORDER BY tot_rent DESC
LIMIT 1) as hola
JOIN rental
ON hola.customer_id=rental.customer_id
JOIN inventory
ON rental.inventory_id=inventory.inventory_id
JOIN film
ON film.film_id=inventory.film_id;

-- 8. Client id and total amount spent above average
SELECT rental.customer_id, sum(payment.amount) AS total_rent
FROM rental
JOIN payment
ON payment.rental_id=rental.rental_id
GROUP BY rental.customer_id
HAVING total_rent > (SELECT AVG(hola.tot_rent) AS average 
FROM (SELECT rental.customer_id, sum(payment.amount) as tot_rent 
FROM rental 
JOIN payment 
ON payment.rental_id=rental.rental_id 
GROUP BY rental.customer_id) as hola)
ORDER BY total_rent DESC;

