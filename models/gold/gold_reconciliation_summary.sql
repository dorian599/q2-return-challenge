select
    count(*) filter (where current_member_id is not null) as current_member_count,
    count(*) filter (where legacy_member_id is not null) as legacy_member_count,
    count(*) filter (where match_status = 'MATCHED') as matched_member_count,
    count(*) filter (where match_status = 'UNMATCHED_CURRENT') as unmatched_current_count,
    count(*) filter (where match_status = 'UNMATCHED_LEGACY') as unmatched_legacy_count,
    count(*) filter (
        where match_status = 'MATCHED'
            and (name_conflict or dob_conflict or status_conflict)
    ) as matched_with_conflict_count,
    count(*) filter (where name_conflict) as name_conflict_count,
    count(*) filter (where dob_conflict) as dob_conflict_count,
    count(*) filter (where status_conflict) as status_conflict_count
from {{ ref('sl_member_reconciliation') }}
