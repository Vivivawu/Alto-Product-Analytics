SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN customer_added_non_med_to_order = true THEN 1 ELSE 0 END) AS orders_with_non_med_items,
    (SUM(CASE WHEN customer_added_non_med_to_order = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_with_non_med_items
FROM modealto.checkout_attempts;
--3.26% of the user is currently adding non-med items to their order

SELECT 
customer_added_non_med_to_order, 
COUNT(customer_added_non_med_to_order),
AVG(order_total_dollars) AS average_order_total FROM modealto.checkout_attempts 
WHERE customer_added_non_med_to_order IS NOT NULL
GROUP BY customer_added_non_med_to_order;
-- Average order $ for customer not adding non-med is 20, whereas the $$ for customer adding med is 30

-- Estimating Revenue Increase: assume the change will increase visibility to 20%
SELECT 
    total_revenue_before,
    total_revenue_after,
    (total_revenue_after - total_revenue_before) AS increased_revenue,
    ((total_revenue_after - total_revenue_before) / total_revenue_before) * 100.00 AS increased_revenue_percentage
FROM (
    SELECT 
        SUM(order_total_dollars) AS total_revenue_before,
        (COUNT(customer_added_non_med_to_order) * 0.2 * 30.1027 + COUNT(customer_added_non_med_to_order) * 0.8 * 19.9565) AS total_revenue_after
    FROM modealto.checkout_attempts
    WHERE customer_added_non_med_to_order IS NOT NULL
) AS calculations;
--if the change increase visibility and have 20% of customers add non-med products, revenue will increase by 7.05%

-- More sophisticated method: Moving on to Python for advance machine learning and data analysis
-- Remove values where 'customer_added_non_med_to_order' is null: meaning we can't understand customer behavior from these null values
SELECT * FROM modealto.checkout_attempts WHERE customer_added_non_med_to_order IS NOT NULL;

-- SELECT customer_added_non_med_to_order, COUNT(*) FROM (SELECT * FROM modealto.checkout_attempts WHERE customer_added_non_med_to_order IS NOT NULL) as test_data GROUP BY customer_added_non_med_to_order;
-- there are 391 true and 6425 false. We aim to use machine learning to derive synthetic data to bring up the percentage of true to 20%, and evaluate the revenue effect
