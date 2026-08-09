{% macro format_date(column_name) %}
    to_char({{ column_name }}, 'YYYY-MM-DD HH24:MI:SS')
{% endmacro %}