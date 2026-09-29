select
    transfer_id,
    {{ normalize_member_id('member_id') }} as member_id,
    member_id as raw_member_id,
    upper(trim(direction)) as direction,
    cast(value as decimal(18, 2)) as amount,
    trim(counterparty_scheme) as counterparty_scheme,
    {{ parse_flexible_date('requested_date') }} as requested_date,
    {{ parse_flexible_date('completed_date') }} as completed_date,
    completed_date is not null as is_completed,
    _source_row,
    _source_file
from {{ ref('br_transfers') }}
