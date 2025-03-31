with base as (
    select 
        parameterID as id, 
        parametername as name
    from {{ ref('stg_food_info')}}
)

select * from base