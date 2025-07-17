{{ config(materialized='view') }}

with source as (
    select * from {{ source('dev', 'raw_stores') }}
),
renamed as (
    select
        id as store_id,
        name as store_name,
        opened_at as opened_date,
        tax_rate as tax_rate
    from source
)
select * from renamed