
USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM 
(SELECT inv.film_id,  f.title as title, count(inv.inventory_id)as stock FROM inventory as inv
JOIN film as f
ON inv.film_id = f.film_id
GROUP BY inv.film_id) as stocklist        -- creates a subquery 'stocklist' with a complete inventory list
WHERE title IN ('Hunchback Impossible');  -- parent query execution 
 
-- 2. List all films whose length is longer than the average of all the films.

SELECT film_id, title, length FROM film            -- select relevant columns from parent
	WHERE length > (SELECT avg(length) FROM film); -- compare with average in subquery for filtering

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name FROM actor 				 -- finds actor name based on id
	WHERE actor_id IN (SELECT actor_id FROM film_actor  
		WHERE film_id = (SELECT film_id FROM film 		 -- finds all actor id based on film id 
			WHERE title IN ('Alone Trip')));             -- finds film id for Alone Trip

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  	Identify all movies categorized as family films.

SELECT title as family_film_list FROM film 					  -- step 3: find corresponding names to film ids
	WHERE film_id IN 
		(SELECT film_id FROM film_category 					  -- step 2: finds which film id corresponds to cat 
			WHERE category_id = 
(SELECT category_id FROM category WHERE name IN ('family'))); -- step 1: finds which cat corresponds to family

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- 		Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- 		that will help you get the relevant information.

                                           -- USING SUBQUERY -- 
                                           
SELECT first_name, last_name, email FROM customer WHERE    -- finds customer details based on address id
	address_id IN (SELECT address_id FROM address 		   -- finds address id of all canadian cities
		WHERE city_id IN (SELECT city_id FROM city         -- finds city id of all canadian cities
			WHERE country_id = (SELECT country_id FROM country WHERE country IN ('CANADA')))); -- finds country id

											-- 	USING JOIN --

SELECT  customer.first_name, customer.last_name, customer.email FROM country 
JOIN city
ON country.country_id = city.country_id
JOIN address
ON city.city_id = address.city_id
JOIN customer 
ON address.address_id = customer.address_id
WHERE country = 'CANADA';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted
-- 	 in the most number of films. First you will have to find the most prolific actor and then use that actor_id to 
-- 	 find the different films that he/she starred.

SELECT title as films_prolific FROM film WHERE film_id IN -- finds titles based on film id found in subquery
(SELECT film_id FROM film_actor 
WHERE actor_id =							  -- uses prolific actor id from subquery to find filmid 
(SELECT actor_id FROM film_actor 		      
GROUP BY actor_id                             -- finds actor_id with most appearances
ORDER BY  count(film_id) DESC LIMIT 1));      

	
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find 
-- the most profitable customer ie the customer that has made the largest sum of payments

SELECT title as rented_by_most_profitable_customer FROM film where film_id in -- parent: finds film titles
(SELECT film_id FROM inventory WHERE inventory_id IN  -- subquery3: finds film ids from inventory 
(SELECT inventory_id FROM rental WHERE customer_id =  -- subquery2: finds inventory id 
(SELECT customer_id FROM payment					  -- subquery1: finds customer id from payment
GROUP BY customer_id								  -- aggregates all purchases made by a each unique customer
ORDER BY  sum(amount) DESC LIMIT 1)))				  -- orders to find most profitable customer
ORDER BY rented_by_most_profitable_customer;           -- orders parent query alphabetically

-- 8. Customers who spent more than the average payments.

									-- BASED ON TOTAL AGGREGATED PAYMENTS--
                                    
SELECT last_name, first_name FROM customer   -- parent query finds last and first name
WHERE customer_id							 -- condition: customer id must match customer id from subquery 2)
IN
(SELECT customer_id FROM payment             -- finds customer id that has above average total aggregated payment
GROUP BY customer_id
HAVING sum(amount) >                         -- compares aggregated payment to average, we need above average
(SELECT avg(total_spent) FROM  (SELECT customer_id, sum(amount) as total_spent FROM payment -- subquery 1 finds average payment amount
GROUP BY customer_id) as total_table))
ORDER BY last_name;                          -- orders parent by last name in ascending order


									-- BASED ON INDIVIDUAL PAYMENTS --
                                    
SELECT customer_id, last_name, first_name FROM customer WHERE customer_id IN -- selects name and id based on subquery id match
(SELECT DISTINCT customer_id FROM payment WHERE amount > -- compares customer payments to average then retrieves distinct id
(SELECT avg(amount) FROM payment));       -- finds average individual payment amount
-- all customer have made atleast 1 above average payment 



