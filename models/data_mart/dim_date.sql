{{ config(materialized='table') }}

WITH date_dimension AS (
    {{ dbt_date.get_date_dimension(
        start_date="2016-09-01",
        end_date="2017-08-31"
    ) }}
)

SELECT *
FROM date_dimension