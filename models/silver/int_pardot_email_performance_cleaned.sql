with base as (
    select * from {{ ref('stg_pardot_email_performance') }}
),

transformed as (
    select
        email_performance_id,
        email_name,
        email_sent_date,
        date_trunc('month', email_sent_date) as activity_month,
        recipient_lists,
        
        -- Categorize Region
        case 
            when recipient_lists ilike '%EG Region%' then 'EG Region'
            else 'Other Region'
        end as region,

        -- Raw Measures
        emails_sent,
        unique_opens,
        unique_clicks,
        total_bounces,
        total_unsubscribes,

        -- Calculated Ratios using Macro
        {{ calculate_rate('unique_opens', 'emails_sent') }} as open_rate_pct,
        {{ calculate_rate('unique_clicks', 'unique_opens') }} as click_to_open_rate_pct,
        {{ calculate_rate('unique_clicks', 'emails_sent') }} as click_through_rate_pct,
        {{ calculate_rate('total_bounces', 'emails_sent') }} as bounce_rate_pct,
        {{ calculate_rate('total_unsubscribes', 'emails_sent') }} as unsubscribe_rate_pct

    from base
)

select * from transformed