{{
    config(
        materialized = 'table'
        )
}}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_public__events'),
    column='event_type'
) -%}

select
    user_id
    , count(event_id) as count_of_events
    , count(distinct session_id) as count_of_distinct_sessions
    , {%- for event_type in event_types %}
      count(case when event_type = '{{event_type}}' then event_id end) as count_of_{{event_type}}
      {%- if not loop.last %},{% endif -%}
      {% endfor %}
from {{ ref('stg_public__events') }}
group by user_id