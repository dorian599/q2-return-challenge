select
    c.canonical_member_id,
    t.transfer_id,
    t.member_id,
    t.completed_date as transfer_date,
    t.direction,
    t.amount,
    t.counterparty_scheme
from {{ ref('sl_transfers') }} as t
inner join {{ ref('sl_canonical_members') }} as c
    on t.member_id = c.canonical_member_id
where t.is_completed
    and {{ q2_filter('t.completed_date') }}
