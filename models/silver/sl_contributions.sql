select
    transaction_id,
    {{ normalize_member_id('member_id') }} as member_id,
    member_id as raw_member_id,
    {{ parse_flexible_date('contribution_date') }} as transaction_date,
    cast(amount as decimal(18, 2)) as amount,
    case
        when contribution_type is not null then upper(trim(contribution_type))
        when cast(amount as decimal(18, 2)) < 0 then 'REFUND'
        else upper(trim(contribution_type))
    end as contribution_type,
    contribution_type is null and cast(amount as decimal(18, 2)) < 0 as type_was_inferred,
    cast(amount as decimal(18, 2)) < 0 as is_refund,
    _source_row,
    _source_file
from {{ ref('br_contributions') }}
