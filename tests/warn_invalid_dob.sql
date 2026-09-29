{{ config(severity = 'warn') }}

-- Warning: members with invalid date of birth.
select
    canonical_member_id,
    date_of_birth,
    join_date
from {{ ref('sl_canonical_members') }}
where not dob_is_valid
