query "ecs_cluster_container_insights_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when
          (attributes_std -> 'setting' ->> 'name')::text = 'containerInsights'
          and (attributes_std -> 'setting' ->> 'value')::text = 'enabled' then 'ok'
        else 'alarm'
      end as status,
      address || case
        when
          (attributes_std -> 'setting' ->> 'name')::text = 'containerInsights'
          and (attributes_std -> 'setting' ->> 'value')::text = 'enabled' then ' container insights enabled'
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
      address as resource,
      case
        when (attributes_std -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then ' encryption in transit enabled'
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
      address as resource,
      case
        when (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') in ('DEFAULT','OVERRIDE') then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') in ('DEFAULT','OVERRIDE') then ' logging enabled'
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
      address as resource,
      case
        when (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') <> 'NONE' and (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'kms_key_id') is not null and ((attributes_std -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 'cloud_watch_encryption_enabled')::boolean or (attributes_std -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 's3_bucket_encryption_enabled')::boolean) then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') <> 'NONE' and (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'kms_key_id') is not null and ((attributes_std -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 'cloud_watch_encryption_enabled')::boolean or (attributes_std -> 'configuration' -> 'execute_command_configuration' -> 'log_configuration' ->> 's3_bucket_encryption_enabled')::boolean) then ' cluster logging encrypted with kms cmk'
        when (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') = 'NONE' or (attributes_std -> 'configuration' -> 'execute_command_configuration' ->> 'logging') is null then ' cluster logging disabled'
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

query "ecs_task_definition_role_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'execution_role_arn') is null then 'skip'
        when (attributes_std ->> 'task_role_arn') is null then 'skip'
        when (attributes_std ->> 'execution_role_arn') is not null and (attributes_std ->> 'task_role_arn') is not null and (attributes_std ->> 'execution_role_arn') <> (attributes_std ->> 'task_role_arn') then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'execution_role_arn') is null then ' execution_role_arn not set'
        when (attributes_std ->> 'task_role_arn') is null then ' task_role_arn not set'
        when (attributes_std ->> 'execution_role_arn') is not null and (attributes_std ->> 'task_role_arn') is not null and (attributes_std ->> 'execution_role_arn') <> (attributes_std ->> 'task_role_arn') then ' execution_role_arn and task_role_arn are different'
        else ' execution_role_arn and task_role_arn are the same'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_task_definition';
  EOQ
}

query "ecs_service_fargate_uses_latest_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'launch_type') = 'FARGATE' and (attributes_std ->> 'platform_version') = 'LATEST' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'launch_type') = 'FARGATE' and (attributes_std ->> 'platform_version') = 'LATEST' then ' fargate latest'
        when (attributes_std ->> 'launch_type') = 'FARGATE' and (attributes_std ->> 'platform_version') <> 'LATEST' then ' fargate not latest'
        else ' not fargate'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecs_task_definition';
  EOQ
}

query "ecs_task_definition_no_host_pid_mode" {
  sql = <<-EOQ
    with task_with_host as (
      select
        distinct (address ) as name
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((attributes_std ->> 'container_definitions') = '')
            then null
            else (attributes_std ->> 'container_definitions')::jsonb end
        ) as s where s ->> 'pidMode' = 'host' and type = 'aws_ecs_task_definition'
      )
      select
        type || ' ' || r.name as resource,
        case
          when h.name is null then 'ok'
          else 'alarm'
        end status,
        case
          when h.name is null then ' shares the host process namespace'
          else ' does not share the host process namespace'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
      from
        terraform_resource as r
        left join task_with_host as h on h.name = concat(r.type || ' ' || r.name)
      where
        type = 'aws_ecs_task_definition';
  EOQ
}

query "ecs_task_definition_container_non_privileged" {
  sql = <<-EOQ
    with task_with_root_privilege as (
      select
        distinct (address ) as name
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((attributes_std ->> 'container_definitions') = '')
            then null
            else (attributes_std ->> 'container_definitions')::jsonb end
        ) as s where (s ->> 'privilege')::boolean and type = 'aws_ecs_task_definition'
      )
      select
        type || ' ' || r.name as resource,
        case
          when p.name is null then 'ok'
          else 'alarm'
        end status,
        case
          when p.name is null then ' does not have elevated privileges'
          else ' has elevated privileges'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
      from
        terraform_resource as r
        left join task_with_root_privilege as p on p.name = concat(r.type || ' ' || r.name)
      where
        type = 'aws_ecs_task_definition';
  EOQ
}

query "ecs_task_definition_container_readonly_root_filesystem" {
  sql = <<-EOQ
    with task_with_readonly_root_filesystem as (
      select
        distinct (address ) as name
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((attributes_std ->> 'container_definitions') = '')
            then null
            else (attributes_std ->> 'container_definitions')::jsonb end
        ) as s where (s ->> 'ReadonlyRootFilesystem')::boolean and type = 'aws_ecs_task_definition'
      )
      select
        type || ' ' || r.name as resource,
        case
          when p.name is not null then 'ok'
          else 'alarm'
        end status,
        case
          when p.name is not null then ' containers limited to read-only access to root filesystems'
          else ' containers not limited to read-only access to root filesystems'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
      from
        terraform_resource as r
        left join task_with_readonly_root_filesystem as p on p.name = concat(r.type || ' ' || r.name)
      where
        type = 'aws_ecs_task_definition';
  EOQ
}
