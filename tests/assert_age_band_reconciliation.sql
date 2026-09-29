-- Blocking: age band counts must sum to total active members.
with metrics as (
    select
        max(case when metric_name = 'active_members' then metric_value end) as active_members,
        max(case when metric_name = 'active_under_30' then metric_value end) as under_30,
        max(case when metric_name = 'active_30_49' then metric_value end) as band_30_49,
        max(case when metric_name = 'active_50_64' then metric_value end) as band_50_64,
        max(case when metric_name = 'active_65_plus' then metric_value end) as band_65_plus,
        max(case when metric_name = 'active_age_unknown' then metric_value end) as age_unknown
    from {{ ref('gold_q2_return') }}
)

select *
from metrics
where active_members != coalesce(under_30, 0) + coalesce(band_30_49, 0)
    + coalesce(band_50_64, 0) + coalesce(band_65_plus, 0) + coalesce(age_unknown, 0)
