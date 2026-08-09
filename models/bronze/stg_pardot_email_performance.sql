with source as (
    select * from {{ source('google_sheets', 'EMAILINFO') }}
),

renamed as (
    select
        -- Native Snowflake MD5 surrogate key
        md5(concat(coalesce(cast(EMAIL_NAME as varchar), ''), '_', coalesce(cast(DATE as varchar), ''))) as email_performance_id,
        
        -- Dimensions
        trim(EMAIL_NAME) as email_name,
        cast(DATE as date) as email_sent_date,
        trim(LISTRECIPIENTS) as recipient_lists,

        -- Metrics (handling potential NULL values)
        coalesce(cast(EMAILS_SENT as integer), 0) as emails_sent,
        coalesce(cast(EMAILS_OPENED_UNIQUE_ as integer), 0) as unique_opens,
        coalesce(cast(EMAILS_CLICKED_UNIQUE_ as integer), 0) as unique_clicks,
        coalesce(cast(EMAILS_BOUNCED as integer), 0) as total_bounces,
        coalesce(cast(UNSUBSCRIBED as integer), 0) as total_unsubscribes

    from source
)

select * from renamed