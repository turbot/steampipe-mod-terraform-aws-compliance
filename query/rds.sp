query "rds_db_cluster_aurora_backtracking_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then 'skip'
        when (attributes_std -> 'backtrack_window') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then ' not Aurora MySQL-compatible edition'
        when (attributes_std -> 'backtrack_window') is not null then ' backtracking enabled'
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
      address as resource,
      case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then 'alarm'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' disabled'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'deletion_protection') is null then 'alarm'
        when (attributes_std -> 'deletion_protection')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'deletion_protection') is null then ' ''deletion_protection'' disabled'
        when (attributes_std -> 'deletion_protection')::boolean then ' ''deletion_protection'' enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'source_type') <> 'db-cluster' then 'skip'
        when (attributes_std ->> 'source_type') = 'db-cluster' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'source_type') <> 'db-cluster' then ' event subscription of ' || (attributes_std ->> 'source_type') || ' type'
        when (attributes_std ->> 'source_type') = 'db-cluster' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical db cluster events'
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
      address as resource,
      case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then 'alarm'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then ' ''iam_database_authentication_enabled'' disabled'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then ' ''iam_database_authentication_enabled'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'multi_az') is null then 'alarm'
        when (attributes_std -> 'multi_az')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'multi_az') is null then ' ''multi_az'' disabled'
        when (attributes_std -> 'multi_az')::boolean then ' ''multi_az'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'performance_insights_enabled') is null then 'alarm'
        when (attributes_std -> 'performance_insights_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'performance_insights_enabled') is null then ' performance insights disabled'
        when (attributes_std -> 'performance_insights_enabled')::boolean then ' performance insights enabled'
        else ' performance insights disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_instance';
  EOQ
}

query "rds_db_cluster_instance_performance_insights_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'performance_insights_kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'performance_insights_kms_key_id') is null then ' performance insights not encrypted with KMS CMK'
        else ' performance insights encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_instance';
  EOQ
}

query "rds_db_instance_performance_insights_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'performance_insights_kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'performance_insights_kms_key_id') is null then ' performance insights not encrypted with kms key'
        else ' performance insights encrypted with kms key'
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
      address as resource,
      case
        when (attributes_std ->> 'performance_insights_enabled') is null then 'alarm'
        when (attributes_std ->> 'performance_insights_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'performance_insights_enabled') is null then ' performance insights disabled'
        when (attributes_std ->> 'performance_insights_enabled')::boolean then ' performance insights enabled'
        else ' performance insights disabled'
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
        address as resource,
        case
          when (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
          else 'alarm'
        end status,
        split_part(address, '.', 2) || case
          when (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
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
        address as resource,
        case
          when (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
          else 'alarm'
        end status,
        split_part(address, '.', 2) || case
          when (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
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

query "rds_cluster_activity_stream_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_activity_stream';
  EOQ
}

query "rds_db_instance_and_cluster_no_default_port" {
  sql = <<-EOQ
    (
      select
        address as resource,
        case
          when (attributes_std -> 'engine') is null and (attributes_std -> 'port') is null then 'alarm'
          when (attributes_std ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((attributes_std ->> 'port')::int = 3306 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like '%postgres%' and ((attributes_std ->> 'port')::int = 5432 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like 'oracle%' and ((attributes_std ->> 'port')::int = 1521 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like 'sqlserver%' and ((attributes_std ->> 'port')::int = 1433 or (attributes_std -> 'port') is null) then 'alarm'
          else 'ok'
        end status,
        split_part(address, '.', 2) || case
          when (attributes_std -> 'engine') is null and (attributes_std -> 'port') is null then ' uses a default port'
          when (attributes_std ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((attributes_std ->> 'port')::int = 3306 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like '%postgres%' and ((attributes_std ->> 'port')::int = 5432 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like 'oracle%' and ((attributes_std ->> 'port')::int = 1521 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like 'sqlserver%' and ((attributes_std ->> 'port')::int = 1433 or (attributes_std -> 'port') is null) then ' uses a default port'
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
        address as resource,
        case
          when (attributes_std ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((attributes_std ->> 'port')::int = 3306 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like '%postgres%' and ((attributes_std ->> 'port')::int = 5432 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like 'oracle%' and ((attributes_std ->> 'port')::int = 1521 or (attributes_std -> 'port') is null) then 'alarm'
          when (attributes_std ->> 'engine') like 'sqlserver%' and ((attributes_std ->> 'port')::int = 1433 or (attributes_std -> 'port') is null) then 'alarm'
          else 'ok'
        end status,
        split_part(address, '.', 2) || case
          when (attributes_std ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((attributes_std ->> 'port')::int = 3306 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like '%postgres%' and ((attributes_std ->> 'port')::int = 5432 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like 'oracle%' and ((attributes_std ->> 'port')::int = 1521 or (attributes_std -> 'port') is null) then ' uses a default port'
          when (attributes_std ->> 'engine') like 'sqlserver%' and ((attributes_std ->> 'port')::int = 1433 or (attributes_std -> 'port') is null) then ' uses a default port'
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
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std -> 'auto_minor_version_upgrade') is null then 'ok'
        when (attributes_std -> 'auto_minor_version_upgrade')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'auto_minor_version_upgrade') is null then ' ''auto_minor_version_upgrade'' enabled'
        when (attributes_std -> 'deletion_protection')::boolean then ' ''auto_minor_version_upgrade'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'backup_retention_period') is null then 'alarm'
        when (attributes_std -> 'backup_retention_period')::integer < 1 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'backup_retention_period') is null then ' backup disabled'
        when (attributes_std -> 'backup_retention_period')::integer < 1 then ' backup disabled'
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
      address as resource,
      case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then 'alarm'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' disabled'
        when (attributes_std -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'deletion_protection') is null then 'alarm'
        when (attributes_std -> 'deletion_protection')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'deletion_protection') is null then ' ''deletion_protection'' disabled'
        when (attributes_std -> 'deletion_protection')::bool then ' ''deletion_protection'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'storage_encrypted') is null then 'alarm'
        when (attributes_std -> 'storage_encrypted')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'storage_encrypted') is null then ' not encrypted'
        when (attributes_std -> 'storage_encrypted')::bool then ' encrypted'
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
      address as resource,
      case
        when (attributes_std ->> 'source_type') <> 'db-instance' then 'skip'
        when (attributes_std ->> 'source_type') = 'db-instance' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'source_type') <> 'db-instance' then ' event subscription of ' || (attributes_std ->> 'source_type') || ' type'
        when (attributes_std ->> 'source_type') = 'db-instance' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical db cluster events'
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
      address as resource,
      case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then 'alarm'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'iam_database_authentication_enabled') is null then ' ''iam_database_authentication_enabled'' disabled'
        when (attributes_std -> 'iam_database_authentication_enabled')::bool then ' ''iam_database_authentication_enabled'' enabled'
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
      address as resource,
      (attributes_std -> 'engine')::text as engine,
      case
        when
          (attributes_std ->> 'engine')::text like any (array ['mariadb', '%mysql'])
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then 'ok'
        when
          (attributes_std ->> 'engine')::text like any (array['%postgres%'])
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then 'ok'
        when
          (attributes_std ->> 'engine')::text like 'oracle%' and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then 'ok'
        when
          (attributes_std ->> 'engine')::text = 'sqlserver-ex'
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then 'ok'
        when
          (attributes_std ->> 'engine')::text like 'sqlserver%'
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std ->> 'engine')::text like any (array ['mariadb', '%mysql'])
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then ' logging enabled'
        when
          (attributes_std ->> 'engine')::text like any (array['%postgres%'])
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then ' logging enabled'
        when
          (attributes_std ->> 'engine')::text like 'oracle%'
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then ' logging enabled'
        when
          (attributes_std ->> 'engine')::text = 'sqlserver-ex'
          and (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then ' logging enabled'
        when
          (attributes_std ->> 'engine')::text like 'sqlserver%'
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')is not null
          and (attributes_std -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then ' logging enabled'
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
      address as resource,
      case
        when (attributes_std -> 'multi_az') is null then 'alarm'
        when (attributes_std -> 'multi_az')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'multi_az') is null then ' ''multi_az'' disabled'
        when (attributes_std -> 'multi_az')::boolean then ' ''multi_az'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'publicly_accessible') is null then 'ok'
        when (attributes_std -> 'publicly_accessible')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'publicly_accessible') is null then ' not publicly accessible'
        when (attributes_std -> 'publicly_accessible')::boolean then ' publicly accessible'
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
      address as resource,
      case
        when (attributes_std ->> 'source_type') <> 'db-parameter-group' then 'skip'
        when (attributes_std ->> 'source_type') = 'db-parameter-group' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'source_type') <> 'db-parameter-group' then ' event subscription of ' || (attributes_std ->> 'source_type') || ' type'
        when (attributes_std ->> 'source_type') = 'db-parameter-group' and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical database parameter group events'
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
      address as resource,
      case
        when (attributes_std ->> 'source_type') <> 'db-security-group' then 'skip'
        when
          (attributes_std ->> 'source_type') = 'db-security-group'
          and (attributes_std -> 'enabled')::bool
          and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
          and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'source_type') <> 'db-security-group' then ' event subscription of ' || (attributes_std ->> 'source_type') || ' type'
        when
          (attributes_std ->> 'source_type') = 'db-security-group'
          and (attributes_std -> 'enabled')::bool and (attributes_std -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
          and (attributes_std -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then ' event subscription enabled for critical database security group events'
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

query "rds_db_instance_uses_recent_ca_certificate" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'ca_cert_identifier') in ('rds-ca-rsa2048-g1', 'rds-ca-rsa4096-g1', 'rds-ca-ecc384-g1') then 'ok'
        when (attributes_std ->> 'ca_cert_identifier') is null then 'skip'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'ca_cert_identifier') in ('rds-ca-rsa2048-g1', 'rds-ca-rsa4096-g1', 'rds-ca-ecc384-g1') then ' uses recent CA certificate'
        when (attributes_std ->> 'ca_cert_identifier') is null then ' CA certificate not defined'
        else ' uses an old CA certificate'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_instance';
  EOQ
}

query "memorydb_snapshot_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_memorydb_snapshot';
  EOQ
}

query "memorydb_cluster_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_memorydb_cluster';
  EOQ
}

query "memorydb_cluster_transit_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'tls_enabled') = 'false' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'tls_enabled') = 'false' then ' encryption at transit disabled'
        else ' encryption at transit enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_memorydb_cluster';
  EOQ
}

query "rds_db_snapshot_not_publicly_accesible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'shared_accounts') @> '["all"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'shared_accounts') @> '["all"]' then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_snapshot';
  EOQ
}

query "rds_db_snapshot_copy_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_db_snapshot_copy';
  EOQ
}

query "rds_db_cluster_instance_automatic_minor_version_upgrade_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'auto_minor_version_upgrade') = 'false' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'auto_minor_version_upgrade') = 'false' then ' auto minor version upgrade disabled'
        else ' auto minor version upgrade enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster_instance';
  EOQ
}

query "rds_db_cluster_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'storage_encrypted') = 'true' or (attributes_std ->> 'engine_mode') = 'serverless' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'storage_encrypted') = 'true' or (attributes_std ->> 'engine_mode') = 'serverless' then ' encryption enabled'
        else ' encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_mysql_db_cluster_audit_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'engine')::text not like '%mysql' then 'skip'
        when (attributes_std ->> 'engine')::text like '%mysql' and (attributes_std -> 'enabled_cloudwatch_logs_exports') @> '["audit"]' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'engine')::text not like '%mysql' then ' not a MySQL cluster'
        when (attributes_std ->> 'engine')::text like '%mysql' and (attributes_std -> 'enabled_cloudwatch_logs_exports') @> '["audit"]' then ' audit logging enabled'
        else ' audit logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_cluster';
  EOQ
}

query "rds_global_cluster_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'storage_encrypted')::boolean then 'ok'
        when (attributes_std ->> 'source_db_cluster_identifier') is null then 'info'
        when (attributes_std ->> 'storage_encrypted')::boolean and (attributes_std ->> 'source_db_cluster_identifier') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'storage_encrypted')::boolean then ' enccryption enabled'
        when (attributes_std ->> 'source_db_cluster_identifier') is null then ' DB cluster identifier is not provided of the primary global cluster creation'
        when (attributes_std ->> 'storage_encrypted')::boolean and (attributes_std ->> 'source_db_cluster_identifier') is not null then ' enccryption enabled'
        else ' enccryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_rds_global_cluster';
  EOQ
}
