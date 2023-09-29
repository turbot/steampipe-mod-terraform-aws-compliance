query "ssm_document_prohibit_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'permissions' ->> 'account_ids') = 'All' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'permissions' ->> 'account_ids') = 'All' then ' is publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ssm_document';
  EOQ
}

query "ssm_parameter_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when attributes_std -> 'key_id' is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when attributes_std -> 'key_id' is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ssm_parameter';
  EOQ
}
