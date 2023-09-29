query "codeartifact_domain_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encryption_key') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std ->> 'encryption_key') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codeartifact_domain';    
  EOQ
}