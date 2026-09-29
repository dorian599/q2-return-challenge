{% macro parse_flexible_date(column_name) %}
coalesce(
    try_strptime({{ column_name }}, '%Y-%m-%d'),
    try_strptime({{ column_name }}, '%d/%m/%Y')
)::date
{% endmacro %}
