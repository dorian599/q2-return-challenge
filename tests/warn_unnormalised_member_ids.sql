{{ config(severity = 'warn') }}

-- Warning: member IDs that required normalisation (casing or whitespace).
select
    member_id,
    raw_member_id
from {{ ref('sl_members') }}
where id_was_normalised
