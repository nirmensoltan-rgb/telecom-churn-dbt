-- Business logic lives here: join population, derive flags and segments.
with customers as (
    select * from {{ ref('stg_customer_churn') }}
),

zips as (
    select * from {{ ref('stg_zipcode_population') }}
)

select
    c.*,
    z.zip_population,

    -- churn flags
    case when c.customer_status = 'Churned' then 1 else 0 end as is_churned,
    case when c.customer_status = 'Joined'  then 1 else 0 end as is_new_customer,

    -- segments
    case
        when c.tenure_months <= 6  then '01-06 mo'
        when c.tenure_months <= 12 then '07-12 mo'
        when c.tenure_months <= 24 then '13-24 mo'
        when c.tenure_months <= 48 then '25-48 mo'
        else '49+ mo'
    end as tenure_band,

    case
        when c.age < 30 then '18-29'
        when c.age < 45 then '30-44'
        when c.age < 60 then '45-59'
        else '60+'
    end as age_band,

    case
        when z.zip_population is null then 'Unknown'
        when z.zip_population < 10000 then '1) <10k'
        when z.zip_population < 30000 then '2) 10k-30k'
        when z.zip_population < 50000 then '3) 30k-50k'
        else '4) 50k+'
    end as zip_population_band,

    case when c.number_of_dependents > 0 then 'Yes' else 'No' end as has_dependents,
    case when c.number_of_referrals  > 0 then 'Yes' else 'No' end as has_referred,

    -- number of paid add-ons (more add-ons may mean stickier customers)
    (case when c.online_security        = 'Yes' then 1 else 0 end
   + case when c.online_backup          = 'Yes' then 1 else 0 end
   + case when c.device_protection_plan = 'Yes' then 1 else 0 end
   + case when c.premium_tech_support   = 'Yes' then 1 else 0 end
   + case when c.unlimited_data         = 'Yes' then 1 else 0 end) as paid_addon_count,

    -- data-quality flag: 120 rows have a negative Monthly Charge in the raw data
    case when c.monthly_charge < 0 then 1 else 0 end as has_negative_monthly_charge
from customers c
left join zips z
    on c.zip_code = z.zip_code