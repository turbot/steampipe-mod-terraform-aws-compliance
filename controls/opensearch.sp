locals {
  opensearch_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/OpenSearch"
  })
}

benchmark "opensearch" {
  title       = "OpenSearch"
  description = "This benchmark provides a set of controls that detect Terraform AWS OpenSearch resources deviating from security best practices."

  children = [
    control.opensearch_domain_encrpted_with_kms_cmk,
    control.opensearch_domain_enforce_https,
    control.opensearch_domain_use_default_security_group
  ]

  tags = merge(local.opensearch_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "opensearch_domain_use_default_security_group" {
  title       = "OpenSearch domain should not use the default security group"
  description = "This control checks whether OpenSearch domains are configured to use the default security group. This control fails if the OpenSearch domain uses the default security group."
  query       = query.opensearch_domain_use_default_security_group

  tags = local.opensearch_compliance_common_tags
}

control "opensearch_domain_enforce_https" {
  title       = "OpenSearch domain should enforce HTTPS"
  description = "This control checks whether OpenSearch domains are configured to enforce HTTPS. This control fails if the OpenSearch domain does not enforce HTTPS."
  query       = query.opensearch_domain_enforce_https

  tags = local.es_compliance_common_tags
}

control "opensearch_domain_encrpted_with_kms_cmk" {
  title       = "OpenSearch domain should be encrypted with KMS CMK"
  description = "This control checks whether OpenSearch domains are configured to use a KMS CMK for encryption at rest. This control fails if the OpenSearch domain does not use a KMS CMK for encryption at rest."
  query       = query.opensearch_domain_encrpted_with_kms_cmk

  tags = local.es_compliance_common_tags
}
