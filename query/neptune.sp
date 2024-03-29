query "neptune_cluster_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'storage_encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'storage_encrypted')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enable_cloudwatch_logs_exports') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enable_cloudwatch_logs_exports') is null then ' logging not enabled'
        else ' logging enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_instance_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'publicly_accessible')::boolean then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'publicly_accessible')::boolean then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster_instance';
  EOQ
}

query "neptune_snapshot_storage_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'storage_encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'storage_encrypted')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster_snapshot';
  EOQ
}

query "neptune_snapshot_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster_snapshot';
  EOQ
}

query "neptune_cluster_backup_retention_period_7" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'backup_retention_period') is null then 'alarm'
        when ((attributes_std ->> 'backup_retention_period'))::int >= 7 then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'backup_retention_period') is null then ' backup retention not set'
        else ' backup retention set to ' || (attributes_std ->> 'backup_retention_period')
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_copy_tags_to_snapshot_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then 'alarm'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' not set'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
        else ' ''copy_tags_to_snapshot'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_iam_authentication_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then 'alarm'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then ' IAM database authentication disabled'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then ' IAM database authentication enabled'
        else ' ''iam_database_authentication_enabled'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}