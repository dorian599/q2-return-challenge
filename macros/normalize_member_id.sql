{% macro normalize_member_id(column_name) %}
upper(trim({{ column_name }}))
{% endmacro %}
