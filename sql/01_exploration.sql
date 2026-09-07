-- Set schema search path
SET search_path TO ecom;
 
-- Discover all tables in the ecom schema
SELECT table_name, ROW_NUMBER() OVER(ORDER BY table_name) 
FROM information_schema.tables 
WHERE table_schema = 'ecom'
ORDER BY table_name;

-- Check all table Content
Select * from ecom.orders;
Select * from ecom.customers;
Select * from ecom.order_items;
Select * from ecom.products;
SELECT * from ecom.product_variants;
SELECT * from ecom.categories;
 
-- Check order volume and date range
SELECT 
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    MIN(created_at) AS earliest_order,
    MAX(created_at) AS latest_order
FROM orders;

-- Count the total number of product categories
SELECT COUNT(*) AS category_count
FROM ecom.categories;

--Count Total Customers 
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM ecom.customers;

--Count Total Revenue
SELECT SUM(total) AS total_revenue
FROM ecom.orders;

-- Average order value
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(SUM(total) / COUNT(*), 2) AS aov
FROM ecom.orders;

-- Revenue per customer
SELECT
    COUNT(DISTINCT customer_id) AS ordering_customers,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(
        SUM(total) / COUNT(DISTINCT customer_id),
        2
    ) AS revenue_per_customer
FROM ecom.orders;

-- Total Revenue per category
SELECT
    c.category_name,
    SUM(oi.line_total) AS total_revenue
FROM ecom.orders o
JOIN ecom.order_items oi
    ON o.order_id = oi.order_id
JOIN ecom.product_variants pv
    ON oi.variant_id = pv.variant_id
JOIN ecom.products p
    ON pv.product_id = p.product_id
JOIN ecom.categories c
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC;

-- Top 10 Product by revenue
SELECT
    p.product_name,
    c.category_name,
    SUM(oi.qty) AS units_sold,
    ROUND(SUM(oi.line_total), 2) AS revenue
FROM ecom.order_items oi
JOIN ecom.product_variants pv
    ON oi.variant_id = pv.variant_id
JOIN ecom.products p
    ON pv.product_id = p.product_id
JOIN ecom.categories c
    ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 Product by Unit Sold
SELECT
    p.product_name,
    c.category_name,
    SUM(oi.qty) AS units_sold,
    ROUND(SUM(oi.line_total), 2) AS revenue
FROM ecom.order_items oi
JOIN ecom.product_variants pv
    ON oi.variant_id = pv.variant_id
JOIN ecom.products p
    ON pv.product_id = p.product_id
JOIN ecom.categories c
    ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY units_sold DESC
LIMIT 10;

-- Revenue Growth per month with percentage
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', created_at)::date AS month,
        SUM(total) AS revenue,
        COUNT(*) AS orders
    FROM ecom.orders
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    orders,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        * 100.0
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
        2
    ) AS revenue_growth_pct,
    ROUND(
        (orders - LAG(orders) OVER (ORDER BY month))
        * 100.0
        / NULLIF(LAG(orders) OVER (ORDER BY month), 0),
        2
    ) AS order_growth_pct
FROM monthly
ORDER BY month;

-- Repeat vs One-Time Customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS order_count
    FROM ecom.orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_pct
FROM customer_orders
GROUP BY customer_type
ORDER BY customers DESC;

-- Return Rate
SELECT
    COUNT(DISTINCT rr.order_id) * 100.0
        / COUNT(DISTINCT o.order_id) AS return_rate_pct
FROM ecom.orders o
LEFT JOIN ecom.return_requests rr
    ON o.order_id = rr.order_id;

--Why are customers returning products?
SELECT
    rr.reason_text,
    SUM(ri.qty) AS returned_units
FROM ecom.return_items ri
JOIN ecom.return_reasons rr
    ON ri.reason_id = rr.reason_id
GROUP BY rr.reason_id, rr.reason_text
ORDER BY returned_units DESC;

-- Sales Conversion Rate
SELECT
    COUNT(DISTINCT o.session_id) AS converted_sessions,
    COUNT(DISTINCT s.session_id) AS total_sessions,
    ROUND(
        COUNT(DISTINCT o.session_id) * 100.0
        / NULLIF(COUNT(DISTINCT s.session_id), 0),
        2
    ) AS conversion_rate_pct
FROM ecom.sessions s
LEFT JOIN ecom.orders o
    ON s.session_id = o.session_id;