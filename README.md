# Telecom Customer Churn with dbt

A dbt project that turns raw telecom customer data into analysis-ready churn reports. Staging models clean and standardize the raw data, churn models calculate customer-level and overall churn metrics, reporting models break churn down by city, customer segment and churn reason, and data tests protect the quality of the results.

## Overview

- **Goal:** Understand who churns, where, and why, using SQL models that are versioned, tested and repeatable.
- **Input:** A raw customer churn table (`raw.customer_churn`) and a zip-code population dataset.
- **Tools:** dbt, SQL, Jinja.

## Project layers

| Layer | Model | Purpose |
| --- | --- | --- |
| Staging | `stg_customer_churn` | Cleans the raw customer table: snake_case column names, explicit data types and explicit "no service" values |
| Staging | `stg_zipcode_population` | Prepares zip-code population data for joining with customers |
| Churn models | `churn_metrics` | Churn metrics |
| Churn models | `customers_churn_analysis` | Customer-level churn analysis |
| Reports | `rpt_churn_by_city` | Churn by city |
| Reports | `rpt_churn_by_segment` | Churn by customer segment |
| Reports | `rpt_churn_reasons` | Churn by reason |

Documentation and source definitions are in `schema.yml` and `_staging.yml`.

## What the staging model does

`stg_customer_churn` reads from the raw source (`source('raw', 'customer_churn')`) and prepares it for analysis:

- Renames columns such as `Customer ID` and `Monthly Charge` to `customer_id` and `monthly_charge`.
- Casts numeric fields such as age, number of dependents, number of referrals and tenure to integers.
- Pads zip codes to five digits so leading zeros are not lost.
- Makes "no service" values explicit. The data dictionary expects `No`, `None` or `0`, but the raw table leaves them blank. The model fills them with:
  - `None` for offer and internet type,
  - `No` for multiple lines, online security, online backup, device protection, premium tech support, streaming TV, streaming movies, streaming music and unlimited data,
  - `0` for average monthly long-distance charges and average monthly GB download.

## Data tests

Custom (singular) tests protect two business rules:

| Test | Rule |
| --- | --- |
| `assert_churned_customers_have_reason` | Every churned customer has a recorded churn reason |
| `assert_non_negative_monthly_charge` | Monthly charges are never negative |

## How to run

1. Install dbt with the adapter for your data warehouse.
2. Configure a profile in `profiles.yml` that matches the profile name in `dbt_project.yml`.
3. Load the raw customer churn table into the warehouse under the `raw` source defined in the project.
4. Run:

   ```bash
   dbt debug    # check the connection
   dbt run      # build the models
   dbt test     # run the data tests
   ```

## Project files

```
telecom-churn-dbt/
├── dbt_project.yml
├── schema.yml                           # Model documentation
├── _staging.yml                         # Source and staging definitions
├── stg_customer_churn.sql
├── stg_zipcode_population.sql
├── churn_metrics.sql
├── customers_churn_analysis.sql
├── rpt_churn_by_city.sql
├── rpt_churn_by_segment.sql
├── rpt_churn_reasons.sql
├── assert_churned_customers_have_reason.sql
└── assert_non_negative_monthly_charge.sql
```

## Skills demonstrated

Analytics engineering with dbt, SQL data modeling, layered project design (staging, models, reports), data cleaning in SQL, and data quality testing.

## Author

**Nirmen Mohamed Soltan**
Data Analyst and Data Scientist | Computer Science student, Menoufia University

[GitHub](https://github.com/nirmensoltan-rgb) · [LinkedIn](https://www.linkedin.com/in/nirmeen-soltan-30b81839b) · nirmensoltan@gmail.com
