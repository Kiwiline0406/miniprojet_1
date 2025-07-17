{{ config(materialized='view') }}

with source as (
    select * from {{ source('dev', 'raw_items') }}
),
renamed as (
    select
        id as item_id,
        order_id as order_id,
        sku as sku
    from source
)
select * from renamed