locals {
  cloudsearch_domain_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudSearchDomain"
  })
}

benchmark "cloudsearch_domain" {
  title       = "CloudSearchDomain"
  description = "This benchmark provides a set of controls that detect Terraform AWS CloudSearchDomain resources deviating from security best practices."

  children = [
    control.cloudsearch_domain_enforced_https_enabled,
    control.cloudsearch_domain_uses_latest_tls_version
  ]

  tags = merge(local.cloudsearch_domain_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudsearch_domain_enforced_https_enabled" {
  title       = "CloudSearchDomain should have enforced HTTPS enabled"
  description = "This control checks whether the CloudSearchDomain has enforced HTTPS enabled."
  query       = query.cloudsearch_domain_enforced_https_enabled

  tags = local.cloudsearch_domain_compliance_common_tags
}

control "cloudsearch_domain_uses_latest_tls_version" {
  title       = "CloudSearchDomain should use the latest TLS version"
  description = "This control checks whether the CloudSearchDomain uses the latest TLS version."
  query       = query.cloudsearch_domain_uses_latest_tls_version

  tags = local.cloudsearch_domain_compliance_common_tags
}
