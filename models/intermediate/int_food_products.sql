with base_table as (
    select * from {{ ref("stg_food_info") }}
),

carbon_table as (
    select * from {{ ref("stg_food_carbon") }}
),

combined_info as (
    SELECT
        t1.FoodID,
        t1.foodname
        t1.foodnavn,
        t2.name,
        t2.category,
        t2.total_carbon_footprint
    FROM
        base_table as t1
    JOIN
        carbon_table as t2
    ON
        t2.name ILIKE '%' || t1.foodnavn || '%'
    group by 
        t1.foodid, t1.foodnavn, t2.name, t2.total_carbon_footprint, t2.category
)


select * from combined_info