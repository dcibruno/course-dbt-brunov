{{
    config(
        materialized = 'table'
        )
}}

with promos_source as (
    select * from {{ source('src_public', 'promos') }}
)

select
    id
    , promo_id
    , discout as discount
    , status
from promos_source