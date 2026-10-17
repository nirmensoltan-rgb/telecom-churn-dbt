-- Why do churned customers say they left?
select
    churn_category,
    churn_reason,
    count(*)                                                    as churned_customers,
    round(100.0 * count(*) / sum(count(*)) over (), 2)          as pct_of_all_churn,
    round(avg(tenure_months), 1)                                as avg_tenure_months,
    round(sum(monthly_charge), 2)                               as monthly_revenue_lost
from {{ ref('customers_churn_analysis') }}
where is_churned = 1
group by 1, 2