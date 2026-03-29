{{ config(materialized='view') }}

WITH raw_payments AS (
    SELECT * FROM {{ source('olist_raw', 'olist_order_payments_dataset') }}
)

SELECT
    order_id,
    payment_sequential,
    LOWER(payment_type) AS payment_method,
    payment_installments AS installment_count,
    payment_value AS amount,
    CASE
        WHEN payment_installments > 1 THEN TRUE
        ELSE FALSE
    END AS is_installment
FROM raw_payments
WHERE payment_value >= 0