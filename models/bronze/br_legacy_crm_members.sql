select
    *,
    'legacy_crm_members.csv' as _source_file,
    row_number() over () as _source_row
from {{ source('raw', 'legacy_crm_members') }}
