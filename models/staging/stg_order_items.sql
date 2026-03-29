{{ config(materialized='view') }}

WITH raw_order_items AS (
    SELECT * FROM {{ source('olist_raw', 'olist_order_items_dataset') }}
)

SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date AS shipping_limit_at,
    price AS item_price,
    freight_value AS shipping_cost,
    (price + freight_value) AS total_item_amount
FROM raw_order_items
WHERE price >= 0
AND freight_value >= 0