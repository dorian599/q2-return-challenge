{#
  Member reconciliation: current core platform vs legacy CRM.

  Matching rules (deterministic, in priority order):
  1. EXACT_ID — normalised member_id = member_ref (HIGH confidence if no attribute conflicts, MEDIUM if conflicts)

  Unmatched records are retained with match_status:
  - MATCHED
  - UNMATCHED_CURRENT (in core platform only)
  - UNMATCHED_LEGACY (in legacy CRM only)
#}

with current_members as (
    select
        member_id as current_member_id,
        first_name,
        last_name,
        date_of_birth,
        status,
        leave_date
    from {{ ref('sl_members') }}
),

legacy_members as (
    select
        legacy_member_id,
        member_ref,
        full_name,
        date_of_birth,
        crm_status
    from {{ ref('sl_legacy_crm_members') }}
),

reconciled as (
    select
        c.current_member_id,
        l.legacy_member_id,
        case
            when c.current_member_id is not null and l.legacy_member_id is not null then 'MATCHED'
            when c.current_member_id is not null then 'UNMATCHED_CURRENT'
            else 'UNMATCHED_LEGACY'
        end as match_status,
        case
            when c.current_member_id is not null and l.legacy_member_id is not null then 'EXACT_ID'
            else 'NONE'
        end as match_method,
        c.first_name || ' ' || c.last_name as current_full_name,
        l.full_name as legacy_full_name,
        c.date_of_birth as current_date_of_birth,
        l.date_of_birth as legacy_date_of_birth,
        c.status as current_status,
        l.crm_status as legacy_status,
        c.leave_date as current_leave_date
    from current_members as c
    full outer join legacy_members as l
        on c.current_member_id = l.member_ref
)

select
    current_member_id,
    legacy_member_id,
    match_status,
    match_method,
    case
        when match_status != 'MATCHED' then null
        when
            lower(trim(current_full_name)) = lower(trim(legacy_full_name))
            and current_date_of_birth = legacy_date_of_birth
            and (
                (current_status = 'ACTIVE' and legacy_status = 'ACTIVE')
                or (current_status = 'LEFT' and legacy_status in ('LEAVER', 'DECEASED'))
                or (current_status = 'LEFT' and legacy_status = 'ACTIVE' and current_leave_date is not null)
            )
        then 'HIGH'
        else 'MEDIUM'
    end as match_confidence,
    case
        when match_status = 'MATCHED'
            and lower(trim(current_full_name)) != lower(trim(legacy_full_name))
        then true
        else false
    end as name_conflict,
    case
        when match_status = 'MATCHED'
            and current_date_of_birth != legacy_date_of_birth
        then true
        else false
    end as dob_conflict,
    case
        when match_status = 'MATCHED'
            and not (
                (current_status = 'ACTIVE' and legacy_status = 'ACTIVE')
                or (current_status = 'LEFT' and legacy_status in ('LEAVER', 'DECEASED'))
                or (current_status = 'LEFT' and legacy_status = 'ACTIVE' and current_leave_date is not null)
            )
        then true
        else false
    end as status_conflict,
    current_full_name,
    legacy_full_name,
    current_date_of_birth,
    legacy_date_of_birth,
    current_status,
    legacy_status
from reconciled
