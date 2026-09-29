{{ config(severity = 'warn') }}

-- Warning: matched members with attribute conflicts between core and legacy CRM.
select
    current_member_id,
    legacy_member_id,
    name_conflict,
    dob_conflict,
    status_conflict
from {{ ref('sl_member_reconciliation') }}
where match_status = 'MATCHED'
    and (name_conflict or dob_conflict or status_conflict)
