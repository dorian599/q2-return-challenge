{{ config(severity = 'warn') }}

-- Warning: legacy CRM records with no matching core platform member.
select
    legacy_member_id,
    current_member_id,
    legacy_full_name,
    legacy_status
from {{ ref('sl_member_reconciliation') }}
where match_status = 'UNMATCHED_LEGACY'
