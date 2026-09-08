SET search_path TO ecom;

-- Customer segmentation based on order generated
WITH customer_spend AS(
    SELECT c.customer_id , 
        COUNT(DISTINCT o.order_id) total_orders,
        COALESCE(SUM(oi.unit_price * oi.qty), 0) AS customer_lifetime_spend
    FROM ecom.customers c
    LEFT JOIN ecom.orders o ON c.customer_id = o.customer_id
    LEFT JOIN ecom.order_items oi ON o.order_id = oi.order_id 
    GROUP BY c.customer_id
)
SELECT 
    CASE
        WHEN total_orders = 1 THEN '1. One-Time Buyer (1 order)'
        WHEN total_orders BETWEEN 2 AND 4 THEN '2. Repeat Buyer (2-4 orders)'
        WHEN total_orders >= 5 THEN '3. VIP Buyer (5+ order)'
        ELSE '4. Inactive/ No orders'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(customer_lifetime_spend) AS total_revenue,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() , 2) AS pct_customer,
    ROUND(SUM(customer_lifetime_spend) * 100.0 
        / SUM(SUM(customer_lifetime_spend)) OVER(), 2) AS pct_revenue,
    ROUND(AVG(customer_lifetime_spend),2) AS avg_customer_spend
FROM customer_spend 
GROUP BY customer_segment
ORDER BY customer_segment;


SELECT table_name,
        column_name,
        data_type
FROM information_schema.columns
WHERE table_schema = 'ecom'
ORDER BY table_name;