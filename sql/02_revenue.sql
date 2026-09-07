SET search_path TO ecom;

-- Total orders and Total revenue
SELECT COUNT(DISTINCT order_id) AS total_orders, SUM(line_total) AS total_revenue 
FROM ecom.order_items;

-- Monthly revenue, completed order volume, and AOV
SELECT
    DATE_TRUNC('month', o.created_at)::DATE AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.qty * oi.unit_price)::NUMERIC, 2) AS monthly_revenue,
    ROUND((SUM(oi.qty * oi.unit_price) / COUNT(DISTINCT o.order_id))::NUMERIC, 2) AS average_order_value
FROM ecom.orders o
JOIN ecom.order_items oi ON o.order_id = oi.order_id
WHERE o.payment_status = 'paid'
GROUP BY sales_month
ORDER BY sales_month;

-- MOM revenue growth % and MOM order growth %
WITH monthly AS(
    SELECT 
        DATE_TRUNC('month', o.created_at)::DATE AS sales_month,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(oi.qty * oi.unit_price)::NUMERIC, 2) AS monthly_revenue    
    FROM ecom.orders o
    JOIN ecom.order_items oi ON o.order_id = oi.order_id
    WHERE o.payment_status = 'paid'
    GROUP BY sales_month
    ORDER BY sales_month
)
SELECT sales_month, order_count, monthly_revenue,
    ROUND((monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY sales_month)) * 100.0
    / NULLIF(LAG(monthly_revenue) OVER(ORDER BY sales_month),0),2) 
    AS revenue_growth_pct,
    ROUND((order_count - LAG(order_count) OVER(ORDER BY sales_month)) * 100.0
    / NULLIF(LAG(order_count) OVER(ORDER BY sales_month),0),2) 
    AS order_growth_pct
FROM monthly;
