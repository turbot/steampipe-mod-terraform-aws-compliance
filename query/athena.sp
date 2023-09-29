query "athena_database_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encryption_configuration') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_configuration') is not null then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_athena_database';
  EOQ
}

query "athena_workgroup_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
        then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
        then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_athena_workgroup';
  EOQ
}

query "athena_workgroup_enforce_workgroup_configuration" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'configuration' -> 'enforce_workgroup_configuration')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'configuration' -> 'enforce_workgroup_configuration')::boolean then ' enforce workgroup configuration set'
        else ' enforce workgroup configuration not set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_athena_workgroup';
  EOQ
}
