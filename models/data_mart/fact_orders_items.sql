{{ config(materialized='table') }}

SELECT
    fact_id,
    order_id,
    customer_id,
    store_id,
    order_date,
    product_sku,
    quantity,
    subtotal,
    tax_paid,
    total_amount
FROM {{ ref('inter_stores_customers_orders') }}
ORDER BY order_date DESC, order_id DESC, product_sku ASC