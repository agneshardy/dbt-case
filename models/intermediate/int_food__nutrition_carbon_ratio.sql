-- query foods and a nutritional value to carbon foot print ratio sorted by (nutritional value / carbon foot print) 

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
    where food.nutritionvalue > {{ COALESCE(var("lowerbound"), 0)}}
    group by 
        foodid, name, nutritionvalue
),

food_info as (
    select 
        foodid, 
        name,
        total_carbon_footprint
    from {{ ref("int_food_products")}}
),

carbon_ratio as (
    select 
        food.foodid,
        food.name,
        food.total_carbon_footprint,
        nutrition.nutritionvalue,
        ROUND((COALESCE(nutrition.nutritionvalue, 0) * 10) / COALESCE(food.total_carbon_footprint, 1), 2) AS nutrition_per_footprint_ratio
    from food_info as food 
    join nutrition 
    on food.foodid = nutrition.foodid
)

select 
    foodid as id,
    name,
    total_carbon_footprint,
    nutritionvalue, 
    nutrition_per_footprint_ratio
from carbon_ratio
order by nutrition_per_footprint_ratio desc
