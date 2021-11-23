{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
        )
}}

select
    orders.order_id
    , orders.user_id
    , users.first_name
    , users.last_name
    , users.email
    , users.phone_number
    , orders.promo_id
    , promos.discount as promo_discount
    , promos.status as promo_status
    , orders.address_id
    , addresses.address
    , addresses.state
    , addresses.country
    , orders.created_at
    , orders.order_cost
    , orders.shipping_cost
    , orders.order_total
    , orders.tracking_id
    , orders.shipping_service
    , orders.estimated_delivery_at
    , orders.delivered_at
    , orders.status as order_status
from {{ ref('stg_public__orders') }} as orders
left join {{ ref('stg_public__users') }} as users
    on orders.user_id = users.user_id
left join {{ ref('stg_public__addresses') }} as addresses
    on orders.address_id = addresses.address_id
left join {{ ref('stg_public__promos') }} as promos
    on orders.promo_id = promos.promo_id