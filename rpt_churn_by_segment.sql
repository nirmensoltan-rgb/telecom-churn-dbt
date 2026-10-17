-- One long table: every row is (dimension, segment) with its churn metrics.
-- Easy to filter/pivot in a BI tool. Add a dimension by adding it to the list.
{% set dimensions = [
    'contract', 'tenure_band', 'age_band', 'gender', 'married', 'has_dependents',
    'has_referred', 'offer', 'internet_service', 'internet_type', 'phone_service',
    'premium_tech_support', 'online_security', 'unlimited_data', 'paid_addon_count',
    'payment_method', 'paperless_billing', 'zip_population_band'
] %}

{% for dim in dimensions %}
select
    '{{ dim }}'                                  as dimension,
    cast({{ dim }} as varchar)   as segment,
    {{ churn_metrics() }}
from {{ ref('customers_churn_analysis') }}
group by 1, 2
{% if not loop.last %}union all{% endif %}
{% endfor %}