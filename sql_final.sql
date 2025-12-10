CREATE VIEW RFM_Analyst AS
WITH rfm_raw AS 
(
    SELECT customer_id
		 , MAX(order_time) as last_order_date
		 , COUNT(order_id) AS frequency
		 , SUM(total_usd) AS monetary
	FROM orders
	GROUP BY customer_id
),

rfm_calculated AS
(
	SELECT
        customer_id
        , DATEDIFF(day, last_order_date, GETDATE()) AS recency
        , frequency
        , monetary
    FROM rfm_raw
),

rfm_scored AS (
    SELECT
		customer_id
	   , recency
	   , frequency
	   , monetary
	   , NTILE(5) OVER (ORDER BY recency ASC) AS R_score
	   , NTILE(5) OVER (ORDER BY frequency DESC) AS F_score
	   , NTILE(5) OVER (ORDER BY monetary DESC) AS M_score
	FROM rfm_calculated
)

SELECT *,
       CONCAT(R_score, F_score, M_score) AS RFM_Segment
FROM rfm_scored
ORDER BY RFM_Segment DESC;

-- -- -- -- -- -- -- New/Existing -- -- -- -- -- -- --
CREATE VIEW NewExisting_Customers AS
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(order_time) AS first_order_date
    FROM orders
    GROUP BY customer_id
),

monthly_orders AS (
    SELECT
        o.customer_id,
        FORMAT(o.order_time, 'yyyy-MM') AS order_month,
        FORMAT(fp.first_order_date, 'yyyy-MM') AS first_month
    FROM orders o
    JOIN first_purchase fp
        ON o.customer_id = fp.customer_id
)

SELECT 
    order_month,
    SUM(CASE WHEN first_month = order_month THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN first_month < order_month THEN 1 ELSE 0 END) AS existing_customers
FROM monthly_orders
GROUP BY order_month
ORDER BY order_month;

-- -- -- -- -- -- -- Cohort -- -- -- -- -- -- -- 
CREATE VIEW Cohort_Analysis AS
WITH t1 AS (
    SELECT 
        o.order_id,
        o.customer_id,
        FORMAT(o.order_time, 'yyyy-MM') AS order_month,
        MIN(FORMAT(o.order_time, 'yyyy-MM')) OVER (PARTITION BY o.customer_id) AS cohort_month
    FROM orders o
),

t2 AS (
    SELECT 
        cohort_month,
        order_month,
        customer_id
    FROM t1
),

t3 AS (
    SELECT 
        cohort_month,
        order_month,
        COUNT(DISTINCT customer_id) AS customers
    FROM t2
    GROUP BY cohort_month, order_month
),

t4 AS (
    SELECT
        cohort_month,
        order_month,
        customers,
        MAX(customers) OVER (PARTITION BY cohort_month) AS first_cohort_size
    FROM t3
)

SELECT
    cohort_month,
    order_month,
    customers,
    CAST(customers AS DECIMAL(10,2)) / first_cohort_size AS retained_rate
FROM t4
