{{ config(materialized='table') }}

SELECT 
    customer_id,
    customer_name, 
    customer_status
FROM {{ ref('inter_dim_customers') }}