{{ config(severity = 'warn') }}

-- Warning: transfers with no completed date (pending).
select
    transfer_id,
    member_id,
    direction,
    amount,
    requested_date
from {{ ref('sl_transfers') }}
where not is_completed
