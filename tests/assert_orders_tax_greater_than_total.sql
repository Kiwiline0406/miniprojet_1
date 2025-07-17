with invalid_taxes as (
    select *
    from {{ ref('fact_orders_items') }}
    where total_amount <= subtotal
)
select count(*)
from invalid_taxes
having count(*) > 0