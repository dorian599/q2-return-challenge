-- Blocking: all required metric names must be present in gold_q2_return.
with required_metrics as (
    select metric_name from (
        values
            ('active_members'),
            ('new_joiners'),
            ('net_contributions'),
            ('transfers_in_count'),
            ('transfers_in_value'),
            ('transfers_out_count'),
            ('transfers_out_value'),
            ('active_under_30'),
            ('active_30_49'),
            ('active_50_64'),
            ('active_65_plus'),
            ('average_pot_value')
    ) as t(metric_name)
),

actual_metrics as (
    select distinct metric_name
    from {{ ref('gold_q2_return') }}
)

select r.metric_name as missing_metric
from required_metrics as r
left join actual_metrics as a
    on r.metric_name = a.metric_name
where a.metric_name is null
