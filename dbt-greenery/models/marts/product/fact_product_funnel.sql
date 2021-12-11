{{
    config(
        materialized = 'table'
        )
}}

with product_funnel as (
    select
        date(created_at) as created_date
        , count(distinct
                    case
                        when (event_type = 'page_view' OR event_type = 'add_to_cart' OR event_type = 'checkout') then session_id end) as count_of_valid_sessions
        , count(distinct
                    case
                        when (event_type = 'add_to_cart' OR event_type = 'checkout') then session_id end) as count_of_valid_carts
        , count(distinct
                    case when event_type = 'checkout' then session_id end) as count_of_checkouts
    from {{ ref('stg_public__events') }}
    group by created_date
    order by created_date
)

select
    created_date
    , count_of_valid_sessions
    , count_of_valid_carts
    , count_of_checkouts
    , (count_of_valid_carts::float / nullif(count_of_valid_sessions, 0)) as add_to_cart_rate
    , (count_of_checkouts::float / nullif(count_of_valid_carts, 0)) as checkout_rate
    , (count_of_checkouts::float / nullif(count_of_valid_sessions, 0)) as overall_conv_rate
    , (1 - ((count_of_valid_carts::float / nullif(count_of_valid_sessions, 0)))) as add_to_cart_drop_off
    , (((count_of_valid_carts::float / nullif(count_of_valid_sessions, 0))) - ((count_of_checkouts::float / nullif(count_of_valid_carts, 0)))) as checkout_drop_off
from product_funnel