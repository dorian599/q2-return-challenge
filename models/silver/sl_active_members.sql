{#
  Authoritative active-member population for Q2 reporting.

  Active member rule (SPEC + confirmed decision):
  - Contributed at least once during Q2 2026, OR
  - Has a live pot as at quarter end (ACTIVE status, no leave_date on or before 2026-06-30)
#}

with q2_contributors as (
    select distinct canonical_member_id
    from {{ ref('sl_q2_contributions') }}
    where canonical_member_id is not null
),

live_pots as (
    select canonical_member_id
    from {{ ref('sl_canonical_members') }}
    where status = 'ACTIVE'
        and (
            leave_date is null
            or leave_date > date '{{ var("quarter_end_date") }}'
        )
),

active_population as (
    select canonical_member_id from q2_contributors
    union
    select canonical_member_id from live_pots
),

active_base as (
    select
        c.canonical_member_id,
        c.date_of_birth,
        c.pot_value,
        c.dob_is_valid,
        case
            when c.dob_is_valid
            then {{ age_at('c.date_of_birth', "date '" ~ var('quarter_end_date') ~ "'") }}
        end as age,
        lp.canonical_member_id is not null as has_live_pot,
        qc.canonical_member_id is not null as contributed_in_q2
    from active_population as ap
    inner join {{ ref('sl_canonical_members') }} as c
        on ap.canonical_member_id = c.canonical_member_id
    left join live_pots as lp
        on ap.canonical_member_id = lp.canonical_member_id
    left join q2_contributors as qc
        on ap.canonical_member_id = qc.canonical_member_id
)

select
    canonical_member_id,
    date_of_birth,
    age,
    {{ age_band('age') }} as age_band,
    pot_value,
    case
        when has_live_pot and contributed_in_q2 then 'LIVE_POT_AND_CONTRIBUTOR'
        when has_live_pot then 'LIVE_POT'
        else 'CONTRIBUTOR_ONLY'
    end as active_status,
    has_live_pot,
    contributed_in_q2
from active_base
