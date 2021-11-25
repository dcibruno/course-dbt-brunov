{{
    config(
        materialized = 'table',
        unique_key = 'created_date'
        )
}}

select
    date(created_at) as created_date
    , event_type
    , count(event_id) as count_of_events
    , count(distinct session_id) as count_of_distinct_sessions
    , count(distinct user_id) as count_of_distinct_users
from {{ ref('stg_public__events') }}
group by
    created_date
    , event_type