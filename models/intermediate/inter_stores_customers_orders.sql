{{ config(materialized='view') }}

-- Fichier intermédiaire qui fusionne et agrège les données des items et des commandes
-- Préparation pour la table de fait avec une ligne par fait

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('inter_items_orders_products') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

-- Jointure unique avec tous les calculs
final as (
    select
        -- Identifiants
        o.fact_id,
        o.order_id,
        o.customer_id,
        o.store_id,
        o.order_date,
        o.product_sku,
        
        -- Métriques de base
        o.quantity,
        o.subtotal,
        
        -- Calcul de la taxe payée pour chaque produit en fonction de la quantité (incluse dan subtotal)
        round(o.subtotal * s.tax_rate, 2) as tax_paid,
        -- Calcul du total_amount par produit correspondant à subtotal + tax_paid par produit
        round(o.subtotal * (1 + s.tax_rate), 2) as total_amount
        
    from orders o
    left join stores s on o.store_id = s.store_id
    left join customers c on o.customer_id = c.customer_id
)

select * 
from final