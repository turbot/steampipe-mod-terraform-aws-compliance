query "glue_crawler_security_configuration_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_configuration') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'security_configuration') is null then ' security configuration disabled'
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