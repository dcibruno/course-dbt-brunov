{{
    config(
        materialized = 'table',
        unique_key = 'dbt_scd_id'
        )
}}

select
    dbt_scd_id
    , id
    , user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at
    , updated_at
    , address_id
    , dbt_updated_at
    , dbt_valid_from
    , dbt_valid_to
from {{ ref('users_snapshot') }}