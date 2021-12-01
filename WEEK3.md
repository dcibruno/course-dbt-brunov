# Analytics engineering with dbt

## Week 3
### Q1: What is our overall conversion rate?
- Query
```
    select
        round((sum(case when event_type = 'checkout' then count_of_distinct_sessions end) / sum(count_of_distinct_sessions) * 100),  2) as overall_conversion_rate
    from 
        "fact_daily_events";
```

- R: 15,43%

### Q1: What is our conversion rate by product?
- Query
```
    select
        product_name
        , round((sum(case when event_type = 'add_to_cart' then count_of_distinct_sessions end) / sum(count_of_distinct_sessions) * 100),  2) as conversion_rate
    from 
        "fact_daily_product_events"
    group by 
        product_name
    order by 
        2 desc
```