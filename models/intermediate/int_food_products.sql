with base_table as (
    select * from {{ ref("stg_food_info") }}
),

carbon_table as (
    select * from {{ ref("stg_food_carbon") }}
),

combined_info as (
    SELECT
        FoodID as id,
        MAX(foodnavn) as navn,
        MAX(name) as name,
        MAX(category) as category,
        MAX(total_carbon_footprint) as total_carbon_footprint
    FROM
        base_table as t1
    JOIN
        carbon_table as t2
    ON
        t2.name ILIKE '%' || t1.foodnavn || '%'
    group by 
        foodid
)


select * from combined_info