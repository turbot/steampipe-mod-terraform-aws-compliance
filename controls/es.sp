locals {
  es_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "es"
  })
}

benchmark "es" {
  title    = "Elasticsearch"
  children = [
    control.es_domain_audit_logging_enabled,
    control.es_domain_data_nodes_min_3,
    control.es_domain_dedicated_master_nodes_min_3,
    control.es_domain_encrypted_using_tls_1_2,
    control.es_domain_encryption_at_rest_enabled,
    control.es_domain_error_logging_enabled,
    control.es_domain_in_vpc,
    control.es_domain_logs_to_cloudwatch,
    control.es_domain_node_to_node_encryption_enabled
  ]
  tags          = local.es_compliance_common_tags
}
