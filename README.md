# Analytics engineering with dbt

## Week 1
### Q1: How many users do we have?
- Query
```
  select
    count(*) as count_of_users 
  from 
    "stg_public__users";
```

- R: 130 users

### Q2: On average, how many orders do we receive per hour?
- Query
```
  with orders_per_hour as (
    select
        extract(hour from created_at) as hour
        , count(order_id) as count_of_orders 
    from 
        "stg_public__orders" 
    where 
        created_at is not null 
    group by hour
  )

  select
      round(avg(count_of_orders), 0) as avg_orders_per_hour
  from
      orders_per_hour;
```

- R: 16 orders / hour, on average.

### Q3: On average, how long does an order take from being placed to being delivered?
- Query
```
  select
      round(avg(date_part('day', delivered_at - created_at))::numeric, 0) as order_placed_to_delivery
  from
      "stg_public__orders"
  where
      created_at is not null
      and delivered_at is not null;
```

- R: 4 days, on average.