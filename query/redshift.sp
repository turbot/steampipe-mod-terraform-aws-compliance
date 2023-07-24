query "redshift_cluster_automatic_snapshots_min_7_days" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'automated_snapshot_retention_period') is null then 'ok'
        when (arguments -> 'automated_snapshot_retention_period')::integer > 7 then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'automated_snapshot_retention_period') is null then ' ''automated_snapshot_retention_period'' set to 1 day by default'
        when (arguments -> 'automated_snapshot_retention_period')::integer > 7 then ' ''automated_snapshot_retention_period'' set to ' || (arguments ->> 'automated_snapshot_retention_period')::integer || ' day(s)'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'allow_version_upgrade') is null then 'ok'
        when (arguments -> 'allow_version_upgrade')::bool then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'allow_version_upgrade') is null then ' ''allow_version_upgrade'' set to true by default'
        when (arguments -> 'allow_version_upgrade')::bool then ' ''allow_version_upgrade'' set to true'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'cluster_subnet_group_name') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'cluster_subnet_group_name') is not null then ' deployed inside VPC'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments -> 'logging') is null then 'alarm'
        when (arguments -> 'logging' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encrypted') is null then ' not encrypted'
        when (arguments -> 'logging') is null then ' audit logging disabled'
        when (arguments -> 'logging' ->> 'enabled')::boolean then ' audit logging enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'enhanced_vpc_routing') is null then 'alarm'
        when (arguments -> 'enhanced_vpc_routing')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'enhanced_vpc_routing') is null then ' ''enhanced_vpc_routing'' set to false by default'
        when (arguments -> 'enhanced_vpc_routing')::bool then ' ''enhanced_vpc_routing'' set to true'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is not null and (arguments -> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encrypted') is not null and (arguments -> 'kms_key_id') is not null then ' encrypted with KMS'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging') is null then 'alarm'
        when (arguments -> 'logging' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'logging') is null then ' audit logging disabled'
        when (arguments -> 'logging' ->> 'enabled')::boolean then ' audit logging enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period') is null then 'alarm'
        when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
        when (arguments -> 'allow_version_upgrade')::bool and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period') is null then ' does not have the required maintenance settings'
        when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
        when (arguments -> 'allow_version_upgrade')::bool and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'publicly_accessible') is null then 'alarm'
        when (arguments -> 'publicly_accessible')::bool then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'publicly_accessible') is null then ' publicly accessible'
        when (arguments -> 'publicly_accessible')::bool then ' publicly accessible'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'database_name') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'database_name') is not null then ' has database name defined'
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