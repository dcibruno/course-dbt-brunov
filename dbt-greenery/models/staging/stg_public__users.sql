{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

with users_source as (
    select * from {{ source('src_public', 'users') }}
)

select
    id
    , user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at
    , updated_at
    , address_id
from users_source