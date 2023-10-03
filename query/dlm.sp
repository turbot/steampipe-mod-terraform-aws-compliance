query "dlm_lifecycle_policy_events_cross_region_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean then ' events cross-region encryption enabled'
        else ' events cross-region encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}

query "dlm_lifecycle_policy_events_cross_region_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean and (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean and (attributes_std -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then ' events cross-region encrypted with KMS CMK'
        else ' events cross-region not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}

query "dlm_schedule_cross_region_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then 'skip'
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then ' schedule cross-region not configured'
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean then ' schedule cross-region encryption enabled'
        else ' schedule cross-region encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}

query "dlm_schedule_cross_region_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then 'skip'
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean and (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'cmk_arn') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then ' schedule cross-region not configured'
        when (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean and (attributes_std -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'cmk_arn') is not null then ' schedule cross-region encrypted with KMS CMK'
        else ' schedule cross-region not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}
