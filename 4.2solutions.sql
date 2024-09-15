USE sakila;
​
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, count(inventory.film_id) AS title
	FROM film
    JOIN inventory
		ON film.film_id = inventory.film_id
		WHERE title = "Hunchback Impossible"
    GROUP BY title;
​
-- 2. List all films whose length is longer than the average of all the films.
SELECT	title, length
	FROM film
	WHERE length > (SELECT AVG(length) FROM film);
​
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id 
	FROM film_actor
	WHERE film_id = (SELECT film_id 
		FROM film WHERE title="Alone Trip"));
​
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film_id IN (SELECT film_id 
	FROM film_category
	WHERE category_id = (SELECT category_id 
		FROM category WHERE name="Family"));
​
-- 5.A Get name and email from customers from Canada using subqueries. 
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id 
	FROM address
	WHERE city_id IN (SELECT city_id 
		FROM city  WHERE country_id = (SELECT country_id
			FROM country WHERE country = "Canada" )));
​
-- 5.B Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email
	FROM customer
	JOIN address
		ON customer.address_id=address.address_id
		JOIN city
			ON address.city_id=city.city_id
			JOIN country
				ON country.country_id=city.country_id
				WHERE country.country="Canada";
​
-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title AS films
FROM film
WHERE film_id IN (SELECT film_id 
	FROM film_actor
    WHERE actor_id = (SELECT actor_id
		FROM (SELECT actor_id, count(film_id) F
			FROM film_actor
			GROUP BY actor_id) AS T1
			WHERE F IN (SELECT MAX(F)
				FROM (SELECT actor_id, count(film_id) F
					FROM film_actor
					GROUP BY actor_id) AS T2)));
​
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
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

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT rental.customer_id as client_id, sum(payment.amount) AS total_amount_spent
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