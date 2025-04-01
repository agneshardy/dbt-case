-- query foods and a nutritional value to carbon foot print ratio sorted by (nutritional value / carbon foot print) 

-- Currently, I am using view as the materialization strategy, because this model may be used for changing nutrition parameters, 
-- so it should not necessarily be materialized as tables each time it is run
{{ config(
    materialized='view'
) }}

with food_nutrition as (
    select * from {{ ref("int_food_nutrition")}}
),

parameter as (
    select 
        id, 
        name
    from {{ ref("int_food_parameters")}}
    where lower(name) = lower(COALESCE('{{var('nutritional_value')}}', 'protein'))
),

nutrition as (
    select 
        food.foodid,
        p.name,
        food.nutritionvalue
    from food_nutrition as food
    join parameter as p
    on food.parameterid = p.id
    where food.nutritionvalue > COALESCE({{ var("lowerbound") }}, 0)
),

food_info as (
    select 
        id, 
        name,
        total_carbon_footprint
    from {{ ref("int_food_products")}}
),

carbon_ratio as (
    select 
        food.id as id,
        food.name,
        food.total_carbon_footprint,
        nutrition.nutritionvalue,
        ROUND((COALESCE(nutrition.nutritionvalue, 0) * 10) / COALESCE(NULLIF(food.total_carbon_footprint, 0), 1), 2) AS nutrition_per_footprint_ratio
    from food_info as food 
    join nutrition 
    on food.id = nutrition.foodid
)

select 
    id,
    name,
    total_carbon_footprint,
    nutritionvalue, 
    nutrition_per_footprint_ratio
from carbon_ratio
group by 
    id,
    name,
    total_carbon_footprint,
    nutritionvalue, 
    nutrition_per_footprint_ratio
order by nutrition_per_footprint_ratio desc 
