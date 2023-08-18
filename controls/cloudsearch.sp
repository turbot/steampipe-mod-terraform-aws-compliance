locals {
  cloudsearch_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudSearch"
  })
}

benchmark "cloudsearch" {
  title       = "CloudSearch"
  description = "This benchmark provides a set of controls that detect Terraform AWS CloudSearch resources deviating from security best practices."

  children = [
    control.cloudsearch_domain_enforced_https_enabled,
    control.cloudsearch_domain_uses_latest_tls_version
  ]

  tags = merge(local.cloudsearch_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudsearch_domain_enforced_https_enabled" {
  title       = "CloudSearch should have enforced HTTPS enabled"
  description = "This control checks whether the CloudSearch has enforced HTTPS enabled."
  query       = query.cloudsearch_domain_enforced_https_enabled

  tags = local.cloudsearch_compliance_common_tags
}

control "cloudsearch_domain_uses_latest_tls_version" {
  title       = "CloudSearch should use the latest TLS version"
  description = "This control checks whether the CloudSearch uses the latest TLS version."
  query       = query.cloudsearch_domain_uses_latest_tls_version

  tags = local.cloudsearch_compliance_common_tags
}
