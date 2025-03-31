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
        n.*
    FROM nutrition n
    JOIN proteinId p ON n.ParameterID = p.id
)

select * from items 