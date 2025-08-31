-- ========================================
-- SQL Retail Sales Analysis
-- ========================================

-- Create and use database
CREATE DATABASE sql_project_p1;
USE sql_project_p1;

-- ========================================
-- Create Table
-- ========================================
CREATE TABLE retail_sales (
    transactions_id     INT PRIMARY KEY,
    sale_date           DATE, 
    sale_time           TIME, 
    customer_id         INT,
    gender              VARCHAR(10),
    age                 INT,
    category            VARCHAR(20),
    quantity            INT, 
    price_per_unit      INT,
    cogs                FLOAT,
    total_sale          FLOAT
);

-- ========================================
-- View Sample Data
-- ========================================
SELECT * FROM retail_sales 
LIMIT 5;

-- ========================================
-- Data Exploration
-- ========================================

-- 1. Total number of sales
SELECT COUNT(*) AS total_count 
FROM retail_sales;

-- 2. Total unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales;

-- 3. Total number of categories
SELECT COUNT(DISTINCT category) AS total_categories 
FROM retail_sales;

-- ========================================
-- Data Analysis & Business Key Questions
-- ========================================

-- Q1. Retrieve all sales made on '2022-11-05'
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q2. Transactions in 'Clothing' category with quantity > 4 in November 2022
SELECT * 
FROM retail_sales 
WHERE category = 'Clothing' 
  AND quantity >= 4 
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3. Total sales per category
SELECT 
    category, 
    SUM(total_sale) AS net_sales, 
    COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY category;

-- Q4. Average age of customers in 'Beauty' category
SELECT 
    ROUND(AVG(age), 2) AS average_age, 
    category 
FROM retail_sales 
WHERE category = 'Beauty';

-- Q5. Transactions where total_sale > 1000
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000;

-- Q6. Number of transactions per gender and category
SELECT 
    COUNT(transactions_id) AS total_transactions, 
    category, 
    gender 
FROM retail_sales 
GROUP BY category, gender;

-- Q7. Best-selling month (based on average sale) in each year
SELECT 
    sale_year, 
    sale_month, 
    average_sale 
FROM (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month, 
        ROUND(AVG(total_sale), 2) AS average_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS top_rank
    FROM retail_sales 
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE top_rank = 1;

-- Q8. Top 5 customers based on highest total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9. Number of unique customers per category
SELECT 
    COUNT(DISTINCT customer_id) AS no_of_customers, 
    category 
FROM retail_sales 
GROUP BY category;

-- Q10. Create shifts based on sale time and count number of orders
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;
