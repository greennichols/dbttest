with silver as (
    select * from {{ ref('int_pardot_visitor_activities_cleaned') }}
)

select
    activity_month,
    form_id,
    form_name,
    region,
    count(distinct activity_id) as total_activities
from silver
group by 1, 2, 3, 4
order by activity_month desc, total_activities desc