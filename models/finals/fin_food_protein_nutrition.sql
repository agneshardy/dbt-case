with proteinId as (
    select 
        id
    from {{ ref('int_food_parameters') }}
    where 
        lower(name) = 'protein'
),

nutrition as (
    select 
        n.foodID, 
        f.name as foodname,
        n.ParameterID,
        n.nutritionvalue 
    from {{ ref("int_food_nutrition")}} as n
    join {{ ref("int_food_products")}} as f
    on n.foodid = f.id
),

items AS (
    SELECT 
        foodid, foodname, nutritionvalue
    FROM nutrition n
    JOIN proteinId p ON n.ParameterID = p.id
    group by foodid, foodname, nutritionvalue

)

select * from items