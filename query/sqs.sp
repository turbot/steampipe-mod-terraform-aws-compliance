query "sqs_queue_encrypted_at_rest" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_master_key_id') is null then 'alarm'
        when coalesce(trim(attributes_std ->> 'kms_master_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_master_key_id') is null then ' ''kms_master_key_id'' is not defined'
        when coalesce(trim(attributes_std ->> 'kms_master_key_id'), '') <> '' then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sqs_queue';
  EOQ
}

query "sqs_vpc_endpoint_without_dns_resolution" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled') is null then 'alarm'
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled')::bool then 'ok'
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled')::bool = false then 'alarm'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled') is null then ' private DNS disabled'
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled')::bool then ' private DNS enabled'
        when (attributes_std ->> 'service_name') like '%sqs%' and (attributes_std -> 'private_dns_enabled')::bool = false then ' private DNS disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_vpc_endpoint';
  EOQ
}

query "sqs_queue_policy_no_action_star" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std ->> 'policy')::jsonb ) -> 'Statement' @> '[{"Action": "*"}]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when ((attributes_std ->> 'policy')::jsonb ) -> 'Statement' @> '[{"Action": "*"}]' then ' policy allow wildcard action'
        else ' policy is ok'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sqs_queue_policy';
  EOQ
}

query "sqs_queue_policy_no_principal_star" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std ->> 'policy')::jsonb ) -> 'Statement' @> '[{"Principal": "*"}]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when ((attributes_std ->> 'policy')::jsonb ) -> 'Statement' @> '[{"Principal": "*"}]' then ' policy allow all principal'
        else ' policy is ok'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sqs_queue_policy';
  EOQ
}