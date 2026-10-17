-- Geographic view. Small cities are filtered out so rates aren't noise.
select
    city,
    max(zip_population)                         as max_zip_population,
    {{ churn_metrics() }}
from {{ ref('customers_churn_analysis') }}
group by 1
having count(*) >= {{ var('min_customers_per_city') }}