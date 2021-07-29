


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
WHERE  ca.name = 'Animation' OR ca.name = 'Children' OR ca.name = 'Classics'
	   OR ca.name = 'Comedy' OR ca.name = 'Family' OR ca.name = 'Music'
GROUP BY 2, 1;


SELECT f.title, ca.name, f.rental_duration,
	   NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM   film AS f
JOIN   film_category AS fc
ON     f.film_id = fc.film_id
JOIN   category AS ca
ON     ca.category_id = fc.category_id
WHERE  ca.name = 'Animation' OR ca.name = 'Children' OR ca.name = 'Classics'
	   OR ca.name = 'Comedy' OR ca.name = 'Family' OR ca.name = 'Music'
ORDER BY 3;














SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) AS total_amt
     FROM(SELECT s.name AS rep_name, r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
             FROM sales_reps AS s
             JOIN accounts AS a
             ON a.sales_rep_id = s.id
             JOIN orders AS o
             ON o.account_id = a.id
             JOIN region AS r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name AS rep_name, r.name AS region_name, SUM(o.total_amt_usd) AS total_amt
     FROM sales_reps AS s
     JOIN accounts AS a
     ON a.sales_rep_id = s.id
     JOIN orders AS o
     ON o.account_id = a.id
     JOIN region AS r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

SELECT a.first_name, 
       a.last_name,
       a.first_name || ' ' || a.last_name AS full_name,
       f.title,
       f.length
FROM   film_actor AS fa
JOIN   actor AS a
ON     fa.actor_id = a.actor_id
JOIN   film AS f
ON     f.film_id = fa.film_id
WHERE f.length > 60;



SELECT actor_id, first_name || ' ' || last_name AS full_name, COUNT(f.film_id)
FROM   actor
GROUP BY 2
ORDER BY 3;



SELECT actor_id, full_name, 
       COUNT(filmtitle) AS film_count_peractor
FROM
    (SELECT a.actor_id AS actor_id,
            a.first_name, 
            a.last_name,
            a.first_name || ' ' || a.last_name AS full_name,
            f.title AS filmtitle
    FROM    film_actor AS fa
    JOIN    actor AS a
    ON      fa.actor_id = a.actor_id
    JOIN    film AS f
    ON      f.film_id = fa.film_id) t1
GROUP BY 1, 2
ORDER BY 3 DESC;



SELECT full_name, 
       filmtitle,
       filmlen,
       CASE WHEN filmlen <= 60 THEN '1 hour or less'
       WHEN filmlen > 60 AND filmlen <= 120 THEN 'Between 1-2 hours'
       WHEN filmlen > 120 AND filmlen <= 180 THEN 'Between 2-3 hours'
       ELSE 'More than 3 hours' END AS filmlen_groups
FROM 
    (SELECT a.first_name, 
               a.last_name,
               a.first_name || ' ' || a.last_name AS full_name,
               f.title AS filmtitle, 
               f.length AS filmlen
        FROM film_actor AS fa
        JOIN actor AS a
        ON fa.actor_id = a.actor_id
        JOIN film AS f
        ON f.film_id = fa.film_id) t1;



SELECT    DISTINCT(filmlen_groups),
          COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylencat
FROM  
         (SELECT title,length,
          CASE WHEN length <= 60 THEN '1 hour or less'
          WHEN length > 60 AND length <= 120 THEN 'Between 1-2 hours'
          WHEN length > 120 AND length <= 180 THEN 'Between 2-3 hours'
          ELSE 'More than 3 hours' END AS filmlen_groups
          FROM film ) t1
ORDER BY filmlen_groups;








