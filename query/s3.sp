query "s3_bucket_cross_region_replication_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cors_rule') is null then ' ''cors_rule'' is not defined'
        when (attributes_std -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then ' enabled with cross-region replication'
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
      address as resource,
      case
        when coalesce(trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') <> 'aws:kms'
        then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce(trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then ' ''sse_algorithm'' is not defined'
        when trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') = 'aws:kms' then ' default encryption with KMS enabled'
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
      address as resource,
      case
        when coalesce(trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then 'alarm'
        when coalesce(trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') not in ('aws:kms', 'AES256') then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when coalesce(trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then ' ''sse_algorithm'' is not defined'
        when trim(attributes_std -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') in ('aws:kms', 'AES256') then ' default encryption enabled'
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
      address as resource,
      case
        when (attributes_std -> 'logging' -> 'target_bucket') is null then 'alarm'
        when coalesce(trim(attributes_std -> 'logging' ->> 'target_bucket'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'logging' -> 'target_bucket') is null then ' ''target_bucket'' is not defined'
        when coalesce(trim(attributes_std -> 'logging' ->> 'target_bucket'), '') = '' then ' logging disabled'
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
      address as resource,
      case
        when coalesce(trim(lower(attributes_std -> 'versioning' ->> 'mfa_delete')), '') in ('true', 'false') and (attributes_std -> 'versioning' ->> 'mfa_delete')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'versioning' ->> 'mfa_delete')::bool then ' MFA delete enabled'
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
      address as resource,
      case
        when coalesce(trim(attributes_std -> 'object_lock_configuration' ->> 'object_lock_enabled'), '') = 'Enabled' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'object_lock_configuration' -> 'object_lock_enabled') is null then ' ''object_lock_enabled'' is not defined'
        when (attributes_std -> 'object_lock_configuration' ->> 'object_lock_enabled') = 'Enabled' then ' object lock enabled'
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
      address as resource,
      case
        when
          (attributes_std ->> 'block_public_acls')::boolean
          and (attributes_std ->> 'block_public_policy')::boolean
          and (attributes_std ->> 'ignore_public_acls')::boolean
          and (attributes_std ->> 'restrict_public_buckets')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      case
        when
          attributes_std -> 'block_public_acls' is null
          or attributes_std -> 'block_public_policy' is null
          or attributes_std -> 'ignore_public_acls' is null
          or attributes_std -> 'restrict_public_buckets' is null
        then concat_ws(', ',
            case when attributes_std -> 'block_public_acls' is null then 'block_public_acls' end,
            case when attributes_std -> 'block_public_policy' is null then 'block_public_policy' end,
            case when attributes_std -> 'ignore_public_acls' is null then 'ignore_public_acls' end,
            case when attributes_std -> 'restrict_public_buckets' is null then 'restrict_public_buckets' end
          ) || ' not defined'
        when
          (attributes_std ->> 'block_public_acls')::boolean
          and (attributes_std ->> 'block_public_policy')::boolean
          and (attributes_std ->> 'ignore_public_acls')::boolean
          and (attributes_std ->> 'restrict_public_buckets')::boolean
        then 'Public access blocks enabled'
        else 'Public access not enabled for: ' ||
          concat_ws(', ',
        case when not ((attributes_std ->> 'block_public_acls')::boolean) then 'block_public_acls' end,
        case when not ((attributes_std ->> 'block_public_policy')::boolean) then 'block_public_policy' end,
        case when not ((attributes_std ->> 'ignore_public_acls')::boolean ) then 'ignore_public_acls' end,
        case when not ((attributes_std ->> 'restrict_public_buckets')::boolean) then 'restrict_public_buckets' end
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
      address as resource,
      case
        when coalesce(trim(lower(attributes_std -> 'versioning' ->> 'enabled')), '') in ('true', 'false') and (attributes_std -> 'versioning' -> 'enabled')::bool
        then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when coalesce(trim(lower(attributes_std -> 'versioning' ->> 'enabled')), '') not in ('true', 'false') then ' versioning disabled'
        when (attributes_std -> 'versioning' ->> 'enabled')::bool then ' versioning enabled'
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
      address as resource,
      case
        when
          (attributes_std ->> 'block_public_acls')::boolean
          and (attributes_std ->> 'block_public_policy')::boolean
          and (attributes_std ->> 'ignore_public_acls')::boolean
          and (attributes_std ->> 'restrict_public_buckets')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      case
        when
          attributes_std -> 'block_public_acls' is null
          or attributes_std -> 'block_public_policy' is null
          or attributes_std -> 'ignore_public_acls' is null
          or attributes_std -> 'restrict_public_buckets' is null
        then concat_ws(', ',
            case when attributes_std -> 'block_public_acls' is null then 'block_public_acls' end,
            case when attributes_std -> 'block_public_policy' is null then 'block_public_policy' end,
            case when attributes_std -> 'ignore_public_acls' is null then 'ignore_public_acls' end,
            case when attributes_std -> 'restrict_public_buckets' is null then 'restrict_public_buckets' end
          ) || ' not defined'
        when
          (attributes_std ->> 'block_public_acls')::boolean
          and (attributes_std ->> 'block_public_policy')::boolean
          and (attributes_std ->> 'ignore_public_acls')::boolean
          and (attributes_std ->> 'restrict_public_buckets')::boolean
        then 'Account level public access blocks enabled'
        else 'Account level public access not enabled for: ' ||
          concat_ws(', ',
            case when not ((attributes_std ->> 'block_public_acls')::boolean) then 'block_public_acls' end,
            case when not ((attributes_std ->> 'block_public_policy')::boolean) then 'block_public_policy' end,
            case when not ((attributes_std ->> 'ignore_public_acls')::boolean ) then 'ignore_public_acls' end,
            case when not ((attributes_std ->> 'restrict_public_buckets')::boolean) then 'restrict_public_buckets' end
          )
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_account_public_access_block';
  EOQ
}

query "s3_bucket_block_public_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'block_public_policy')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'block_public_policy') is null then ' block_public_acls not defined'
        when (attributes_std ->> 'block_public_policy')::boolean then ' block_public_policy enabled'
        else ' block_public_policy disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket_public_access_block';
  EOQ
}

query "s3_bucket_object_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when attributes_std -> 'kms_key_id' is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when attributes_std -> 'kms_key_id' is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket_object';
  EOQ
}

query "s3_bucket_ignore_public_acls_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'ignore_public_acls')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ignore_public_acls') is null then ' ignore_public_acls not defined'
        when (attributes_std ->> 'ignore_public_acls')::boolean then ' ignore_public_acls enabled'
        else ' ignore_public_acls disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_bucket_public_access_block';
  EOQ
}

query "s3_bucket_object_copy_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when attributes_std -> 'kms_key_id' is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when attributes_std -> 'kms_key_id' is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_s3_object_copy';
  EOQ
}

query "s3_bucket_abort_incomplete_multipart_upload_enabled" {
  sql = <<-EOQ
    with lifecycle_configuration_with_abort_incomplete_multipart_upload as (
      select
        concat(address) as name
      from
        terraform_resource,
        jsonb_array_elements(attributes_std -> 'rule') as r
      where
        r ->> 'id' = 'AbortIncompleteMultipartUploadRule'
        and r ->> 'status' = 'Enabled'
        and type = 'aws_s3_bucket_lifecycle_configuration'
    )
    select
      r.address as resource,
      case
        when u.name is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when u.name is not null then ' has abort incomplete multipart upload enabled'
        else ' has abort incomplete multipart upload disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join lifecycle_configuration_with_abort_incomplete_multipart_upload as u on u.name = r.address
    where
      r.type = 'aws_s3_bucket_lifecycle_configuration';
  EOQ
}
