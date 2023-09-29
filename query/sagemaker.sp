query "sagemaker_endpoint_configuration_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'kms_key_arn') is null then ' encryption at rest not enabled'
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
      address as resource,
      case
        when (attributes_std -> 'direct_internet_access') is null or (attributes_std ->> 'direct_internet_access') = 'Disabled' then 'ok'
        else 'alarm'
      end as status,
      address || case
        when trim(attributes_std ->> 'direct_internet_access') = '' then ' ''direct_internet_access'' is not defined'
        when (attributes_std -> 'direct_internet_access') is null or (attributes_std ->> 'direct_internet_access') = 'Disabled' then ' direct internet access disabled'
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
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' encryption at rest disabled'
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

query "sagemaker_notebook_instance_in_vpc" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'subnet_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'subnet_id') is not null then ' in VPC'
        else ' not in VPC'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_notebook_instance';
  EOQ
}

query "sagemaker_notebook_instance_root_access_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'root_access') = 'Disabled' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'root_access') = 'Disabled' then ' root access disabled'
        else ' root access enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_notebook_instance';
  EOQ
}

query "sagemaker_domain_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when attributes_std -> 'kms_key_id' is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when attributes_std -> 'kms_key_id' is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sagemaker_domain';
  EOQ
}
