query "athena_database_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_configuration') is not null then ' encrypted at rest'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
        then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
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
