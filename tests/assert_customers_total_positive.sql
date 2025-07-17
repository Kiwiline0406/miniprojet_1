with invalid_orders_amounts as (
    select *
    from {{ ref('fact_orders_items') }}
    where total_amount < 0
)
select count(*)
from invalid_orders_amounts
having count(*) > 0