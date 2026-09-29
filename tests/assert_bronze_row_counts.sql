-- Blocking test: bronze row counts must match source CSV row counts.
select 'br_members' as model_name, count(*) as actual_count, 423 as expected_count
from {{ ref('br_members') }}
having count(*) != 423

union all

select 'br_contributions', count(*), 914
from {{ ref('br_contributions') }}
having count(*) != 914

union all

select 'br_transfers', count(*), 52
from {{ ref('br_transfers') }}
having count(*) != 52

union all

select 'br_legacy_crm_members', count(*), 330
from {{ ref('br_legacy_crm_members') }}
having count(*) != 330
