
-- Create TABLE
CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT

)

SELECT * FROM retail_sales

SELECT 
	COUNT(*)
FROM retail_sales

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

-- Data Cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
	gender IS NULL
	OR
	age	IS NULL
	OR
	category IS NULL
	OR
	quantiy	IS NULL
	OR
	price_per_unit	IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
	gender IS NULL
	OR
	age	IS NULL
	OR
	category IS NULL
	OR
	quantiy	IS NULL
	OR
	price_per_unit	IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Data Exploration
-- How many sales
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many customers
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- How many customers
SELECT DISTINCT category  FROM retail_sales

-- Data Analysis & Business Key Problems
-- Sales on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Transactions where the category is 'Clothing' and the quantity sold is more than 4 in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'
	AND
	quantiy >= 4
GROUP BY 1

-- Total sales for each category
SELECT 
	category,
	SUM(total_sale) AS Total_Sales
FROM retail_sales
GROUP BY 1

--Average age of customers from the 'Beauty' category
SELECT 
	ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty'

--Transactions where the total_sale is greater than 100
SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- Total number of transactions made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY
 category,
 gender
ORDER BY 1

-- Average sale for each month and determine the best selling month in each year
SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) AS T1
WHERE rank = 1

-- Top 5 customers based on highest total sales
SELECT
 customer_id,
 SUM (total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Number of unique customers who purchsed items from each category
SELECT
	category,
	COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY category

-- Create shifts and number of orders for each
WITH hourly_sales 
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift

--End of Project
	
	