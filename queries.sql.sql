/* Query 1 - What are the movies families prefer watching and which of these family category movies have been rented out the most?
 */

  WITH t1 AS (

       SELECT

           c.name category_name,
           COUNT(rental_id) rental_count

       FROM

           category c

           JOIN film_category fc ON c.category_id = fc.category_id
           JOIN film f ON f.film_id = fc.film_id
           JOIN inventory i ON i.film_id = f.film_id
           JOIN rental r ON r.inventory_id = i.inventory_id

       GROUP BY
           1)

  SELECT

       category_name,
       rental_count

  FROM

      t1

  WHERE

      category_name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

  GROUP BY
       1,
       2

  ORDER BY
       2 DESC;


/* Query 2 - How do we compare the length of rental duration to the duration that all movies are rented for in the family film category? */

   SELECT

        c.name category_name,
        f.rental_duration rental_duration,
        COUNT (f.film_id) AS movie_count

   FROM

        category c

        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON f.film_id = fc.film_id

   WHERE

        c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

   GROUP BY
        1,
        2

   ORDER BY
        1,
        2;

/* Query 3 - What is the total number of movies available for each genre of movie in the family movie category for each of the quartiles? */

  WITH t1 AS (

        SELECT

           f.title film_title,
           c.name category_name,
           f.rental_duration rental_duration,
           NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile

        FROM

           category c

           JOIN film_category fc ON c.category_id = fc.category_id
           JOIN film f ON f.film_id = fc.film_id

        WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))

 SELECT

     category_name,
     standard_quartile,
     COUNT(category_name) category_count

 FROM

     t1

 GROUP BY
     1,
     2

 ORDER BY
     1,
     2;


/* Query 4 - Who were the top paying customers in 2007, and how much did they pay monthly?
  */

 WITH t1 AS (

        SELECT

            cu.first_name || ' ' || cu.last_name AS full_name,
            p.customer_id,
            SUM(p.amount) total_payment

        FROM

            customer cu

            JOIN payment p ON cu.customer_id = p.customer_id

        GROUP BY
            1,
            2

        ORDER BY
            3 DESC

        LIMIT
            10)

  SELECT

      DATE_TRUNC('month', p.payment_date) AS payment_month,
      t1.full_name,
      COUNT(p.amount) AS paymentcount_per_month,
      SUM(p.amount) AS payment_amount

  FROM
      t1

      JOIN payment p ON t1.customer_id = p.customer_id

  WHERE

     payment_date >= '2007-01-01' AND payment_date < '2008-01-01'

  GROUP BY
     1,
     2

  ORDER BY
     2,
     1;
