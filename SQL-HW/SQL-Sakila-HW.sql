USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT upper(concat(first_name,' ', last_name)) as 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	-- What is one query would you use to obtain this information?
SELECT first_name, last_name, actor_id from actor WHERE first_name LIKE 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name from actor WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name from actor WHERE last_name LIKE '%li%';

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country from country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so
	-- create a column in the table actor named description and use the data type BLOB 
    -- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) as 'Last Name Count' from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
	-- but only for names that are shared by at least two actors
SELECT last_name, count(last_name) as 'Last Name Count' from actor group by last_name HAVING (count(last_name)) > 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor where first_name = 'GROUCHO';

START TRANSACTION;
UPDATE actor 
SET first_name = 'HARPO'
WHERE actor_id = 172;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
	-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
ROLLBACK;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a
ON s.address_ID = a.address_ID;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT CONCAT(first_name, ' ', last_name) as 'Name', SUM(amount) as 'Total Payment'
FROM staff s
INNER JOIN payment p
ON s.staff_ID = p.staff_ID
GROUP BY first_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_ID) as 'Number of Actors'
FROM film f
INNER JOIN film_actor fa
ON f.film_ID = fa.film_ID
GROUP BY title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, count(inventory_id) as 'Count in Inventory'
FROM film f
INNER JOIN inventory i
ON f.film_ID = i.film_ID
GROUP BY title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
	-- List the customers alphabetically by last name:
SELECT last_name, first_name, sum(amount) as 'Total Paid'
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
	-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
    -- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title 
FROM film 
WHERE (title LIKE 'K%' OR 'Q%')
AND language_id=(SELECT language_id FROM language WHERE name='English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of 
	-- all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email 
FROM customer c
JOIN address a ON (c.address_id = a.address_id)
JOIN city cit ON (a.city_id = cit.city_id)
JOIN country cy ON (cit.country_id = cy.country_id);

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
	-- Identify all movies categorized as family films.
SELECT title 
FROM film f
JOIN film_category fc ON (f.film_id=fc.film_id)
JOIN category c ON (fc.category_id=c.category_id);

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS 'Rent_Count'
FROM film f
JOIN inventory i ON (f.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_ID)
GROUP BY title 
ORDER BY Rent_Count DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
FROM payment p
JOIN staff s 
ON p.staff_id = s.staff_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select store_ID, city, country
from store s
JOIN address a ON a.address_ID = s.address_ID
JOIN city c ON c.city_id = a.city_ID
JOIN country cy ON c.country_id = cy.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT c.name AS "Top 5 Genres", SUM(p.amount) AS "Gross Revenue"
FROM category c
JOIN film_category fc ON (c.category_id = fc.category_id)
JOIN inventory i ON (fc.film_id = i.film_id)
JOIN rental r ON (i.inventory_id = r.inventory_id)
JOIN payment p ON (r.rental_id = p.rental_id)
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
	-- Use the solution from the problem above to create a view. 
/*** 
CREATED VIEW IN SAKILA VIEWS BUILDER. VIEW NAME IS TOP_FIVE
***/

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW fop_five;

