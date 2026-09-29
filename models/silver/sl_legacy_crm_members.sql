select
    crm_id as legacy_member_id,
    {{ normalize_member_id('member_ref') }} as member_ref,
    member_ref as raw_member_ref,
    trim(full_name) as full_name,
    lower(trim(full_name)) as full_name_normalized,
    {{ parse_flexible_date('dob') }} as date_of_birth,
    upper(trim(crm_status)) as crm_status,
    {{ parse_flexible_date('last_updated') }} as last_updated,
    _source_row,
    _source_file
from {{ ref('br_legacy_crm_members') }}
