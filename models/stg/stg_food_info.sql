with base as (
    select 
        FoodID, 
        FoodNavn,
        FoodName,
        ParameterID,
        ParameterName,
        ROUND(REPLACE(ResVal, ',', '.')::double, 2) as NutritionValue
    from {{ source('food', 'products')}}
)

select * from base