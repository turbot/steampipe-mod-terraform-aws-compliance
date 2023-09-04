query "glue_crawler_security_configuration_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
        else ' security configuration enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_crawler';
  EOQ
}

query "glue_dev_endpoint_security_configuration_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
        else ' security configuration enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_dev_endpoint';
  EOQ
}

query "glue_job_security_configuration_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
        else ' security configuration enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_job';
  EOQ
}

query "glue_data_catalog_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'return_connection_password_encrypted') = 'true'
        and (arguments -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'aws_kms_key_id') is not null
        and (arguments -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'sse_aws_kms_key_id') is not null
        and (arguments -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'catalog_encryption_mode') = 'SSE-KMS' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'return_connection_password_encrypted') = 'true'
        and (arguments -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'aws_kms_key_id') is not null
        and (arguments -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'sse_aws_kms_key_id') is not null
        and (arguments -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'catalog_encryption_mode') = 'SSE-KMS' then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_data_catalog_encryption_settings';
  EOQ
}

query "glue_security_configuration_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'cloudwatch_encryption_mode') = 'SSE-KMS'
        and (arguments -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'kms_key_arn') is not null
        and (arguments -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'job_bookmarks_encryption_mode') = 'CSE-KMS'
        and (arguments -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'kms_key_arn') is not null
        and (arguments -> 'encryption_configuration' -> 's3_encryption' ->> 's3_encryption_mode') <> 'DISABLED'
        and (arguments -> 'encryption_configuration' -> 's3_encryption' ->> 'kms_key_arn') is not null  then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'cloudwatch_encryption_mode') = 'SSE-KMS'
        and (arguments -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'kms_key_arn') is not null
        and (arguments -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'job_bookmarks_encryption_mode') = 'CSE-KMS'
        and (arguments -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'kms_key_arn') is not null
        and (arguments -> 'encryption_configuration' -> 's3_encryption' ->> 's3_encryption_mode') <> 'DISABLED'
        and (arguments -> 'encryption_configuration' -> 's3_encryption' ->> 'kms_key_arn') is not null  then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      --${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_security_configuration';
  EOQ
}
