query "glue_crawler_security_configuration_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'security_configuration') is null then ' security configuration disabled'
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
      address as resource,
      case
        when (attributes_std -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'security_configuration') is null then ' security configuration disabled'
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
      address as resource,
      case
        when (attributes_std -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'security_configuration') is null then ' security configuration disabled'
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
      address as resource,
      case
        when (attributes_std -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'return_connection_password_encrypted') = 'true'
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'aws_kms_key_id') is not null
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'sse_aws_kms_key_id') is not null
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'catalog_encryption_mode') = 'SSE-KMS' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'return_connection_password_encrypted') = 'true'
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'connection_password_encryption' ->> 'aws_kms_key_id') is not null
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'sse_aws_kms_key_id') is not null
        and (attributes_std -> 'data_catalog_encryption_settings' -> 'encryption_at_rest' ->> 'catalog_encryption_mode') = 'SSE-KMS' then ' encryption enabled'
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
      address as resource,
      case
        when (attributes_std -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'cloudwatch_encryption_mode') = 'SSE-KMS'
        and (attributes_std -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'kms_key_arn') is not null
        and (attributes_std -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'job_bookmarks_encryption_mode') = 'CSE-KMS'
        and (attributes_std -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'kms_key_arn') is not null
        and (attributes_std -> 'encryption_configuration' -> 's3_encryption' ->> 's3_encryption_mode') <> 'DISABLED'
        and (attributes_std -> 'encryption_configuration' -> 's3_encryption' ->> 'kms_key_arn') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'cloudwatch_encryption_mode') = 'SSE-KMS'
        and (attributes_std -> 'encryption_configuration' -> 'cloudwatch_encryption' ->> 'kms_key_arn') is not null
        and (attributes_std -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'job_bookmarks_encryption_mode') = 'CSE-KMS'
        and (attributes_std -> 'encryption_configuration' -> 'job_bookmarks_encryption' ->> 'kms_key_arn') is not null
        and (attributes_std -> 'encryption_configuration' -> 's3_encryption' ->> 's3_encryption_mode') <> 'DISABLED'
        and (attributes_std -> 'encryption_configuration' -> 's3_encryption' ->> 'kms_key_arn') is not null then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_glue_security_configuration';
  EOQ
}
