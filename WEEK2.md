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

### Q2: What are good indicators of a user who will likely purchase again? What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

### Q3: Explain the marts models you added. Why did you organize the models in the way you did?

### Q4: Paste in an image of your DAG from the docs
- Attached in the thread!

### Q5: What assumptions are you making about each model? (i.e. why are you adding each test?)

### Q6: Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

### Q7: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.