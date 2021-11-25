{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

select
    user_id
    , count(event_id) as count_of_events
    , count(distinct session_id) as count_of_distinct_sessions
    , count(case
                when event_type = 'page_view' then event_id 
            end) as count_of_page_views
    , count(case
                when event_type = 'add_to_cart' then event_id
            end) as count_of_add_to_carts
    , count(case
                when event_type = 'delete_from_cart' then event_id
            end) as count_of_delete_from_carts
    , count(case
                when event_type = 'checkout' then event_id
            end) as count_of_checkouts
    , count(case
                when event_type = 'package_shipped' then event_id
            end) as count_of_packages_shipped
from {{ ref('stg_public__events') }}
group by user_id