query "cloudtrail_enabled_all_regions" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'is_multi_region_trail') is null or (arguments ->> 'is_multi_region_trail')::boolean = 'false' then 'alarm'
        when (arguments ->> 'enable_logging') is null or (arguments ->> 'enable_logging')::boolean = 'false' then 'alarm'
        when (arguments -> 'event_selector' ->> 'read_write_type')::text <> 'All' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'is_multi_region_trail') is null or (arguments ->> 'is_multi_region_trail')::boolean = 'false' then ' multi region trails not enabled'
        when (arguments ->> 'enable_logging') is null or (arguments ->> 'enable_logging')::boolean = 'false' then ' logging disabled'
        when (arguments -> 'event_selector' ->> 'read_write_type')::text <> 'All' then ' not enbaled for all events'
        else ' logging enabled for ALL events'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudtrail';
  EOQ
}

query "cloudtrail_trail_logs_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'kms_key_id') is not null then ' logs are encrypted at rest'
        else ' logs are not encrypted at rest'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudtrail';
  EOQ
}

query "cloudtrail_trail_validation_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_log_file_validation')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'enable_log_file_validation')::boolean then ' log file validation enabled'
        else ' log file validation disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudtrail';
  EOQ
}

query "cloudtrail_trail_sns_topic_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'sns_topic_name') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'sns_topic_name') is not null then ' sns topic enabled'
        else ' sns topic disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudtrail';
  EOQ
}

query "cloudtrail_event_data_store_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'kms_key_id') is not null then ' event data store encrypted using KMS CMK'
        else ' event data store not encrypted using KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudtrail_event_data_store';
  EOQ
}