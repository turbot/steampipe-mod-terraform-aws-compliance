query "dlm_lifecycle_policy_events_cross_region_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encryption')::boolean  then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encryption')::boolean then ' events cross region encryption enabled'
        else ' events cross region encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}

query "dlm_lifecycle_policy_events_cross_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encryption')::boolean and (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'encryption')::boolean and (arguments -> 'policy_details' -> 'action' -> 'cross_region_copy' -> 'encryption_configuration' ->> 'cmk_arn') is not null then ' events cross region encrypted with kms cmk'
        else ' events cross region not encrypted with kms cmk'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dlm_lifecycle_policy';
  EOQ
}