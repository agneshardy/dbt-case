with proteinId as (
    select 
        id
    from {{ ref('int_food_parameters') }}
    where 
        lower(name) = 'protein'
),

nutrition as (
    select * from {{ ref("stg_food_info")}}
),

items AS (
    SELECT 
        foodid, foodname, nutritionvalue
    FROM nutrition n
    JOIN proteinId p ON n.ParameterID = p.id
    group by foodid, foodname, nutritionvalue

)

select * from items