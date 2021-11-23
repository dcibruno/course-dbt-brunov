{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

select
    users.user_id
    , users.first_name
    , users.last_name
    , users.email
    , users.phone_number
    , users.created_at
    , users.updated_at
    , users.address_id
    , int_users.first_order_id
    , int_users.last_order_id
    , int_users.purchase_recency
    , int_users.customer_tenure
    , int_users.count_of_orders
    , int_users.customer_new_v_repeat
    , int_users.total_spent
from {{ ref('stg_public__users') }} as users
left join {{ ref('int_users') }} as int_users
    on users.user_id = int_users.user_id