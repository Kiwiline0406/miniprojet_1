{{ config(materialized='view') }}

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

count as (
    select
        o.customer_id,
        count(o.order_id) as order_count
    from orders o
    group by o.customer_id
), 

rank as (
    select *
    from {{ ref('customer_status') }}
),

all_in as (
    select c.customer_id,
        c.customer_name, 
        co.order_count, 
        r.customer_status
    from customers c
    left join count co on c.customer_id = co.customer_id
    left join rank r
    on co.order_count >= r.min_order_count 
        and (co.order_count <= r.max_order_count or r.max_order_count is null)
)

select customer_id,
        customer_name,  
        customer_status from all_in