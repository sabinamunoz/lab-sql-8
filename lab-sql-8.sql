use sakila;

-- 1. Rank films by length (filter out the rows with nulls or zeros in length column). 
-- Select only columns title, length and rank in your output.
select title, length, rank() over (order by length desc) as 'rank'
from sakila.film
having length is not null or length != 0;

-- 2. Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). 
-- In your output, only select the columns title, length, rating and rank.
select title, length, rating, rank() over (partition by rating order by length desc) as 'rank'
from sakila.film
having length is not null or length != 0;

-- 3. How many films are there for each of the categories in the category table? 
-- Hint: Use appropriate join between the tables "category" and "film_category".
select c.category_id, c.name, count(film_id) 
from film_category as f
join category as c on f.category_id = c.category_id
group by f.category_id;


-- 4. Which actor has appeared in the most films? 
-- Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
select a.first_name, a.last_name, a.actor_id, count(film_id)
from film_actor as f
join actor as a on f.actor_id = a.actor_id
group by a.actor_id
order by count(film_id) desc
limit 1;

-- 5. Which is the most active customer (the customer that has rented the most number of films)? 
-- Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
select c.first_name, c.last_name, c.customer_id, count(rental_id)
from rental as r
join customer as c on r.customer_id = c.customer_id
group by c.customer_id
order by count(rental_id) desc
limit 1;

-- Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
-- Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film.
select sum(counted) as total_rentals, title
from (select count(rental_id) as counted, r.inventory_id, i.film_id, f.title
from sakila.rental r
join sakila.inventory i on r.inventory_id = i.inventory_id
join sakila.film f on i.film_id = f.film_id
group by film_id, inventory_id) as join_table
group by title
order by total_rentals desc
limit 1;