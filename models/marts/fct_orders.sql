{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
order_items_summary AS (
    SELECT * FROM {{ ref('int_order_items_summary') }}
)
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.purchased_at,
    o.is_completed,
    DATE_DIFF(delivered_at, purchased_at, DAY) AS delivery_time_days,
    CASE
        WHEN o.delivered_at IS NULL THEN NULL
        WHEN o.delivered_at > o.estimated_delivery_at THEN TRUE
        ELSE FALSE
    END AS is_delayed,
    oi.total_item_price,
    oi.total_shipping_cost,
    oi.total_order_item_amount,
    oi.item_count
FROM orders o
LEFT JOIN order_items_summary oi ON o.order_id = oi.order_id