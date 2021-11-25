# Analytics engineering with dbt

## Week 2
### Q1: What is our repeat rate?
- Query
```
    select
    round(
        (count(case
                    when customer_new_v_repeat = 'Repeat' then user_id 
                end)::float /
        count(case
                    when count_of_orders >= 1 then user_id 
                end)::float)::numeric
    ,  4) * 100  as repeat_rate
    from 
    "dim_users";
```

- R: 75,81%

### Q2: What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
- R: We could start from (i) creating a table with all customers who have already had a valid purchase, (ii) calculating the count of orders for each one (so we can think about the significance), (iii) the average difference between purchases in days and (iv) the difference between the current date and the last order date (purchase_recency), for some kind of comparison vs. that average. Not enough, but it seems like a good start point! If we had loads of data, it could also helps us to define cohorts (A, B, C) and groups of customers based on the same behaviors / metrics. Nevertheless, I'd ask a hand from the Data Science team so we could think about a ML model to try to predict the probability of a customer's next purchase, considering past data and in motion business variables!

### Q3: Explain the marts models you added. Why did you organize the models in the way you did?
- Structure
```
- marts
	- core
		- dim_users.sql
		- fact_orders.sql
		- intermediate
			- int_users.sql
	- marketing
		- dim_user_facts.sql
		- intermediate
			- int_user_coupons_usage.sql
	- product
		- fact_daily_events.sql
		- intermediate
			- int_user_events.sql
```

- R: Every directory within marts (core, marketing and product) has an intermediate subdirectory which should group models containing business rules / logic, more general ones but at the same time specific at a department or business unit level. These models should be used in the final fact_ and dim_ tables, from where we expect users to extract end state information for analysis and reporting.

### Q4: Paste in an image of your DAG from the docs
- Attached in the thread!

### Q5: What assumptions are you making about each model? (i.e. why are you adding each test?)
- R: I've created a total of 15 tests to the stg_ and reporting layer models and most of them consist on making sure we're not going to duplicate data, following this format:
```
columns:
  - name: user_id
    tests:
      - unique:
          severity: warn
      - not_null
```

The same logic's being applied to the order_id column from the fact_orders model, for example.

More schema tests for models and columns (marketing_schema.yml)! Check this out:

1. Not so intuitive to imagine a discount greater than the order value...
```
models:
  - name: dim_user_facts
    tests:
      - dbt_utils.expression_is_true:
          expression: "total_sum_of_discount < total_spent"
```

2. as well as %s greater than 1...
```
  - name: abandoned_cart_rate
    tests:
      - dbt_utils.expression_is_true:
          expression: "<= 1"
```

### Q6: Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
- Absolutely, especially for unique validations! We actually just __think__ we're completely safe with our code beforehand, that's why they're so important! You wouldn't imagine, at first, that a first_value window function could duplicate your data - by the way, this is my real example) - you're even selecting distinct values, so why would that happen?? :') Well, the only think completely capable of giving you the assurance you need are your schema / data tests! And I'm still getting a negative order_total (-14.09, for order_id = fd47d88b-69d6-403b-bf53-b108819098f0)... 

### Q7: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- "We've just finished to set data tests for our most important models, the ones available for analysis and reporting! No worries, our freshness tests are also running on our sources so we can be sure we're looking at most up to date data. By the way, if anything goes wrong, <scheduler> will let us right away! Feel free to join us at <slack_channel_name> if you want to be aware of it as well - we promise we'll keep this channel as quite as possible :)".