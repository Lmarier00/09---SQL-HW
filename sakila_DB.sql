USE sakila;

/*1a Display first and last names of all actors from actor table*/
SELECT first_name, last_name FROM actor;

/*1b Display first and last names of each actor in a single column in upper case*/
SELECT CONCAT(first_name, ' ' ,last_name) AS Actor_Name
FROM actor;

/*2a Find ID Number, first and last name of actor named Joe*/
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name LIKE 'Joe';

/*2b Last names that contain GEN*/
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%gen%';

/*2c Last names that contain LI*/
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name;

/*2d Display country ID and country columns*/
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/*3a Create a new column in actor table with data type BLOB*/
ALTER TABLE actor
ADD description BLOB NOT NULL;

/*3b Drop column that was created in 3a*/
ALTER TABLE actor DROP COLUMN description;

/*4a List last names and how many actors have that name*/
SELECT DISTINCT last_name, COUNT(last_name) AS 'name_count' 
FROM actor GROUP BY last_name;

/*4b Same as 4a but only list the last name if 2 or more actors share it*/
SELECT DISTINCT last_name, COUNT(last_name) AS 'name_count'
FROM actor GROUP BY last_name HAVING name_count >= 2;

/*4c Change Groucho Williams to Harpo Williams*/
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

/*see how many actors are named Groucho*/
SELECT first_name, last_name FROM actor
ORDER BY first_name;

/*4d Change Harpo Williams to Groucho Williams*/
UPDATE actor SET first_name = CASE WHEN first_name = 'HARPO' THEN 'GROUCHO'
ELSE 'MUCHO GROUCHO' END WHERE actor_id = 172;

/*5a Search for address table*/
SHOW CREATE TABLE address; 

/*6a Join staff and address tables*/
SELECT staff.first_name, staff.last_name, address.address, address.address2
FROM address
INNER JOIN staff
ON staff.address_id = address.address_id;

/*6b Join staff and payment tables*/
SELECT staff.first_name, staff.last_name,
SUM(payment.amount) AS total_sales
FROM staff INNER JOIN payment ON 
staff.staff_id = payment.staff_id 
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;

/*6c Join table film and film_actor*/
SELECT title, COUNT(actor_id) AS actor_count
FROM film INNER JOIN film_actor
ON film.film_id = film_actor.film_id 
GROUP BY title;

/*6d # of copies of Hunchback Impossible*/
SELECT title, COUNT(inventory_id) 
AS film_copies
FROM film INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible'; 

/*6e  Join payment and customer tables*/
SELECT first_name, last_name, SUM(payment.amount) 
AS total_purchase
FROM customer INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY last_name;

/*7a Display movie titles beginning with K or Q*/
 SELECT title
 FROM film 
 WHERE language_id IN
 (
  SELECT language_id
  FROM language
  WHERE name = 'English' 
  AND (title LIKE "K%")
  OR (title LIKE "Q%")
  ); 
  
  /*7b Use subqueries to display cast of Alone Trip*/  
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
	FROM film
	WHERE title = 'Alone Trip'
  )
 );
  
SELECT * FROM customer_list;  

/*7c Canadian customers and addresses*/
SELECT customer.last_name, customer.first_name, customer.email 
FROM customer
INNER JOIN customer_list
ON customer.customer_id = customer_list.ID
WHERE customer_list.country = 'Canada';
    
SELECT * FROM category; 

/*7d Display films in the Family category*/
SELECT title 
FROM film
WHERE film_id IN
( 
  SELECT film_id 
  FROM film_category 
  WHERE category_id IN
  (
   SELECT category_id 
   FROM category 
   WHERE name = 'Family'   
  )
 ); 
 
/*7e Display most frequently rented movies*/
SELECT f.title, count(*) AS total_count
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
GROUP BY i.film_id 
ORDER BY COUNT(*) DESC;

/*7f Sales revenue of all stores*/
SELECT store.store_id, SUM(amount) AS sales_revenue
FROM store 
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment 
ON payment.staff_id = staff.staff_id 
GROUP BY store.store_id;

/*7g Display store, store ID, city and country*/
SELECT store.store_id, city.city, country.country 
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id 
INNER JOIN country
ON city.country_id = country.country_id;

/*7h Top five genres*/
SELECT name, SUM(p.amount) AS gross_revenue
FROM category c 
INNER JOIN film_category fc
ON fc.category_id = c.category_id
INNER JOIN inventory i 
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
RIGHT JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC LIMIT 5;

/*8a Create view for top five genres*/
CREATE VIEW top_five_genres
AS SELECT name, SUM(p.amount) AS gross_revenue
FROM category c
INNER JOIN film_category fc
ON fc.category_id = c.category_id
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
RIGHT JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC LIMIT 5;

/*8b Display view created in 8a*/
SELECT * FROM top_five_genres;

/*8c Delete view*/
DROP VIEW top_five_genres;