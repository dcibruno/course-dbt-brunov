{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
        )
}}

with orders_source as (
    select * from {{ source('src_public', 'orders') }}
)

select
    id
    , order_id
    , user_id
    , promo_id
    , address_id
    , created_at
    , order_cost
    , shipping_cost
    , order_total
    , tracking_id
    , shipping_service
    , estimated_delivery_at
    , delivered_at
    , status
from orders_source