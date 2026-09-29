{{ config(severity = 'warn') }}

-- Warning: negative contributions where contribution_type was inferred as REFUND.
select
    transaction_id,
    member_id,
    transaction_date,
    amount,
    contribution_type
from {{ ref('sl_contributions') }}
where type_was_inferred
