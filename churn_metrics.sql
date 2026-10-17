{# Reusable metric block so every report calculates churn the same way. #}
{% macro churn_metrics() %}
    count(*)                                                      as customers,
    sum(is_churned)                                               as churned_customers,
    round(100.0 * sum(is_churned) / count(*), 2)                  as churn_rate_pct,
    round(avg(monthly_charge), 2)                                 as avg_monthly_charge,
    round(avg(tenure_months), 1)                                  as avg_tenure_months,
    round(sum(case when is_churned = 1 then monthly_charge else 0 end), 2) as monthly_revenue_lost
{% endmacro %}