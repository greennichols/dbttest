with monthly_summary as (
    select
        activity_month,
        region,
        count(distinct email_performance_id) as total_campaigns_sent,
        sum(emails_sent) as total_emails_sent,
        sum(unique_opens) as total_unique_opens,
        sum(unique_clicks) as total_unique_clicks,
        sum(total_bounces) as total_bounces,
        sum(total_unsubscribes) as total_unsubscribes
    from {{ ref('int_pardot_email_performance_cleaned') }}
    group by 1, 2
),

with_lags as (
    select
        *,
        lag(total_emails_sent, 1) over (
            partition by region order by activity_month
        ) as prev_month_emails_sent,
        
        lag(total_unique_clicks, 1) over (
            partition by region order by activity_month
        ) as prev_month_unique_clicks
    from monthly_summary
)

select
    activity_month,
    region,
    total_campaigns_sent,
    total_emails_sent,
    total_unique_opens,
    total_unique_clicks,
    total_bounces,
    total_unsubscribes,
    
    -- Calculated Rates via Macro
    {{ calculate_rate('total_unique_opens', 'total_emails_sent') }} as monthly_open_rate_pct,
    {{ calculate_rate('total_unique_clicks', 'total_emails_sent') }} as monthly_ctr_pct,
    
    -- Month-over-Month Growth Calculation
    round(
        (total_emails_sent - prev_month_emails_sent) :: float / nullif(prev_month_emails_sent, 0) * 100, 
        2
    ) as emails_sent_mom_pct

from with_lags
order by activity_month desc, region