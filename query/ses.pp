query "ses_configuration_set_tls_enforced" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'delivery_options' ->> 'tls_policy') = 'Require' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'delivery_options' ->> 'tls_policy')= 'Require' then ' TLS enforced'
        else ' TLS not enforced'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ses_configuration_set';
  EOQ
}