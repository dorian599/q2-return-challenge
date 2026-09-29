select
    c.canonical_member_id,
    ct.transaction_id,
    ct.member_id,
    ct.transaction_date,
    ct.amount,
    ct.contribution_type,
    ct.is_refund,
    c.canonical_member_id is null as is_orphan
from {{ ref('sl_contributions') }} as ct
left join {{ ref('sl_canonical_members') }} as c
    on ct.member_id = c.canonical_member_id
where {{ q2_filter('ct.transaction_date') }}
