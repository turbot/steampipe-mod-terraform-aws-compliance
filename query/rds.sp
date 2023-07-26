query "rds_db_cluster_aurora_backtracking_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then 'skip'
        when (arguments -> 'backtrack_window') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then ' not Aurora MySQL-compatible edition'
        when (arguments -> 'backtrack_window') is not null then ' backtracking enabled'
        else ' backtracking disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_db_cluster_copy_tags_to_snapshot_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'copy_tags_to_snapshot') is null then 'alarm'
        when (arguments -> 'copy_tags_to_snapshot')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' disabled'
        when (arguments -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
        else ' ''copy_tags_to_snapshot'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_db_cluster_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'deletion_protection') is null then 'alarm'
        when (arguments -> 'deletion_protection')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'deletion_protection') is null then ' ''deletion_protection'' disabled'
        when (arguments -> 'deletion_protection')::boolean then ' ''deletion_protection'' enabled'
        else ' ''deletion_protection'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_db_cluster_events_subscription" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'source_type') <> 'db-cluster' then 'skip'
        when (arguments ->> 'source_type') = 'db-cluster' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'source_type') <> 'db-cluster' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
        when (arguments ->> 'source_type') = 'db-cluster' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical db cluster events'
        else ' event subscription missing critical db cluster events'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_event_subscription';
  EOQ
}

query "rds_db_cluster_iam_authentication_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'iam_database_authentication_enabled') is null then 'alarm'
        when (arguments -> 'iam_database_authentication_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'iam_database_authentication_enabled') is null then ' ''iam_database_authentication_enabled'' disabled'
        when (arguments -> 'iam_database_authentication_enabled')::bool then ' ''iam_database_authentication_enabled'' enabled'
        else ' ''iam_database_authentication_enabled'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_db_cluster_multiple_az_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'multi_az') is null then 'alarm'
        when (arguments -> 'multi_az')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'multi_az') is null then ' ''multi_az'' disabled'
        when (arguments -> 'multi_az')::boolean then ' ''multi_az'' enabled'
        else ' ''multi_az'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_db_cluster_instance_performance_insights_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'performance_insights_enabled') is null then 'alarm'
        when (arguments -> 'performance_insights_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'performance_insights_enabled') is null then ' ''performance_insights_enabled'' disabled'
        when (arguments -> 'performance_insights_enabled')::boolean then ' ''performance_insights_enabled'' enabled'
        else ' ''performance_insights_enabled'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_instance';
  EOQ
}

query "rds_db_cluster_instance_performance_insights_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'performance_insights_kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'performance_insights_kms_key_id') is null then ' ''performance_insights_kms_key_id'' not set'
        else ' ''performance_insights_kms_key_id'' set'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_instance';
  EOQ
}

query "rds_db_instance_performance_insights_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'performance_insights_kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'performance_insights_kms_key_id') is null then ' ''performance_insights_kms_key_id'' not set'
        else ' ''performance_insights_kms_key_id'' set'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_performance_insights_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'performance_insights_enabled') is null then 'alarm'
        when (arguments -> 'performance_insights_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'performance_insights_enabled') is null then ' ''performance_insights_enabled'' disabled'
        when (arguments -> 'performance_insights_enabled')::boolean then ' ''performance_insights_enabled'' enabled'
        else ' ''performance_insights_enabled'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_and_cluster_enhanced_monitoring_enabled" {
  sql = <<-EOQ
    (
      select
        type || ' ' || name as resource,
        case
          when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
          else 'alarm'
        end status,
        name || case
          when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
          else ' ''enabled_cloudwatch_logs_exports'' disabled'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
      from
        terraform_resource
      where
        type = 'aws_db_instance'
    )
    union
    (
      select
        type || ' ' || name as resource,
        case
          when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
          else 'alarm'
        end status,
        name || case
          when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
          else ' ''enabled_cloudwatch_logs_exports'' disabled'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
      from
        terraform_resource
      where
        type = 'aws_rds_cluster'
    );
  EOQ
}

query "rds_db_instance_and_cluster_no_default_port" {
  sql = <<-EOQ
    (
      select
        type || ' ' || name as resource,
        case
          when (arguments -> 'engine') is null and (arguments -> 'port') is null then 'alarm'
          when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then 'alarm'
          else 'ok'
        end status,
        name || case
          when (arguments -> 'engine') is null and (arguments -> 'port') is null then ' uses a default port'
          when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then ' uses a default port'
          else ' does not use a default port'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
      from
        terraform_resource
      where
        type = 'aws_rds_cluster'
    )
    union
    (
      select
        type || ' ' || name as resource,
        case
          when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then 'alarm'
          when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then 'alarm'
          else 'ok'
        end status,
        name || case
          when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then ' uses a default port'
          when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then ' uses a default port'
          else ' does not use a default port'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
      from
        terraform_resource
      where
        type = 'aws_db_instance'
    );
    EOQ
}

query "rds_db_cluster_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'kms_key_id') is null then ' is encrypted with KMS CMK'
        else ' is not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ 
}

query "rds_db_instance_automatic_minor_version_upgrade_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'auto_minor_version_upgrade') is null then 'ok'
        when (arguments -> 'auto_minor_version_upgrade')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'auto_minor_version_upgrade') is null then ' ''auto_minor_version_upgrade'' enabled'
        when (arguments -> 'deletion_protection')::boolean then ' ''auto_minor_version_upgrade'' enabled'
        else ' ''auto_minor_version_upgrade'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_backup_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'backup_retention_period') is null then 'alarm'
        when (arguments -> 'backup_retention_period')::integer < 1 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'backup_retention_period') is null then ' backup disabled'
        when (arguments -> 'backup_retention_period')::integer < 1 then ' backup disabled'
        else ' backup enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_copy_tags_to_snapshot_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'copy_tags_to_snapshot') is null then 'alarm'
        when (arguments -> 'copy_tags_to_snapshot')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' disabled'
        when (arguments -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
        else ' ''copy_tags_to_snapshot'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'deletion_protection') is null then 'alarm'
        when (arguments -> 'deletion_protection')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'deletion_protection') is null then ' ''deletion_protection'' disabled'
        when (arguments -> 'deletion_protection')::bool then ' ''deletion_protection'' enabled'
        else ' ''deletion_protection'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'storage_encrypted') is null then 'alarm'
        when (arguments -> 'storage_encrypted')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'storage_encrypted') is null then ' not encrypted'
        when (arguments -> 'storage_encrypted')::bool then ' encrypted'
        else ' not encrypted'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_events_subscription" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'source_type') <> 'db-instance' then 'skip'
        when (arguments ->> 'source_type') = 'db-instance' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'source_type') <> 'db-instance' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
        when (arguments ->> 'source_type') = 'db-instance' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical db cluster events'
        else ' event subscription missing critical db instance events'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_event_subscription';
  EOQ
}

query "rds_db_instance_iam_authentication_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'iam_database_authentication_enabled') is null then 'alarm'
        when (arguments -> 'iam_database_authentication_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'iam_database_authentication_enabled') is null then ' ''iam_database_authentication_enabled'' disabled'
        when (arguments -> 'iam_database_authentication_enabled')::bool then ' ''iam_database_authentication_enabled'' enabled'
        else ' ''iam_database_authentication_enabled'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      (arguments -> 'engine')::text as engine,
      case
        when
          (arguments ->> 'engine')::text like any (array ['mariadb', '%mysql'])
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then 'ok'
        when
          (arguments ->> 'engine')::text like any (array['%postgres%'])
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then 'ok'
        when
          (arguments ->> 'engine')::text like 'oracle%' and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then 'ok'
        when
          (arguments ->> 'engine')::text = 'sqlserver-ex'
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then 'ok'
        when
          (arguments ->> 'engine')::text like 'sqlserver%'
          and (arguments -> 'enabled_cloudwatch_logs_exports')is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments ->> 'engine')::text like any (array ['mariadb', '%mysql'])
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then ' logging enabled'
        when
          (arguments ->> 'engine')::text like any (array['%postgres%'])
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then ' logging enabled'
        when
          (arguments ->> 'engine')::text like 'oracle%'
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then ' logging enabled'
        when
          (arguments ->> 'engine')::text = 'sqlserver-ex'
          and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then ' logging enabled'
        when
          (arguments ->> 'engine')::text like 'sqlserver%'
          and (arguments -> 'enabled_cloudwatch_logs_exports')is not null
          and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_multiple_az_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'multi_az') is null then 'alarm'
        when (arguments -> 'multi_az')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'multi_az') is null then ' ''multi_az'' disabled'
        when (arguments -> 'multi_az')::boolean then ' ''multi_az'' enabled'
        else ' ''multi_az'' disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_instance_prohibit_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'publicly_accessible') is null then 'ok'
        when (arguments -> 'publicly_accessible')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'publicly_accessible') is null then ' not publicly accessible'
        when (arguments -> 'publicly_accessible')::boolean then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "rds_db_parameter_group_events_subscription" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'source_type') <> 'db-parameter-group' then 'skip'
        when (arguments ->> 'source_type') = 'db-parameter-group' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'source_type') <> 'db-parameter-group' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
        when (arguments ->> 'source_type') = 'db-parameter-group' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical database parameter group events'
        else ' event subscription missing critical database parameter group events'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_event_subscription';
  EOQ
}

query "rds_db_security_group_events_subscription" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'source_type') <> 'db-security-group' then 'skip'
        when
          (arguments ->> 'source_type') = 'db-security-group'
          and (arguments -> 'enabled')::bool
          and (arguments -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
          and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'source_type') <> 'db-security-group' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
        when
          (arguments ->> 'source_type') = 'db-security-group'
          and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
          and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then ' event subscription enabled for critical database security group events'
        else ' event subscription missing critical database security group events'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_event_subscription';
  EOQ
}