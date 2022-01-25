-- 1. Which actor has appeared in the most films?

SELECT sa.actor_id, sa.first_name, sa.last_name, count(sa.actor_id) as appearances FROM sakila.actor as sa
JOIN sakila.film_actor as sfa
ON sa.actor_id = sfa.actor_id
GROUP BY sa.actor_id
ORDER BY appearances DESC LIMIT 1;

-- 2. Most active customer (the customer that has rented the most number of films)

SELECT sr.customer_id, sc.first_name, sc.last_name, count(sr.customer_id) as activity FROM sakila.rental as sr
JOIN sakila.customer as sc
ON sr.customer_id = sc.customer_id
GROUP BY sr.customer_id
ORDER BY sr.customer_id DESC
LIMIT 1;


-- 3. List number of films per category.

SELECT category_id, count(film_id) count FROM sakila.film_category
GROUP BY category_id
ORDER BY category_id;

-- 4. Display the first and last names, as well as the address, of each staff member.

SELECT staff.address_id, staff.first_name, staff.last_name, address.address_id, address.address FROM sakila.staff as staff
JOIN sakila.address as address
ON staff.address_id = address.address_id;

-- 5. Display the total amount rung up by each staff member in August of 2005.

SELECT py.staff_id,  stf.first_name, stf.last_name, sum(py.amount) as total_rung FROM sakila.payment as py
JOIN sakila.staff as stf
ON py.staff_id = stf.staff_id
GROUP BY py.staff_id;

-- 6. List each film and the number of actors who are listed for that film.

SELECT fl.film_id, fl.title, count(ac.actor_id) as number_actors FROM sakila.film as fl
JOIN sakila.film_actor as ac
ON fl.film_id = ac.film_id
GROUP BY fl.film_id;

-- 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
		
SELECT c.customer_id, c.first_name, c.last_name, sum(py.amount) FROM sakila.customer as c 
JOIN sakila.payment as py
ON c.customer_id = py.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- Bonus: Which is the most rented film?

-- finds film names based on inventory number
SELECT film.film_id, film.title, count(rental.inventory_id) as times_rented FROM sakila.film as film
JOIN sakila.inventory as inv
ON film.film_id = inv.film_id
-- finds number of times rented based on inventory number then groups by film id
JOIN sakila.rental as rental 
ON inv.inventory_id = rental.inventory_id
GROUP BY film.film_id
ORDER BY times_rented DESC LIMIT 1;

             