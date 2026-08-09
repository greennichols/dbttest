with source as (
    select * from {{ source('google_sheets', 'FORM_INFO') }}
),

renamed as (
    select
        trim(id) as activity_id,
        cast(form_id as varchar) as form_id,
        cast(type as integer) as activity_type,
        to_timestamp_ntz(created_at) as created_at_utc,
        trim(form_name) as form_name,
        _fivetran_synced as ingested_at
    from source
)

select * from renamed