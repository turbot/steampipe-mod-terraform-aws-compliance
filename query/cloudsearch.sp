query "cloudsearch_domain_enforced_https_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'endpoint_options' ->> 'enforce_https')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'endpoint_options' ->> 'enforce_https')::boolean then ' enforce https enabled'
        else ' enforce https disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudsearch_domain';    
  EOQ
}

query "cloudsearch_domain_uses_latest_tls_version" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'endpoint_options' ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'endpoint_options' ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then ' uses latest TLS version'
        else ' uses old TLS version'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudsearch_domain';    
  EOQ
}