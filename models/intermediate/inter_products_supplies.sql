{{ config(materialized='view') }}

-- Fichier intermédiaire qui fusionne et agrège les données des items et des commandes
-- Préparation pour la table de fait avec une ligne par commande

with supplies as (
    select * from {{ ref('stg_supplies') }}
),


products as (
    select * from {{ ref('stg_products') }}
),

products_supplies_joined as (
    select
        p.product_sku,
        p.product_name,
        p.product_type,
        p.product_price,
        p.product_description,
        s.supply_id,
        s.supply_name,
        s.supply_cost,
        s.perishable
    from products p 
    left join supplies s on p.product_sku = s.sku
),

final as(
    select 
        -- Ajout de l'id unique prod_supply_id qui est la concaténation de product_sku et supply_id
        {{ dbt_utils.generate_surrogate_key(['psj.product_sku', 'psj.supply_id']) }}as prod_supply_id,

        psj.product_sku,
        psj.product_name,
        psj.product_type,
        psj.product_price,
        psj.product_description,
        psj.supply_name,
        psj.supply_cost,
        psj.perishable

    from products_supplies_joined psj
)

SELECT *
FROM final