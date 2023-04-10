query "workspace_root_volume_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'user_volume_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'user_volume_encryption_enabled')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_workspaces_workspace';
  EOQ
}

query "workspace_user_volume_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'root_volume_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'root_volume_encryption_enabled')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_workspaces_workspace';
  EOQ
}
