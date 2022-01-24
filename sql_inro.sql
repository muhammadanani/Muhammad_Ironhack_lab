-- print out all of the database and its contents 
select * from sakila.actor;
select * from sakila.address;
select * from sakila.category;
select * from sakila.city;
select * from sakila.country;
select * from sakila.customer;
select * from sakila.film;
select * from sakila.film_actor;
select * from sakila.film_category;
select * from sakila.film_text;
select * from sakila.inventory;
select * from sakila.language;
select * from sakila.payment ;
select * from sakila.rental;
select * from sakila.staff;
select * from sakila.store;

select title from sakila.film; -- selects only titles from the films table
select name from sakila.language as language; -- alias language name  column in language table as langauge
select language from sakila.language; -- selects language name under new alias language

-- How many stores does the company have (2)
select count(*) from sakila.store;

-- How many employees does the company have (2)
select count(*) from sakila.staff;

-- Return a list of employee first names only 
select first_name from sakila.staff;