-- Blocking: delivery view must contain exactly 12 metric rows (six SPEC categories in long format).
select count(*) as actual_count
from {{ ref('gold_q2_submission') }}
having count(*) != 12
