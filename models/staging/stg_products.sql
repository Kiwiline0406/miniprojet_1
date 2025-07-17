{{ config(materialized='view') }}

with source as (
    select * from {{ source('dev', 'raw_products') }}
),
renamed as (
    select
        sku as product_sku,
        name as product_name,
        type as product_type,
        price as product_price,
        description as product_description
    from source
)
select * from renamed