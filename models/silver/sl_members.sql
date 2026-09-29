with source_members as (
    select
        member_id as raw_member_id,
        {{ normalize_member_id('member_id') }} as member_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        {{ parse_flexible_date('date_of_birth') }} as date_of_birth,
        {{ parse_flexible_date('join_date') }} as join_date,
        {{ parse_flexible_date('leave_date') }} as leave_date,
        upper(trim(status)) as status,
        cast(pot_value as bigint) / {{ var('pot_value_divisor') }} as pot_value,
        _source_row,
        _source_file
    from {{ ref('br_members') }}
),

deduped as (
    select *
    from source_members
    qualify row_number() over (
        partition by member_id
        order by _source_row
    ) = 1
)

select
    member_id,
    raw_member_id,
    first_name,
    last_name,
    date_of_birth,
    join_date,
    leave_date,
    status,
    pot_value,
    case
        when date_of_birth is null then false
        when date_of_birth > date '{{ var("quarter_end_date") }}' then false
        when join_date is not null and date_of_birth >= join_date then false
        else true
    end as dob_is_valid,
    raw_member_id != member_id as id_was_normalised,
    _source_row,
    _source_file
from deduped
