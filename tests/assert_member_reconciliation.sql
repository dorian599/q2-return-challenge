-- Blocking: reconciliation counts must balance to source populations.
with summary as (
    select * from {{ ref('gold_reconciliation_summary') }}
)

select 'matched_plus_unmatched_current' as check_name
from summary
where matched_member_count + unmatched_current_count != current_member_count

union all

select 'matched_plus_unmatched_legacy'
from summary
where matched_member_count + unmatched_legacy_count != legacy_member_count
