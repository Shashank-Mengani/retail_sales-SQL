
CREATE TABLE IF NOT EXISTS retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

		SELECT * FROM retail_sales
		LIMIT 20;

		SELECT COUNT(*) FROM retail_sales;

		SELECT * FROM retail_sales
		WHERE 
		    transaction_id IS NULL
		    OR
		    sale_date IS NULL
		    OR 
		    sale_time IS NULL
		    OR
		    gender IS NULL
		    OR
		    category IS NULL
		    OR
		    quantity IS NULL
		    OR
		    cogs IS NULL
		    OR
		    total_sale IS NULL;

--Delete Null values
	DELETE FROM retail_sales
	WHERE
		transaction_id IS NULL
		OR
		sale_date IS NULL
		OR 
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

	SELECT COUNT(*) AS total_sales FROM retail_sales;

	SELECT COUNT(DISTINCT customer_id) AS customers FROM retail_sales;

-- Level 1 - SELECT & Filtering
-- Find all transactions where category = 'Clothing'.
	SELECT *
	FROM retail_sales
	WHERE category = 'Clothing';
	
-- Find customers whose age is greater than 40.
	SELECT * 
	FROM retail_sale
	WHERE age > 40;
	
-- Display sales where category is either Beauty or Electronics.
	SELECT *
	FROM retail_sales
	WHERE category IN ('Beauty', 'Electronics');
	
-- Find transactions whose total sale is between 500 and 1500.
	SELECT *
	FROM retail_sales
	WHERE total_sale BETWEEN 500 AND 1500;

-- Level 2 - Sorting & Limiting
-- Show the top 10 highest sales.
	SELECT *
	FROM retail_sales
	ORDER BY total_sale DESC
	LIMIT 10;
	
-- Display the oldest customers.
	SELECT *
	FROM retail_sales
	WHERE age = (
	    SELECT MAX(age)
	    FROM retail_sales
	);
	
-- Find the cheapest product sold.
	SELECT *
	FROM retail_sales
	WHERE price_per_unit = (
	    SELECT MIN(price_per_unit)
	    FROM retail_sales
	) LIMIT 1;

-- Display all Electronics sales sorted by highest amount.
	SELECT *
	FROM retail_sales
	WHERE category = 'Electronics'
	ORDER BY total_sale DESC;

-- Level 3 – Aggregate Functions
-- Find total sales.
	SELECT SUM(total_sale) AS total_sales
	FROM retail_sales;
	
-- Find average sale amount.
	SELECT AVG(total_sale) AS average_sale
	FROM retail_sales;
	
-- Find maximum sale.
	SELECT MAX(total_sale) AS highest_sale
	FROM retail_sales;
	
-- Count distinct customers.
	SELECT COUNT(DISTINCT customer_id)
	FROM retail_sales;
	
-- Find total profit (Total Sales − COGS).
	SELECT SUM(total_sale - cogs) AS total_profit
	FROM retail_sales;

-- Level 4 - GROUP BY
-- Total sales by category.
	SELECT category,
	       SUM(total_sale) AS total_sales
	FROM retail_sales
	GROUP BY category;
	
-- Number of transactions per category.
	SELECT category,
	       COUNT(*) AS transaction_count
	FROM retail_sales
	GROUP BY category;
	
-- Highest sale in each category.
	SELECT category,
	       MAX(total_sale) AS highest_sale
	FROM retail_sales
	GROUP BY category;
	
-- Average sale amount by gender.
	SELECT gender,
	       AVG(total_sale) AS average_sale
	FROM retail_sales
	GROUP BY gender;

-- Level 5 - HAVING
-- Categories having total sales greater than 10000.
	SELECT category,
	       SUM(total_sale) AS total_sales
	FROM retail_sales
	GROUP BY category
	HAVING SUM(total_sale) > 10000;
	
-- Genders having average sales greater than 700.
	SELECT gender, AVG(total_sale) AS avg_sale
	FROM retail_sales
	GROUP BY gender
	HAVING AVG(total_sale) > 700;
	
-- Customers who spent more than 5000 in total.
	SELECT customer_id,
	       SUM(total_sale) AS total_spent
	FROM retail_sales
	GROUP BY customer_id
	HAVING SUM(total_sale) > 5000;
	
-- Categories whose average quantity sold is greater than 3.
	SELECT category,
	       AVG(quantity) AS avg_quantity
	FROM retail_sales
	GROUP BY category
	HAVING AVG(quantity) > 3;
	
-- Level 6 - Date & Time Analysis
-- Find sales made in January.
	SELECT *
	FROM retail_sales
	WHERE EXTRACT(YEAR FROM sale_date) = 2022
	  AND EXTRACT(MONTH FROM sale_date) = 1;
	  
-- Which month had the highest sales?
	SELECT EXTRACT(MONTH FROM sale_date) AS month,
	       SUM(total_sale) AS total_sales
	FROM retail_sales
	GROUP BY EXTRACT(MONTH FROM sale_date)
	ORDER BY total_sales DESC
	LIMIT 1;
	
-- Daily sales report.
	SELECT *
	FROM retail_sales
	WHERE EXTRACT(DAY FROM sale_date) = 5;
	
-- Average sale by hour.
	SELECT EXTRACT(HOUR FROM sale_time) AS hour,
	       AVG(total_sale) AS average_sale
	FROM retail_sales
	GROUP BY EXTRACT(HOUR FROM sale_time)
	ORDER BY hour;
	
-- Level 7 - Business Analysis
-- Top 10 customers by spending.
	SELECT customer_id, SUM(total_sale) AS spending
	FROM retail_sales
	GROUP BY customer_id
	LIMIT 10;
	
-- Top 5 highest transactions.
	SELECT transaction_id,
       total_sale
	FROM retail_sales
	ORDER BY total_sale DESC
	LIMIT 5;
	
-- Which category generated the most revenue?
	SELECT category,
	       SUM(total_sale) AS total_revenue
	FROM retail_sales
	GROUP BY category
	ORDER BY total_revenue DESC
	LIMIT 1;
	
-- Which category sold the most quantity?
	SELECT category,
	       SUM(quantity) AS total_quantity
	FROM retail_sales
	GROUP BY category
	ORDER BY total_quantity DESC
	LIMIT 1;
	
-- Average spending per customer.
	SELECT customer_id,
	       AVG(total_sale) AS avg_spending
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY avg_spending DESC;
	
-- Customer with the maximum number of purchases.
	SELECT customer_id,
	       COUNT(*) AS purchases
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY purchases DESC
	LIMIT 1;
	
-- Most popular category among female customers.
	SELECT category,
	       SUM(quantity) AS total_quantity
	FROM retail_sales
	WHERE gender='Female'
	GROUP BY category
	ORDER BY total_quantity DESC
	LIMIT 1;
	
-- Revenue contribution (%) by each category.
	SELECT category,
	       ROUND(
	           SUM(total_sale) * 100.0 /
	           (SELECT SUM(total_sale) FROM retail_sales),
	           2
	       )::numeric AS contribution_percent
	FROM retail_sales
	GROUP BY category;

-- Profit by category.
	SELECT category,
	       SUM(total_sale - cogs) AS profit
	FROM retail_sales
	GROUP BY category
	ORDER BY profit DESC;

-- Level 8 - Scalar Subqueries
-- Find customers whose spending is above the average customer spending.
	SELECT customer_id, SUM(total_sale) AS spending
	FROM retail_sales
	GROUP BY customer_id 
	HAVING SUM(total_sale) > (
	SELECT AVG(customer_spend) FROM 
	(
	SELECT SUM(total_sale) AS customer_spend FROM retail_sales
	GROUP BY customer_id
	) AS avg_spend
	);

-- Find categories whose revenue is above the average revenue.
	SELECT category, SUM(total_sale) AS revenue
	FROM retail_sales
	GROUP BY category 
	HAVING SUM(total_sale) > (
	SELECT AVG(category_revenue) FROM
	(
	SELECT SUM(total_sale) AS category_revenue FROM retail_sales
	GROUP BY category
	) AS avg_revenue
	);

-- Find transactions above the average transaction value.
	SELECT transaction_id, total_sale 
	FROM retail_sales
	WHERE total_sale > (
	SELECT AVG(total_sale)
	FROM retail_sales
	);

-- Level 8 - CTE
-- Find the category with the highest revenue.
	WITH category_revenue AS
	(
	SELECT category, SUM(total_sale) AS total_revenue
	FROM retail_sales
	GROUP BY category
	)
	SELECT category, total_revenue
	FROM category_revenue
	ORDER BY total_revenue DESC
	LIMIT 1;

-- Find customers spending above average.
	WITH customer_spend AS
	(
		SELECT customer_id, SUM(total_sale) AS spending
		FROM retail_sales
		GROUP BY customer_id
	)
	SELECT customer_id, spending
	FROM customer_spend
	WHERE spending >
	(
	SELECT AVG(spending)
	FROM customer_spend
	); 
