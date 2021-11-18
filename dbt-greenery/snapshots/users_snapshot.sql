{% snapshot users_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='user_id',

      strategy='timestamp',
      updated_at='updated_at'
    )
  }}

  select * 
  from {{ ref('stg_public__users') }}

{% endsnapshot %}