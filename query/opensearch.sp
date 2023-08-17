
query "opensearch_domain_use_default_security_group" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'vpc_options' ->> 'security_group_ids') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'vpc_options' ->> 'security_group_ids') is not null then ' default security group not set'
        else ' default security group set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_opensearch_domain';
  EOQ
}

query "opensearch_domain_enforce_https" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'domain_endpoint_options' ->> 'enforce_https')::boolean is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'domain_endpoint_options' ->> 'enforce_https')::boolean then ' enforces HTTPS'
        else ' does not enforces HTTPS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_opensearch_domain';
  EOQ
}

query "opensearch_domain_encrpted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypt_at_rest' ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encrypt_at_rest' ->> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_opensearch_domain';
  EOQ
}
