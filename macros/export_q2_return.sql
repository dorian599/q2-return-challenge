{% macro export_q2_return() %}
{% if execute %}
  {% set export_sql %}
    copy (
      select *
      from {{ this }}
      order by metric_name
    ) to 'output/q2_return_2026Q2.csv' (header, delimiter ',')
  {% endset %}
  {% do run_query(export_sql) %}
{% endif %}
{% endmacro %}
