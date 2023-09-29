query "appsync_graphql_api_field_level_logs_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'log_config' ->> 'field_log_level') in ('ALL','ERROR') then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'log_config' ->> 'field_log_level') in ('ALL','ERROR') then ' field level logs enabled'
        else ' field level logs disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_appsync_graphql_api';
  EOQ
}

query "appsync_graphql_api_cloudwatch_logs_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'log_config' ->> 'cloudwatch_logs_role_arn') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'log_config' ->> 'cloudwatch_logs_role_arn') is not null then ' cloudwatch logs enabled'
        else ' cloudwatch logs disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_appsync_graphql_api';
  EOQ
}

query "appsync_api_cache_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'at_rest_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'at_rest_encryption_enabled')::boolean then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_appsync_api_cache';
  EOQ
}

query "appsync_api_cache_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'transit_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'transit_encryption_enabled')::boolean then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_appsync_api_cache';
  EOQ
}
