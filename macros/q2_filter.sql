{% macro q2_filter(column_name) %}
(
    {{ column_name }} >= date '{{ var("q2_start_date") }}'
    and {{ column_name }} < date '{{ var("q3_start_date") }}'
)
{% endmacro %}
