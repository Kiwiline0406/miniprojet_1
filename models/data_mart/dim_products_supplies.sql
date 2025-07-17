{{ config(materialized='table') }}

SELECT 
    prod_supply_id,
    product_sku,
    product_name,
    product_type,
    product_price,
    product_description,
    supply_name,
    supply_cost,
    perishable
FROM {{ ref('inter_products_supplies') }}