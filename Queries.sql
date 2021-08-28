/* Query 1 -  We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children, Classics,
Comedy, Family and Music. Create a query that lists each movie, the film category it
is classified in, and the number of times it has been rented out.*/

SELECT f.title AS film_title,
	   ca.name AS category_name,
	   COUNT(r.rental_id) AS rental_count
FROM   film_category AS fc
JOIN   category AS ca
ON     fc.category_id = ca.category_id
JOIN   film AS f
ON     f.film_id = fc.film_id
JOIN   inventory AS i
ON     i.film_id = f.film_id
JOIN   rental AS r
ON     r.inventory_id = i.inventory_id
WHERE  ca.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 2, 1;


/* Query 2 - Now we need to know how the length of rental duration of these family-friendly
movies compares to the duration that all movies are rented for. Can you provide a table with
the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter,
and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies
across all categories? Make sure to also indicate the category that these family-friendly
movies fall into. */

SELECT f.title, ca.name, f.rental_duration,
	   NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM   film AS f
JOIN   film_category AS fc
ON     f.film_id = fc.film_id
JOIN   category AS ca
ON     ca.category_id = fc.category_id
WHERE  ca.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 3;


/* Query 3 - Finally, provide a table with the family-friendly film category, each of the
quartiles, and the corresponding count of movies within each combination of film category
for each corresponding rental duration category. The resulting table should have three
columns: Category, Rental lenght category and Count. */

SELECT t1.name, t1.standard_quartile, COUNT(t1.standard_quartile)
FROM (
	SELECT f.title, ca.name, f.rental_duration,
	       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
	FROM   film AS f
	JOIN   film_category AS fc
	ON     f.film_id = fc.film_id
	JOIN   category AS ca
	ON     ca.category_id = fc.category_id
	WHERE  ca.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	ORDER BY 3) AS t1
GROUP BY 1, 2
ORDER BY 1, 2;


/* Query 4 - We would like to know who were our top 10 paying customers, how many payments
they made on a monthly basis during 2007, and what was the amount of the monthly payments.
Can you write a query to capture the customer name, month and year of payment, and total
payment amount for each month by these top 10 paying customers? */

SELECT DATE_TRUNC('month', p.payment_date) AS pay_month,
	   c.first_name || ' ' || c.last_name AS full_name,
	   COUNT(p.amount) AS pay_countpermon,
	   SUM(p.amount) AS pay_amount
FROM customer AS c
JOIN payment AS p
ON p.customer_id = c.customer_id
WHERE c.first_name || ' ' || c.last_name IN
	(SELECT t1.full_name
	FROM
		(SELECT c.first_name || ' ' || c.last_name AS full_name,
		SUM(p.amount) AS amount_total
		FROM customer AS c
		JOIN payment AS p
		ON p.customer_id = c.customer_id
		GROUP BY 1	
		ORDER BY 2 DESC
		LIMIT 10) AS t1) AND (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
GROUP BY 2, 1
ORDER BY 2, 1, 3;
