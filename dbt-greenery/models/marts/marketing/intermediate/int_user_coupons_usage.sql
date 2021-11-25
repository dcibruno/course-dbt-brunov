{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

with coupons_usage as (
    select
        orders.created_at
        , orders.order_id
        , orders.user_id
        , promos.discount
        , case when promos.promo_id is not null then true else false end as has_coupon
        , coalesce(promos.discount, 0) + order_total as order_subtotal
        , order_total
    from {{ ref('stg_public__orders') }} as orders
    left join {{ ref('stg_public__promos') }} as promos
        on orders.promo_id = promos.promo_id
    
), 

user_coupons_usage as (
    select
        user_id
        , count(case
                    when has_coupon = true then order_id end) as count_of_orders_w_coupon
        , count(case
                    when has_coupon = false then order_id end) as count_of_orders_wo_coupon
        , sum(discount) as total_sum_of_discount
    from coupons_usage
    group by user_id
)

select
    user_id
    , count_of_orders_w_coupon
    , count_of_orders_wo_coupon
    , total_sum_of_discount
from
    user_coupons_usage