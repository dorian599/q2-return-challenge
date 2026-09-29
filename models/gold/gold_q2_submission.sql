{{
    config(
        materialized='view',
        post_hook="{{ export_q2_submission() }}"
    )
}}

{#
  Regulatory delivery view: six SPEC metric categories as 12 long-format rows.
  Filters gold_q2_return; no duplicated business logic.
#}

with delivery_metrics as (
    select *
    from {{ ref('gold_q2_return') }}
    where metric_name in (
        'active_members',
        'new_joiners',
        'net_contributions',
        'transfers_in_count',
        'transfers_in_value',
        'transfers_out_count',
        'transfers_out_value',
        'active_under_30',
        'active_30_49',
        'active_50_64',
        'active_65_plus',
        'average_pot_value'
    )
)

select
    case metric_name
        when 'active_members' then 1
        when 'new_joiners' then 2
        when 'net_contributions' then 3
        when 'transfers_in_count' then 4
        when 'transfers_in_value' then 4
        when 'transfers_out_count' then 4
        when 'transfers_out_value' then 4
        when 'active_under_30' then 5
        when 'active_30_49' then 5
        when 'active_50_64' then 5
        when 'active_65_plus' then 5
        when 'average_pot_value' then 6
    end as spec_metric_number,
    case metric_name
        when 'active_members' then 'Active members at quarter end'
        when 'new_joiners' then 'New joiners'
        when 'net_contributions' then 'Total contributions received'
        when 'transfers_in_count' then 'Transfers in and transfers out'
        when 'transfers_in_value' then 'Transfers in and transfers out'
        when 'transfers_out_count' then 'Transfers in and transfers out'
        when 'transfers_out_value' then 'Transfers in and transfers out'
        when 'active_under_30' then 'Members by age band'
        when 'active_30_49' then 'Members by age band'
        when 'active_50_64' then 'Members by age band'
        when 'active_65_plus' then 'Members by age band'
        when 'average_pot_value' then 'Average pot value'
    end as spec_metric_label,
    metric_name,
    metric_category,
    metric_value,
    metric_unit,
    reporting_period_start,
    reporting_period_end
from delivery_metrics
order by
    case metric_name
        when 'active_members' then 1
        when 'new_joiners' then 2
        when 'net_contributions' then 3
        when 'transfers_in_count' then 4
        when 'transfers_in_value' then 5
        when 'transfers_out_count' then 6
        when 'transfers_out_value' then 7
        when 'active_under_30' then 8
        when 'active_30_49' then 9
        when 'active_50_64' then 10
        when 'active_65_plus' then 11
        when 'average_pot_value' then 12
    end
