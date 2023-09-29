query "datasync_location_object_storage_expose_secret" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'secret_key') is null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'secret_key') is null then ' does not expose any secret key details'
        else ' exposes secret key details'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_datasync_location_object_storage';
  EOQ
}
