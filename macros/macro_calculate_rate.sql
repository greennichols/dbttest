{% macro calculate_rate(numerator, denominator, decimal_places=2) %}
    round(
        coalesce(
            cast({{ numerator }} as float) / nullif({{ denominator }}, 0) * 100, 
            0
        ), 
        {{ decimal_places }}
    )
{% endmacro %}