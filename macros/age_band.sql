{% macro age_band(age) %}
case
    when {{ age }} is null then 'UNKNOWN'
    when {{ age }} < 30 then 'UNDER_30'
    when {{ age }} between 30 and 49 then '30_49'
    when {{ age }} between 50 and 64 then '50_64'
    when {{ age }} >= 65 then '65_PLUS'
end
{% endmacro %}
