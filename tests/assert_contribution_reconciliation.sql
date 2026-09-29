-- Blocking: net contributions must equal gross plus refunds.
with metrics as (
    select
        max(case when metric_name = 'gross_contributions' then metric_value end) as gross,
        max(case when metric_name = 'refund_contributions' then metric_value end) as refunds,
        max(case when metric_name = 'net_contributions' then metric_value end) as net
    from {{ ref('gold_q2_return') }}
)

select *
from metrics
where abs(net - (gross + refunds)) > 0.01
