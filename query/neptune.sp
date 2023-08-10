query "neptune_cluster_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'storage_encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'storage_encrypted')::boolean then ' encrypted at rest'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_cloudwatch_logs_exports') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'enable_cloudwatch_logs_exports') is null then ' logging not enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'publicly_accessible')::boolean then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'publicly_accessible')::boolean then ' publicly accessible'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'storage_encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'storage_encrypted')::boolean then ' encrypted at rest'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_key_id') is null then ' not encrypted with KMS CMK'
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