query "sagemaker_endpoint_configuration_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_key_arn') is null then ' encryption at rest not enabled'
        else ' encryption at rest enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_endpoint_configuration';
  EOQ
}

query "sagemaker_notebook_instance_direct_internet_access_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'direct_internet_access') is null or (arguments ->> 'direct_internet_access') = 'Disabled' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when trim(arguments ->> 'direct_internet_access') = '' then ' ''direct_internet_access'' is not defined'
        when (arguments -> 'direct_internet_access') is null or (arguments ->> 'direct_internet_access') = 'Disabled' then ' direct internet access disabled'
        else ' direct internet access enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_notebook_instance';
  EOQ
}

query "sagemaker_notebook_instance_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'kms_key_id') is null then ' encryption at rest disabled'
        else ' encryption at rest enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_notebook_instance';
  EOQ
}
