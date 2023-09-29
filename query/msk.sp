query "msk_cluster_nodes_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'broker_node_group_info' -> 'connectivity_info' -> 'public_access' ->> 'type') = 'SERVICE_PROVIDED_EIPS' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'broker_node_group_info' -> 'connectivity_info' -> 'public_access' ->> 'type') = 'SERVICE_PROVIDED_EIPS' then ' cluster nodes are public'
        else ' cluster nodes are private'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_msk_cluster';
  EOQ
}

query "msk_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'logging_info' -> 'broker_logs' -> 'cloudwatch_logs' ->> 'enabled')::bool or (attributes_std -> 'logging_info' -> 'broker_logs' -> 'firehose' ->> 'enabled')::bool or (attributes_std -> 'logging_info' -> 'broker_logs' -> 's3' ->> 'enabled')::bool) then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'logging_info' -> 'broker_logs' -> 'cloudwatch_logs' ->> 'enabled')::bool or (attributes_std -> 'logging_info' -> 'broker_logs' -> 'firehose' ->> 'enabled')::bool or (attributes_std -> 'logging_info' -> 'broker_logs' -> 's3' ->> 'enabled')::bool) then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_msk_cluster';
  EOQ
}

query "msk_cluster_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encryption_info') is null then 'alarm'
        when ((attributes_std -> 'encryption_info' ->> 'client_broker') = 'TLS' and (attributes_std -> 'encryption_info' ->> 'in_cluster')::bool) then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_info') is null then ' not encrypted'
        when ((attributes_std -> 'encryption_info' ->> 'client_broker') = 'TLS' and (attributes_std -> 'encryption_info' ->> 'in_cluster')::bool) then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_msk_cluster';
  EOQ
}

query "msk_cluster_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encryption_at_rest_kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_at_rest_kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_msk_cluster';
  EOQ
}