{{ config(materialized='table') }}

SELECT 
    store_id,
    store_name,
    opened_date, 
    tax_rate
FROM {{ ref('stg_stores') }}