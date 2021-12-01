{{
    config(
        materialized = 'table'
        )
}}

with user_facts as (
    select
        dim_users.user_id
        , dim_users.first_name
        , dim_users.last_name
        , dim_users.email
        , dim_users.phone_number
        , dim_users.created_at
        , dim_users.updated_at
        , dim_users.address_id
        , dim_users.first_order_id
        , dim_users.last_order_id
        , dim_users.purchase_recency
        , dim_users.customer_tenure
        , dim_users.count_of_orders
        , dim_users.customer_new_v_repeat
        , dim_users.total_spent
        , user_events.count_of_events
        , user_events.count_of_distinct_sessions
        , user_events.count_of_page_view
        , user_events.count_of_add_to_cart
        , user_events.count_of_delete_from_cart
        , user_events.count_of_checkout
        , user_events.count_of_package_shipped
        , (user_events.count_of_add_to_cart - user_events.count_of_checkout) / nullif(user_events.count_of_add_to_cart, 0) as abandoned_cart_rate
        , user_coupons_usage.count_of_orders_w_coupon
        , user_coupons_usage.count_of_orders_wo_coupon
        , user_coupons_usage.total_sum_of_discount
    from {{ ref('dim_users') }} as dim_users
    left join {{ ref('int_user_events') }} as user_events
        on dim_users.user_id = user_events.user_id
    left join {{ ref('int_user_coupons_usage') }} as user_coupons_usage
        on dim_users.user_id = user_coupons_usage.user_id
)

select
     user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at
    , updated_at
    , address_id
    , first_order_id
    , last_order_id
    , purchase_recency
    , customer_tenure
    , count_of_orders
    , customer_new_v_repeat
    , total_spent
    , count_of_events
    , count_of_distinct_sessions
    , count_of_page_view
    , count_of_add_to_cart
    , count_of_delete_from_cart
    , count_of_checkout
    , count_of_package_shipped
    , abandoned_cart_rate
    , count_of_orders_w_coupon
    , count_of_orders_wo_coupon
    , total_sum_of_discount
from
    user_facts