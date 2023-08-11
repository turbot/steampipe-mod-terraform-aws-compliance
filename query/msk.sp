query "msk_cluster_nodes_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'broker_node_group_info' -> 'connectivity_info' -> 'public_access' ->> 'type') = 'SERVICE_PROVIDED_EIPS' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'broker_node_group_info' -> 'connectivity_info' -> 'public_access' ->> 'type') = 'SERVICE_PROVIDED_EIPS' then ' cluster nodes are public'
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
      type || ' ' || name as resource,
      case
        when ((arguments -> 'logging_info' -> 'broker_logs' -> 'cloudwatch_logs' ->> 'enabled')::bool or (arguments -> 'logging_info' -> 'broker_logs' -> 'firehose' ->> 'enabled')::bool or (arguments -> 'logging_info' -> 'broker_logs' -> 's3' ->> 'enabled')::bool) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments -> 'logging_info' -> 'broker_logs' -> 'cloudwatch_logs' ->> 'enabled')::bool or (arguments -> 'logging_info' -> 'broker_logs' -> 'firehose' ->> 'enabled')::bool or (arguments -> 'logging_info' -> 'broker_logs' -> 's3' ->> 'enabled')::bool) then ' logging enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_info') is null then 'alarm'
        when ((arguments -> 'encryption_info' ->> 'client_broker') = 'TLS' and (arguments -> 'encryption_info' ->> 'in_cluster')::bool) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encryption_info') is null then 'alarm' then ' not encrypted'
        when ((arguments -> 'encryption_info' ->> 'client_broker') = 'TLS' and (arguments -> 'encryption_info' ->> 'in_cluster')::bool) then ' encryption in transit enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_at_rest_kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'encryption_at_rest_kms_key_arn') then ' not encrypted with KMS CMK'
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