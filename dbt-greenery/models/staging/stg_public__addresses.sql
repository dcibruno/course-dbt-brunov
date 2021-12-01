{{
    config(
        materialized = 'table'
        )
}}

with addresses_source as (
    select * from {{ source('src_public', 'addresses') }}
)

select
    id
    , address_id
    , address
    , zipcode
    , state
    , country
from addresses_source