{{ config(
    materialized='table'
) }}

with base as (
    select 
        foodID, 
        ParameterID,
        nutritionvalue
    from {{ ref("stg_food_info")}}
)

select * from base