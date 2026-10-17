-- One row per zip code. Rename + cast only; no business logic here.
select
    lpad(cast({{ adapter.quote('Zip Code') }} as varchar), 5, '0') as zip_code,
    cast({{ adapter.quote('Population') }} as integer)             as zip_population
from {{ source('raw', 'zipcode_population') }} 