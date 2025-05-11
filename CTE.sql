--Average amount paid by top 5 customers (using CTE)
WITH top_10_countries_cte AS
	(SELECT D.country
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	GROUP BY D.country
	ORDER BY COUNT(A.customer_id) DESC
	LIMIT 10
	),
top_10_cities_cte AS
	(SELECT C.city
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE D.country IN (SELECT * FROM top_10_countries_cte)
	GROUP BY D.country, C.city
	ORDER BY COUNT(A.customer_id) DESC
	LIMIT 10
	),
	top_5_customers_cte AS
	(SELECT SUM(E.amount) AS amount_paid
	FROM customer A
	INNER JOIN address B ON A.address_id = B.address_id
	INNER JOIN city C ON B.city_id = C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	INNER JOIN payment E ON A.customer_id = E.customer_id
	WHERE C.city IN (SELECT * FROM top_10_cities_cte)
	GROUP BY A.customer_id
	ORDER BY amount_paid DESC
	LIMIT 5
	)
SELECT AVG(amount_paid)
FROM top_5_customers_cte
