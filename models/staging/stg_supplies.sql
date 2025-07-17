{{ config(materialized='view') }}

with source as (
    select * from {{ source('dev', 'raw_supplies') }}
),
renamed as (
    select
        id as supply_id,
        name as supply_name,
        cost as supply_cost,
        perishable as perishable,
        sku as sku
    from source
)
select * from renamed