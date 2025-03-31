with base as (
    select * from {{ source('food', 'klimadatabase')}}
)

select * from base