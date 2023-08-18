query "dlm_lifecycle_policy_events_cross_region_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean  then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean then ' events cross-region encryption enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean and (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encrypted')::boolean and (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then ' events cross-region encrypted with KMS CMK'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then 'skip'
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean  then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then ' schedule cross-region not configured'
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean then ' schedule cross-region encryption enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then 'skip'
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean and (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'cmk_arn') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule') is null then ' schedule cross-region not configured'
        when (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'encrypted')::boolean and (arguments -> 'policy_details' -> 'schedule' -> 'cross_region_copy_rule' ->> 'cmk_arn') is not null then ' schedule cross-region encrypted with KMS CMK'
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
