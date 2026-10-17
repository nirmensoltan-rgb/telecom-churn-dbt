-- Returns offending rows; test passes when zero rows come back.
select customer_id
from {{ ref('stg_customer_churn') }}
where customer_status = 'Churned'
  and (churn_category is null or churn_reason is null)
