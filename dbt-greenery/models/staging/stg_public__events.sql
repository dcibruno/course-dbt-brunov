{{
    config(
        materialized = 'table'
        )
}}

with events_source as (
    select * from {{ source('src_public', 'events') }}
)

select
    id
    , event_id
    , session_id
    , user_id
    , page_url
    , created_at::timestamp as created_at
    , event_type
from events_source