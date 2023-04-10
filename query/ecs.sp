query "ecs_cluster_container_insights_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments -> 'setting' ->> 'name')::text = 'containerInsights'
          and (arguments -> 'setting' ->> 'value')::text = 'enabled' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'setting' ->> 'name')::text = 'containerInsights'
          and (arguments -> 'setting' ->> 'value')::text = 'enabled' then ' container insights enabled'
        else ' container insights disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_cluster';
  EOQ
}

query "ecs_task_definition_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_task_definition';
  EOQ
}
