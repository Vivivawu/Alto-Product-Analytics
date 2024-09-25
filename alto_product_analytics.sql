-- Returns first 100 rows from modealto.checkout_attempts
  SELECT * FROM modealto.checkout_attempts LIMIT 100;

-- Returns first 100 rows from modealto.checkout_attempts
  SELECT * FROM modealto.order_status LIMIT 100;

-- Check for missing data
  SELECT COUNT(*) AS total_rows,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS NULL_order_id,
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS NULL_customer_id,
  SUM(CASE WHEN checkout_started_at IS NULL THEN 1 ELSE 0 END) AS NULL_checkout_start,
  SUM(CASE WHEN checkout_completed_at IS NULL THEN 1 ELSE 0 END) AS NULL_checkout_completed,
  SUM(CASE WHEN order_total_dollars IS NULL THEN 1 ELSE 0 END) AS NULL_order_total,
  SUM(CASE WHEN customer_added_non_med_to_order IS NULL THEN 1 ELSE 0 END) AS NULL_if_nonmed
  FROM modealto.checkout_attempts;
-- Out of 11992 entries, there are 4836 cases where the customer does not finished checking out

-- There are completed orders where if user add non_med items are unknown - exploring these situations
  SELECT COUNT(*) FROM (
  SELECT * FROM modealto.checkout_attempts
  WHERE order_id IS NOT NULL AND customer_added_non_med_to_order is NULL) AS UNKNOWN_IF_CUSTOMER_ADD_NON_MED;
-- 340 cases where it's unknown if customer add non-med items to their order
-- These entries can be removed in the following analysis since they do not provide insights into understanding customer behavior

-- Viewing summary statistics for order total
  SELECT MAX(order_total_dollars) as MAX_order_total, 
  MIN(order_total_dollars) as MIN_order_total,
  AVG(order_total_dollars) as MEAN_order_total,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY order_total_dollars) AS lower_percentile,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY order_total_dollars) AS upper_percentile,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY order_total_dollars) AS median_value
  FROM modealto.checkout_attempts;
-- max oredr: $47, min order: $2.36, median: 20.16
-- 25-75 percentile range: $17 - $24
