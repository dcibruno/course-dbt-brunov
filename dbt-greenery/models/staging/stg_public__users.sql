{{
    config(
        materialized = 'table'
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
    , created_at::timestamp as created_at
    , updated_at::timestamp as updated_at
    , address_id
from users_source