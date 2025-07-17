with invalid_prices as (
    select *
    from {{ ref('dim_products_supplies') }}
    where product_price <= 0
)
select count(*)
from invalid_prices
having count(*) > 0