query "s3_bucket_cross_region_replication_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'cors_rule') is null then ' ''cors_rule'' is not defined'
        when (arguments -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then ' enabled with cross-region replication'
        else ' not enabled with cross-region replication'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_default_encryption_enabled_kms" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') <> 'aws:kms'
        then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then ' ''sse_algorithm'' is not defined'
        when trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') = 'aws:kms' then ' default encryption with KMS enabled'
        else ' default encryption with KMS disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_default_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then 'alarm'
        when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') not in ('aws:kms', 'AES256') then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then ' ''sse_algorithm'' is not defined'
        when trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') in ('aws:kms', 'AES256') then ' default encryption enabled'
        else ' default encryption disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging' -> 'target_bucket') is null then 'alarm'
        when coalesce(trim(arguments -> 'logging' ->> 'target_bucket'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'logging' -> 'target_bucket') is null then ' ''target_bucket'' is not defined'
        when coalesce(trim(arguments -> 'logging' ->> 'target_bucket'), '') = '' then ' logging disabled'
        else ' logging enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_mfa_delete_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(lower(arguments -> 'versioning' ->> 'mfa_delete')), '') in ('true', 'false') and (arguments -> 'versioning' ->> 'mfa_delete')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'versioning' ->> 'mfa_delete')::bool then ' MFA delete enabled'
        else ' MFA delete disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_object_lock_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments -> 'object_lock_configuration' ->> 'object_lock_enabled'), '') = 'Enabled' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'object_lock_configuration' -> 'object_lock_enabled') is null then ' ''object_lock_enabled'' is not defined'
        when (arguments -> 'object_lock_configuration' ->> 'object_lock_enabled') = 'Enabled' then ' object lock enabled'
        else ' object lock not enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_bucket_public_access_blocked" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments ->> 'block_public_acls')::boolean
          and (arguments ->> 'block_public_policy')::boolean
          and (arguments ->> 'ignore_public_acls')::boolean
          and (arguments ->> 'restrict_public_buckets')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      case
        when
          arguments -> 'block_public_acls' is null
          or arguments -> 'block_public_policy' is null
          or arguments -> 'ignore_public_acls' is null
          or arguments -> 'restrict_public_buckets' is null
        then concat_ws(', ',
            case when arguments -> 'block_public_acls' is null then 'block_public_acls' end,
            case when arguments -> 'block_public_policy' is null then 'block_public_policy' end,
            case when arguments -> 'ignore_public_acls' is null then 'ignore_public_acls' end,
            case when arguments -> 'restrict_public_buckets' is null then 'restrict_public_buckets' end
          ) || ' not defined'
        when
          (arguments ->> 'block_public_acls')::boolean
          and (arguments ->> 'block_public_policy')::boolean
          and (arguments ->> 'ignore_public_acls')::boolean
          and (arguments ->> 'restrict_public_buckets')::boolean
        then 'Public access blocks enabled'
        else 'Public access not enabled for: ' ||
          concat_ws(', ',
        case when not ((arguments ->> 'block_public_acls')::boolean) then 'block_public_acls' end,
        case when not ((arguments ->> 'block_public_policy')::boolean) then 'block_public_policy' end,
        case when not ((arguments ->> 'ignore_public_acls')::boolean ) then 'ignore_public_acls' end,
        case when not ((arguments ->> 'restrict_public_buckets')::boolean) then 'restrict_public_buckets' end
      )
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket_public_access_block';
  EOQ
}

query "s3_bucket_versioning_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(lower(arguments -> 'versioning' ->> 'enabled')), '') in ('true', 'false') and (arguments -> 'versioning' -> 'enabled')::bool
        then 'ok'
        else 'alarm'
      end status,
      name || case
        when coalesce(trim(lower(arguments -> 'versioning' ->> 'enabled')), '') not in ('true', 'false') then ' versioning disabled'
        when (arguments -> 'versioning' ->> 'enabled')::bool then ' versioning enabled'
        else ' versioning disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket';
  EOQ
}

query "s3_public_access_block_account" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments ->> 'block_public_acls')::boolean
          and (arguments ->> 'block_public_policy')::boolean
          and (arguments ->> 'ignore_public_acls')::boolean
          and (arguments ->> 'restrict_public_buckets')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      case
        when
          arguments -> 'block_public_acls' is null
          or arguments -> 'block_public_policy' is null
          or arguments -> 'ignore_public_acls' is null
          or arguments -> 'restrict_public_buckets' is null
        then concat_ws(', ',
            case when arguments -> 'block_public_acls' is null then 'block_public_acls' end,
            case when arguments -> 'block_public_policy' is null then 'block_public_policy' end,
            case when arguments -> 'ignore_public_acls' is null then 'ignore_public_acls' end,
            case when arguments -> 'restrict_public_buckets' is null then 'restrict_public_buckets' end
          ) || ' not defined'
        when
          (arguments ->> 'block_public_acls')::boolean
          and (arguments ->> 'block_public_policy')::boolean
          and (arguments ->> 'ignore_public_acls')::boolean
          and (arguments ->> 'restrict_public_buckets')::boolean
        then 'Account level public access blocks enabled'
        else 'Account level public access not enabled for: ' ||
          concat_ws(', ',
            case when not ((arguments ->> 'block_public_acls')::boolean) then 'block_public_acls' end,
            case when not ((arguments ->> 'block_public_policy')::boolean) then 'block_public_policy' end,
            case when not ((arguments ->> 'ignore_public_acls')::boolean ) then 'ignore_public_acls' end,
            case when not ((arguments ->> 'restrict_public_buckets')::boolean) then 'restrict_public_buckets' end
          )
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_account_public_access_block';
  EOQ
}