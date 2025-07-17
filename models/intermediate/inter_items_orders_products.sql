{{ config(materialized='view') }}

-- Fichier intermédiaire qui fusionne et agrège les données des items et des commandes
-- Préparation pour la table de fait avec une ligne par commande

with items as (
    select * from {{ ref('stg_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),


items_with_product_info as (
    select
        i.item_id,
        i.order_id,
        i.sku,
        p.product_name,
        p.product_type,
        p.product_price,
        p.product_description
    from items i
    left join products p on i.sku = p.product_sku
),

-- Agrégation par commande pour calculer les métriques

cte_counts as (
    SELECT 
        ipi.order_id, 
        ipi.sku,
         -- Calcul de la quantité de chaque produit par commande
        count(distinct ipi.item_id) as quantity,
         -- Calcul du subtotal : quantité * prix de chaque product
        ((count(distinct ipi.item_id)) * ipi.product_price) as subtotal

    FROM items_with_product_info ipi
    GROUP BY ipi.order_id, ipi.sku, ipi.product_price
),
        
-- Jointure finale avec calcul des taxes et totaux
final as (
    select
        -- Génération d'un fact_id unique
        {{ dbt_utils.generate_surrogate_key(['cc.order_id', 'cc.sku']) }} as fact_id,
        
        -- Dimensions principales
        cc.order_id,
        o.customer_id,
        o.store_id,
        cc.sku as product_sku, -- Tous les SKUs de la commande
        o.order_date,
        
        -- Métriques calculées
        cc.quantity,
        cc.subtotal
        
        
    from orders o
    inner join cte_counts cc on o.order_id = cc.order_id
)

select * from final