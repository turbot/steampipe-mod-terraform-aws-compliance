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

query "ecs_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') in ('DEFAULT','OVERRIDE') then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') in ('DEFAULT','OVERRIDE') then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_cluster';
  EOQ
}

query "ecs_cluster_logging_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') <> 'NONE' and (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'kms_key_id') is not null and ((arguments -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 'cloud_watch_encryption_enabled')::boolean or (arguments -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 's3_bucket_encryption_enabled')::boolean) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') <> 'NONE' and (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'kms_key_id') is not null and ((arguments -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 'cloud_watch_encryption_enabled')::boolean or (arguments -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 's3_bucket_encryption_enabled')::boolean) then ' cluster logging encrypted with kms cmk'
        when (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') = 'NONE' or (arguments -> 'configuration' -> 'execute_command_configuration' ->> 'logging') is null then ' cluster logging disabled'
        else ' cluster logging not encrypted with kms cmk'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_cluster';
  EOQ
}