{{ config(severity = 'warn') }}

-- Warning: Q2 contributions with no matching canonical member.
select
    transaction_id,
    member_id,
    transaction_date,
    amount
from {{ ref('sl_q2_contributions') }}
where is_orphan
