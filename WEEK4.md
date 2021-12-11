# Analytics engineering with dbt

## Week 4
### Q1: How are our users moving through the product funnel?
- Query
```
    select
        created_date
        , add_to_cart_rate
        , checkout_rate
        , overall_conv_rate
    from 
        "fact_product_funnel";
```

- R: This query's been built especially for Funnel analysis (distinct session counts; conversion and drop off rates)! However, I believe the fake data compromised the possibility of analyze the customer behaviour.

### Q2: Which steps in the funnel have largest drop off points?
- Query
```
    select
        created_date
        , add_to_cart_drop_off
        , checkout_drop_off
    from 
        "fact_product_funnel";
```

- R: Based on the data we have, it looks like the users will most likely drop off before add a product to the cart - the drop off rate between add to cart and checkout is relatively smaller.