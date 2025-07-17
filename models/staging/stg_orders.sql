{{ config(materialized='view') }}

with source as (
    select * from {{ source('dev', 'raw_orders') }}
),
renamed as (
    select
        id as order_id,
        customer as customer_id,
        ordered_at as order_date,
        store_id as store_id
    from source
)
select * from renamed