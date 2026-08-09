with bronze as (
    select * from {{ ref('stg_pardot_visitor_activities') }}
),

transformed as (
    select
        activity_id,
        form_id,
        form_name,
        created_at_utc,
        date_trunc('month', created_at_utc) as activity_month,
        case 
            when form_name like 'EG%' then 'EG Region'
            else 'Other'
        end as region
    from bronze
    where 
        activity_type = 4
        and form_name like 'EG%'
)

select * from transformed