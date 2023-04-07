locals {
  es_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Elasticsearch"
  })
}

benchmark "es" {
  title       = "Elasticsearch"
  description = "This benchmark provides a set of controls that detect Terraform AWS Elasticsearch resources deviating from security best practices."

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

  tags = merge(local.es_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "es_domain_audit_logging_enabled" {
  title       = "Elasticsearch domains should have audit logging enabled"
  description = "This control checks whether Elasticsearch domains have audit logging enabled. This control fails if an Elasticsearch domain does not have audit logging enabled."
  query       = query.es_domain_audit_logging_enabled

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "es_domain_data_nodes_min_3" {
  title       = "Elasticsearch domains should have at least three data nodes"
  description = "This control checks whether Elasticsearch domains are configured with at least three data nodes and zoneAwarenessEnabled is set to true."
  query       = query.es_domain_data_nodes_min_3

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "es_domain_dedicated_master_nodes_min_3" {
  title       = "Elasticsearch domains should be configured with at least three dedicated master nodes"
  description = "This control checks whether Elasticsearch domains are configured with at least three dedicated master nodes. This control fails if the domain does not use dedicated master nodes. This control passes if Elasticsearch domains have five dedicated master nodes. However, using more than three master nodes might be unnecessary to mitigate the availability risk, and will result in additional cost."
  query       = query.es_domain_dedicated_master_nodes_min_3

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "es_domain_encrypted_using_tls_1_2" {
  title       = "Connections to Elasticsearch domains should be encrypted using TLS 1.2"
  description = "This control checks whether connections to Elasticsearch domains are required to use TLS 1.2. The check fails if the Elasticsearch domain TLSSecurityPolicy is not Policy-Min-TLS-1-2-2019-07."
  query       = query.es_domain_encrypted_using_tls_1_2

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "es_domain_encryption_at_rest_enabled" {
  title       = "ES domain encryption at rest should be enabled"
  description = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elasticsearch Service (Amazon ES) domains."
  query       = query.es_domain_encryption_at_rest_enabled
  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "es_domain_error_logging_enabled" {
  title       = "Elasticsearch domain error logging to CloudWatch Logs should be enabled"
  description = "This control checks whether Elasticsearch domains are configured to send error logs to CloudWatch Logs."
  query       = query.es_domain_error_logging_enabled

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "es_domain_in_vpc" {
  title       = "Amazon Elasticsearch Service domains should be in a VPC"
  description = "This control checks whether Amazon Elasticsearch Service domains are in a VPC. It does not evaluate the VPC subnet routing configuration to determine public access. You should ensure that Amazon Elasticsearch domains are not attached to public subnets."
  query       = query.es_domain_in_vpc

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "es_domain_logs_to_cloudwatch" {
  title       = "Elasticsearch domain should send logs to cloudWatch"
  description = "Ensure if Amazon OpenSearch Service (OpenSearch Service) domains are configured to send logs to Amazon CloudWatch Logs. The rule is complaint if a log is enabled for an OpenSearch Service domain. This rule is non complain if logging is not configured."
  query       = query.es_domain_logs_to_cloudwatch

  tags = merge(local.es_compliance_common_tags, {
    rbi_cyber_security = "true"
  })
}

control "es_domain_node_to_node_encryption_enabled" {
  title       = "Elasticsearch domain node-to-node encryption should be enabled"
  description = "Ensure node-to-node encryption for Amazon Elasticsearch Service is enabled. Node-to-node encryption enables TLS 1.2 encryption for all communications within the Amazon Virtual Private Cloud (Amazon VPC)."
  query       = query.es_domain_node_to_node_encryption_enabled

  tags = merge(local.es_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_csf                  = "true"
    nist_800_53_rev_4         = "true"
    rbi_cyber_security        = "true"
  })
}
