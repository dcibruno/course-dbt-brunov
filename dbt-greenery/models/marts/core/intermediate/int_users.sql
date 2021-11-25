{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

with users_first_last_data as (
    select distinct
        user_id
        , first_value(order_id) over (partition by user_id order by created_at) as first_order_id
        , last_value(order_id) over (partition by user_id order by created_at) as last_order_id
        , date_part('day', current_date::timestamp - last_value(created_at) over (partition by user_id order by created_at))::numeric as purchase_recency
        , date_part('day', current_date::timestamp - first_value(created_at) over (partition by user_id order by created_at))::numeric as customer_tenure
    from {{ ref('stg_public__orders') }}
    where status = 'delivered'
),

customer_orders as (
    select
        user_id
        , count(order_id) as count_of_orders
        , sum(order_total) as total_spent
    from {{ ref('stg_public__orders') }}
    where status = 'delivered'
    group by user_id
),

users as (
    select
        users.user_id
        , users_first_last_data.first_order_id
        , users_first_last_data.last_order_id
        , users_first_last_data.purchase_recency
        , users_first_last_data.customer_tenure
        , customer_orders.count_of_orders
        , case
            when customer_orders.count_of_orders = 1 or customer_orders.count_of_orders is null then 'New'
            when customer_orders.count_of_orders > 1 then 'Repeat'
        end as customer_new_v_repeat
        , customer_orders.total_spent
        , addresses.zipcode
        , addresses.state
        , addresses.country
    from {{ ref('stg_public__users') }} as users
    left join users_first_last_data
        on users.user_id = users_first_last_data.user_id
    left join customer_orders
        on users.user_id = customer_orders.user_id
    left join {{ ref('stg_public__addresses') }} as addresses
        on users.address_id = addresses.address_id
)

select
    user_id
    , first_order_id
    , last_order_id
    , purchase_recency
    , customer_tenure
    , count_of_orders
    , customer_new_v_repeat
    , total_spent
    , zipcode
    , state
    , country
from
    users