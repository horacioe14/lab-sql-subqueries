#1. How many copies of the film Hunchback Impossible exist in the inventory system?
select  f.film_id, f.title, count(i.inventory_id) as copies_per_film
from sakila.film as f
join sakila.inventory as i
on f.film_id = i.film_id
group by f.film_id
having f.title = 'Hunchback Impossible';


select f.film_id as Film_ID, f.title as Title, count(i.inventory_id) as Inventory
from sakila.inventory as i
join (select film_id, title from sakila.film
        where title = 'Hunchback Impossible') as f
on f.film_id = i.film_id
group by f.film_id;



#2. List all films whose length is longer than the average of all the films.
select film.title, film.length
from sakila.film
where film.length > (select avg(film.length)
from sakila.film)
order by film.length desc;




#3. Use subqueries to display all actors who appear in the film Alone Trip.
select f.film_id as Film_ID, f.title as Title, a.actor_id, a.actor_name
from sakila.film_actor as fa
join (select film_id, title from sakila.film
        where title = 'Alone Trip') as f
on f.film_id = fa.film_id
join (select actor_id, concat(first_name, ' ', last_name) as actor_name from sakila.actor) as a
on a.actor_id = fa.actor_id
group by f.film_id, f.title, a.actor_id;


select f.film_id as Film_ID, f.title as Title, concat(a.first_name, ' ', a.last_name) as actor_name
from sakila.film_actor as fa
join (select film_id, title from sakila.film
        where title = 'Alone Trip') as f
on f.film_id = fa.film_id
join sakila.actor as a
on a.actor_id = fa.actor_id
group by f.film_id, f.title, a.first_name, a.last_name;


#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select *
from sakila.category;

select fc.category_id, c.name, f.film_id as Film_ID, f.title as Title
from sakila.film as f
join (select film_id, category_id from sakila.film_category) as fc
on f.film_id = fc.film_id
join (select category_id, name from sakila.category
	   where name = 'Family') as c
on c.category_id = fc.category_id
group by fc.category_id, c.name, f.film_id, f.title;


#5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select c.country, concat(cu.first_name, ' ', cu.last_name) as customer_name, cu.email
from sakila.customer as cu
join (select address_id, city_id from sakila.address) as a
on a.address_id = cu.address_id
join (select city_id, country_id from sakila.city) as ci
on a.city_id = ci.city_id
join (select country_id, country from sakila.country
	   where country = 'Canada') as c
on ci.country_id = c.country_id;

 
#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select fa.actor_id, a.first_name, a.last_name, count(fa.film_id) as films_acted
from sakila.film_actor as fa
join sakila.actor as a
on fa.actor_id = a.actor_id
group by fa.actor_id, a.first_name
order by films_acted desc
limit 1;

select f.film_id, f.title, fa.actor_id
from sakila.film as f 
join sakila.film_actor as fa
on f.film_id = fa.film_id
where fa.actor_id = 107
group by f.film_id, f.title, fa.actor_id;


select f.film_id, f.title, a.actor_id, concat(a.first_name, ' ', a.last_name) as actor_name
from sakila.film as f
join sakila.film_actor as fa
on f.film_id = fa.film_id
join sakila.actor as a
on a.actor_id = fa.actor_id
where a.actor_id = (  #select only actor_id in subquery. Use =  instead of in 
    select actor_id from (
    select a.actor_id, count(fa.film_id) as films_acted
    from sakila.film_actor as fa
    join sakila.actor as a
    on fa.actor_id = a.actor_id
    group by fa.actor_id, a.first_name
    order by films_acted desc
    limit 1) sub1
);




 
#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select payment.customer_id, sum(payment.amount) as total_amount_spent
from sakila.payment
group by payment.customer_id
order by sum(payment.amount) desc
limit 1;



select f.film_id, f.title, p.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name 
from sakila.payment as p
join sakila.rental as r
on p.rental_id = r.rental_id
join sakila.customer as c
on r.customer_id = c.customer_id
join sakila.inventory as i
on r.inventory_id = i.inventory_id
join sakila.film as f
on f.film_id = i.film_id
where p.customer_id = (  #select only actor_id in subquery. Use =  instead of in 
    select customer_id from (
    select p.customer_id, sum(p.amount) as total_amount_spent
	from sakila.payment as p
	group by p.customer_id
	order by sum(p.amount) desc
	limit 1) sub1
);


#8. Customers who spent more than the average payments.
select concat(c.first_name, ' ', c.last_name) as customer_name, sum(p.amount) as spent_more_than_average
from sakila.payment as p
join sakila.rental as r
on p.rental_id = r.rental_id
join sakila.customer as c
on r.customer_id = c.customer_id
group by customer_name
having sum(p.amount) > (  #select only actor_id in subquery. Use =  instead of in 
    select avg(average_amount_spent) from (
    select sum(p.amount) as average_amount_spent
	from sakila.payment as p
    group by p.customer_id
	) sub1
);


