query "es_domain_audit_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
        and (attributes_std -> 'log_publishing_options' ->> 'log_type')::text = 'AUDIT_LOGS')
        or
        ((attributes_std -> 'log_publishing_options') @> '[{"log_type": "AUDIT_LOGS"}]') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null and (attributes_std -> 'log_publishing_options' ->> 'log_type')::text = 'AUDIT_LOGS')
        or
        ((attributes_std -> 'log_publishing_options') @> '[{"log_type": "AUDIT_LOGS"}]') then ' audit logging enabled'
        else ' audit logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_data_nodes_min_3" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cluster_config' -> 'zone_awareness_enabled')::bool = false then 'alarm'
        when (attributes_std -> 'cluster_config' -> 'zone_awareness_enabled')::bool and (attributes_std -> 'cluster_config' ->> 'instance_count')::int >= 3 then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cluster_config' -> 'zone_awareness_enabled')::bool = false then ' zone awareness disabled'
        else ' has ' || (attributes_std -> 'cluster_config' ->> 'instance_count') || ' data node(s)'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_dedicated_master_nodes_min_3" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'cluster_config' -> 'dedicated_master_enabled')::bool = false then 'alarm'
        when (attributes_std -> 'cluster_config' -> 'dedicated_master_enabled')::bool and (attributes_std -> 'cluster_config' ->> 'instance_count')::int >= 3 then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'cluster_config' -> 'dedicated_master_enabled')::bool = false then ' dedicated master nodes disabled'
        else ' has ' || (attributes_std -> 'cluster_config' ->> 'instance_count') || ' data node(s)'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_encrypted_using_tls_1_2" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'domain_endpoint_options' ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'domain_endpoint_options' ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then ' encrypted using TLS 1.2'
        else ' not encrypted using TLS 1.2'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypt_at_rest' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encrypt_at_rest' ->> 'enabled')::boolean then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_error_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when ((attributes_std -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
        and (attributes_std -> 'log_publishing_options' ->> 'log_type')::text = 'ES_APPLICATION_LOGS') or
        (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when ((attributes_std -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
        and (attributes_std -> 'log_publishing_options' ->> 'log_type')::text = 'ES_APPLICATION_LOGS') or (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then ' error logging enabled'
        else ' error logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_in_vpc" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'vpc_options' -> 'subnet_ids') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'vpc_options' -> 'subnet_ids') is not null then ' in VPC'
        else ' not in VPC'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_logs_to_cloudwatch" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
        (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
        (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
        (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
        (attributes_std -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then ' logging enabled for search , index and error'
        else ' logging not enabled for all search, index and error'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';

  EOQ
}

query "es_domain_node_to_node_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'node_to_node_encryption' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'node_to_node_encryption' ->> 'enabled')::boolean then ' node-to-node encryption enabled'
        else ' node-to-node encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_use_default_security_group" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'vpc_options' ->> 'security_group_ids') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'vpc_options' ->> 'security_group_ids') is not null then ' default security group not set'
        else ' default security group set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_enforce_https" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'domain_endpoint_options' ->> 'enforce_https')::boolean or (attributes_std -> 'domain_endpoint_options') is null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'domain_endpoint_options' ->> 'enforce_https')::boolean or (attributes_std -> 'domain_endpoint_options') is null then ' enforces HTTPS'
        else ' does not enforces HTTPS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}

query "es_domain_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypt_at_rest' -> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encrypt_at_rest' -> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticsearch_domain';
  EOQ
}
