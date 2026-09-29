{% macro age_at(dob, ref_date) %}
(
    date_diff('year', {{ dob }}, {{ ref_date }})
    - case
        when strftime({{ dob }}, '%m%d') > strftime({{ ref_date }}, '%m%d')
        then 1
        else 0
      end
)
{% endmacro %}
