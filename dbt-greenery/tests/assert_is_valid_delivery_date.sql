SELECT *
FROM {{ ref('stg_public__orders') }}
WHERE delivered_at < created_at 
/* checking if there are any instances where the delivery date is before the date the order was placed which wouldn't make sense logically and indicate some sort of data issue */