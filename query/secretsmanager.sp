query "secretsmanager_secret_automatic_rotation_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'rotation_rules') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'rotation_rules') is null then ' automatic rotation disabled'
        else ' automatic rotation enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_secretsmanager_secret';
  EOQ
}

query "secretsmanager_secret_automatic_rotation_lambda_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'rotation_rules') is not null and (arguments -> 'rotation_lambda_arn') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'rotation_rules') is not null and (arguments -> 'rotation_lambda_arn') is not null then ' scheduled for rotation using Lambda function'
        else ' automatic rotation using Lambda function disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_secretsmanager_secret';
  EOQ
}


query "secretsmanager_secret_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'kms_key_id')), '') = '' or
          (arguments ->> 'kms_key_id') = 'aws/secretsmanager'
        then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'kms_key_id')), '') = '' or
          (arguments ->> 'kms_key_id') = 'aws/secretsmanager'
        then ' is encrypted at rest default KMS key'
        else ' is encrypted at rest using KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_secretsmanager_secret';
  EOQ
}
