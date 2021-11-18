{{
    config(
        materialized = 'table',
        unique_key = 'order_item_id'
        )
}}

with order_items_source as (
    select * from {{ source('src_public', 'order_items') }}
)

select
    order_id || product_id as order_item_id
    , id
    , order_id
    , product_id
    , quantity
from order_items_source