{{
    config(
        materialized = 'table',
        unique_key = 'product_id'
        )
}}

with products_source as (
    select * from {{ source('src_public', 'products') }}
)

select
    id
    , product_id
    , name
    , price
    , quantity
from products_source