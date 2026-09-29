{#
  Canonical member dimension — one row per core-platform member.
  Core platform is the system of record; legacy attributes retained for audit.
#}

select
    m.member_id as canonical_member_id,
    m.raw_member_id,
    m.first_name,
    m.last_name,
    m.date_of_birth,
    m.join_date,
    m.leave_date,
    m.status,
    m.pot_value,
    m.dob_is_valid,
    coalesce(r.match_status, 'UNMATCHED_CURRENT') as match_status,
    r.legacy_member_id,
    r.legacy_full_name,
    r.legacy_date_of_birth,
    r.legacy_status,
    r.match_confidence,
    coalesce(r.name_conflict, false) as name_conflict,
    coalesce(r.dob_conflict, false) as dob_conflict,
    coalesce(r.status_conflict, false) as status_conflict
from {{ ref('sl_members') }} as m
left join {{ ref('sl_member_reconciliation') }} as r
    on m.member_id = r.current_member_id
