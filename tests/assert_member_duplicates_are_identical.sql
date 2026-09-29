-- Blocking: duplicate member IDs in source must be exact copies (only casing/whitespace differs).
with normalised as (
    select
        {{ normalize_member_id('member_id') }} as member_id,
        first_name,
        last_name,
        date_of_birth,
        join_date,
        leave_date,
        status,
        pot_value,
        count(*) as row_count
    from {{ ref('br_members') }}
    group by 1, 2, 3, 4, 5, 6, 7, 8
),

duplicate_groups as (
    select
        member_id,
        count(*) as distinct_copies
    from normalised
    group by member_id
    having sum(row_count) > 1
)

select
    d.member_id,
    d.distinct_copies
from duplicate_groups as d
where d.distinct_copies > 1
