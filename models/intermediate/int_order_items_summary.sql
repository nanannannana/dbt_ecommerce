-- 주문 건당 관련 정보 

WITH order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

SELECT
    order_id,
    SUM(item_price) AS total_item_price,
    SUM(shipping_cost) AS total_shipping_cost,
    SUM(total_item_amount) AS total_order_item_amount,
    COUNT(order_item_id) AS item_count -- 주문 1건당 상품 개수
FROM order_items
GROUP BY order_id