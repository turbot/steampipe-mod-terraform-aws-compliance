query "redshift_cluster_automatic_snapshots_min_7_days" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'automated_snapshot_retention_period') is null then 'ok'
        when (attributes_std -> 'automated_snapshot_retention_period')::integer > 7 then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'automated_snapshot_retention_period') is null then ' ''automated_snapshot_retention_period'' set to 1 day by default'
        when (attributes_std -> 'automated_snapshot_retention_period')::integer > 7 then ' ''automated_snapshot_retention_period'' set to ' || (attributes_std ->> 'automated_snapshot_retention_period')::integer || ' day(s)'
        else ' ''automated_snapshot_retention_period'' set to 0 days'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_automatic_upgrade_major_versions_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'allow_version_upgrade') is null then 'ok'
        when (attributes_std -> 'allow_version_upgrade')::bool then 'ok'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'allow_version_upgrade') is null then ' ''allow_version_upgrade'' set to true by default'
        when (attributes_std -> 'allow_version_upgrade')::bool then ' ''allow_version_upgrade'' set to true'
        else ' ''allow_version_upgrade'' set to false'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_deployed_in_ec2_classic_mode" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cluster_subnet_group_name') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'cluster_subnet_group_name') is not null then ' deployed inside VPC'
        else ' not deployed inside VPC'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_encryption_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypted') is null then 'alarm'
        when (attributes_std -> 'logging') is null then 'alarm'
        when (attributes_std -> 'logging' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'encrypted') is null then ' not encrypted'
        when (attributes_std -> 'logging') is null then ' audit logging disabled'
        when (attributes_std -> 'logging' ->> 'enabled')::boolean then ' audit logging enabled'
        else ' audit logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_enhanced_vpc_routing_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enhanced_vpc_routing') is null then 'alarm'
        when (attributes_std -> 'enhanced_vpc_routing')::bool then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'enhanced_vpc_routing') is null then ' ''enhanced_vpc_routing'' set to false by default'
        when (attributes_std -> 'enhanced_vpc_routing')::bool then ' ''enhanced_vpc_routing'' set to true'
        else ' ''allow_version_upgrade'' set to false'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_kms_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypted') is not null and (attributes_std -> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'encrypted') is not null and (attributes_std -> 'kms_key_id') is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging') is null then 'alarm'
        when (attributes_std -> 'logging' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'logging') is null then ' audit logging disabled'
        when (attributes_std -> 'logging' ->> 'enabled')::boolean then ' audit logging enabled'
        else ' audit logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_maintenance_settings_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'allow_version_upgrade') is null and (attributes_std -> 'automated_snapshot_retention_period') is null then 'alarm'
        when (attributes_std -> 'allow_version_upgrade') is null and (attributes_std -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
        when (attributes_std -> 'allow_version_upgrade')::bool and (attributes_std -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'allow_version_upgrade') is null and (attributes_std -> 'automated_snapshot_retention_period') is null then ' does not have the required maintenance settings'
        when (attributes_std -> 'allow_version_upgrade') is null and (attributes_std -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
        when (attributes_std -> 'allow_version_upgrade')::bool and (attributes_std -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
        else ' does not have the required maintenance settings'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_prohibit_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'publicly_accessible') is null then 'alarm'
        when (attributes_std -> 'publicly_accessible')::bool then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'publicly_accessible') is null then ' publicly accessible'
        when (attributes_std -> 'publicly_accessible')::bool then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_no_default_database_name" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'database_name') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'database_name') is not null then ' database name defined'
        else ' no database name defined'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_cluster_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encrypted') is null then 'alarm'
        when (attributes_std ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'encrypted') is null then ' encryption disabled'
        when (attributes_std ->> 'encrypted')::bool then ' encryption enabled'
        else ' encryption disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_cluster';
  EOQ
}

query "redshift_serverless_namespace_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshiftserverless_namespace';
  EOQ
}

query "redshift_snapshot_copy_grant_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_redshift_snapshot_copy_grant';
  EOQ
}