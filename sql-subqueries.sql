USE sakila;
-- 1 .Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT f.film_id, f.title, (SELECT COUNT(i.film_id) AS inventory_film FROM inventory i WHERE i.film_id = f.film_id) FROM film f
WHERE title= 'Hunchback Impossible';
-- 2 .List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT f.title, f.length FROM film f WHERE f.length > (SELECT AVG(f.length) FROM film f);
-- 3 .Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT a.first_name, a.last_name FROM actor a WHERE a.actor_id IN (SELECT fa.actor_id FROM film_actor fa WHERE fa.film_id IN (SELECT f.film_id FROM film f WHERE f.title = 'Alone Trip'));

-- Bonus:
-- 4 .Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title FROM film f WHERE f.film_id IN (SELECT fc.film_id FROM film_category fc WHERE fc.category_id IN (SELECT c.category_id FROM category c WHERE c.name = 'Family'));
-- 5 .Retrieve the name and email of customers from Canada using both subqueries and joins.
SELECT cus.first_name, cus.last_name, cus.email FROM customer cus INNER JOIN address ad ON ad.address_id = cus.address_id 
WHERE ad.city_id IN (SELECT c.city_id FROM city c WHERE c.country_id IN (SELECT country_id FROM country WHERE country = 'Canada'));  
-- 6 .Determine which films were starred by the most prolific actor in the Sakila database. 
SELECT title FROM film f LEFT JOIN film_actor fa ON fa.film_id = f.film_id 
WHERE fa.actor_id = (SELECT MAX(fa.actor_id) FROM film_actor fa);
-- 7 .Find the films rented by the most profitable customer in the Sakila database.
SELECT f.title FROM film f
INNER JOIN 
    inventory i ON f.film_id = i.film_id
INNER JOIN 
    rental r ON i.inventory_id = r.inventory_id
INNER JOIN 
    customer c ON r.customer_id = c.customer_id
WHERE 
    c.customer_id = (SELECT customer_id FROM (
        SELECT 
            c.customer_id,
            SUM(p.amount) AS total_revenue
        FROM 
            customer c
        INNER JOIN 
            payment p ON c.customer_id = p.customer_id
        GROUP BY 
            c.customer_id
        ORDER BY 
            total_revenue DESC
        LIMIT 1
    ) AS most_profitable_customer)
ORDER BY 
    f.title;
-- 8 .Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT p.customer_id, SUM(p.amount) AS total_revenue FROM payment p GROUP BY p.customer_id HAVING total_revenue > (SELECT AVG(total_amount_spent) FROM (SELECT py.customer_id, SUM(py.amount) AS total_amount_spent FROM payment py GROUP BY py.customer_id) AS calculate_amount_customer);

