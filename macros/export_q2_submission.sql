{% macro export_q2_submission() %}
{% if execute %}
  {% set export_sql %}
    copy (
      select *
      from {{ this }}
      order by spec_metric_number, metric_name
    ) to 'output/q2_submission_2026Q2.csv' (header, delimiter ',')
  {% endset %}
  {% do run_query(export_sql) %}
{% endif %}
{% endmacro %}
