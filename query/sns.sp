query "sns_topic_encrypted_at_rest" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments ->> 'kms_master_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_master_key_id') is null then ' ''kms_master_key_id'' is not defined'
        when coalesce(trim(arguments ->> 'kms_master_key_id'), '') <> '' then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sns_topic';
  EOQ
}
