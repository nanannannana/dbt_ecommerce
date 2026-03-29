{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

-- 고객별 주문 통계
customer_orders AS (
    SELECT
        customer_id,
        MIN(purchased_at) AS first_order_at,
        MAX(purchased_at) AS recently_order_at,
        COUNT(order_id) AS total_order_count,
        SUM(total_item_price) AS total_order_amount,
        SUM(item_count) AS total_item_count
    FROM orders
    GROUP BY customer_id
),

final AS (
    SELECT
        c.customer_id,
        c.customer_unique_id,
        c.city,
        c.state,
        co.first_order_at,
        co.recently_order_at,
        co.total_order_count,
        co.total_order_amount,
        co.total_item_count,
        CASE
            WHEN co.total_order_amount >= 500 THEN 'VIP'
            WHEN co.total_order_amount >= 200 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM {{ ref('stg_customers') }} c
    LEFT JOIN customer_orders co ON c.customer_id = co.customer_id
)

SELECT * FROM final