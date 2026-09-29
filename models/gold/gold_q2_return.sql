{{
    config(
        post_hook="{{ export_q2_return() }}"
    )
}}

{#
  Primary Q2 2026 regulatory return — six required metrics in reporting-friendly long format.
  All business rules are sourced from Silver models; this model aggregates only.
#}

with active_members as (
    select count(distinct canonical_member_id) as metric_value
    from {{ ref('sl_active_members') }}
),

new_joiners as (
    select count(distinct canonical_member_id) as metric_value
    from {{ ref('sl_canonical_members') }}
    where {{ q2_filter('join_date') }}
),

contributions as (
    select
        coalesce(sum(amount) filter (where amount > 0), 0) as gross_contributions,
        coalesce(sum(amount) filter (where amount < 0), 0) as refund_contributions,
        coalesce(sum(amount), 0) as net_contributions
    from {{ ref('sl_q2_contributions') }}
),

transfers_in as (
    select
        count(*) as transfer_count,
        coalesce(sum(amount), 0) as transfer_value
    from {{ ref('sl_q2_transfers') }}
    where direction = 'IN'
),

transfers_out as (
    select
        count(*) as transfer_count,
        coalesce(sum(amount), 0) as transfer_value
    from {{ ref('sl_q2_transfers') }}
    where direction = 'OUT'
),

age_bands as (
    select
        coalesce(sum(case when age_band = 'UNDER_30' then 1 else 0 end), 0) as active_under_30,
        coalesce(sum(case when age_band = '30_49' then 1 else 0 end), 0) as active_30_49,
        coalesce(sum(case when age_band = '50_64' then 1 else 0 end), 0) as active_50_64,
        coalesce(sum(case when age_band = '65_PLUS' then 1 else 0 end), 0) as active_65_plus,
        coalesce(sum(case when age_band = 'UNKNOWN' then 1 else 0 end), 0) as active_age_unknown
    from {{ ref('sl_active_members') }}
),

average_pot as (
    select coalesce(avg(pot_value), 0) as metric_value
    from {{ ref('sl_active_members') }}
    where pot_value is not null
)

select
    'active_members' as metric_name,
    'membership' as metric_category,
    cast(metric_value as decimal(18, 2)) as metric_value,
    'count' as metric_unit,
    date '{{ var("q2_start_date") }}' as reporting_period_start,
    date '{{ var("quarter_end_date") }}' as reporting_period_end
from active_members

union all

select
    'new_joiners',
    'membership',
    cast(metric_value as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from new_joiners

union all

select
    'gross_contributions',
    'contributions',
    cast(gross_contributions as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from contributions

union all

select
    'refund_contributions',
    'contributions',
    cast(refund_contributions as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from contributions

union all

select
    'net_contributions',
    'contributions',
    cast(net_contributions as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from contributions

union all

select
    'transfers_in_count',
    'transfers',
    cast(transfer_count as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from transfers_in

union all

select
    'transfers_in_value',
    'transfers',
    cast(transfer_value as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from transfers_in

union all

select
    'transfers_out_count',
    'transfers',
    cast(transfer_count as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from transfers_out

union all

select
    'transfers_out_value',
    'transfers',
    cast(transfer_value as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from transfers_out

union all

select
    'active_under_30',
    'age_bands',
    cast(active_under_30 as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from age_bands

union all

select
    'active_30_49',
    'age_bands',
    cast(active_30_49 as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from age_bands

union all

select
    'active_50_64',
    'age_bands',
    cast(active_50_64 as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from age_bands

union all

select
    'active_65_plus',
    'age_bands',
    cast(active_65_plus as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from age_bands

union all

select
    'active_age_unknown',
    'age_bands',
    cast(active_age_unknown as decimal(18, 2)),
    'count',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from age_bands

union all

select
    'average_pot_value',
    'pot_value',
    cast(round(metric_value, 2) as decimal(18, 2)),
    'GBP',
    date '{{ var("q2_start_date") }}',
    date '{{ var("quarter_end_date") }}'
from average_pot
