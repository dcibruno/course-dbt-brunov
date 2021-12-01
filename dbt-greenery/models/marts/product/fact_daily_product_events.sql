{{
    config(
        materialized = 'table'
        )
}}

with daily_product_events as (
    select
        date(created_at) as created_date
        , event_type
        , split_part(page_url, '/', 5) as product_id
        , event_id
        , session_id
    from
        {{ ref('stg_public__events') }}
)

select
    created_date
    , event_type
    , daily_product_events.product_id
    , products.name as product_name
    , count(distinct session_id) as count_of_distinct_sessions
from
    daily_product_events
    inner join {{ ref('stg_public__products') }} as products
        on daily_product_events.product_id = products.product_id
group by
    created_date
    , event_type
    , daily_product_events.product_id
    , product_name