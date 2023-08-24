query "datasync_location_object_storage_expose_secret" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'secret_key') is null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'secret_key') is null then ' does not expose any secret key details'
        else ' exposes secret key detail'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_datasync_location_object_storage';
  EOQ
}
