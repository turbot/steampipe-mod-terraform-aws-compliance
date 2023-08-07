locals {
  acm_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ACM"
  })
}

benchmark "acm" {
  title       = "ACM"
  description = "This benchmark provides a set of controls that detect Terraform AWS ACM resources deviating from security best practices."

  children = [
    control.acm_certificate_create_before_destroy_enabled,
    control.acm_certificate_transparency_logging_enabled
  ]

  tags = merge(local.acm_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "acm_certificate_create_before_destroy_enabled" {
  title       = "ACM certificate should have create before destroy enabled"
  description = "This control checks whether ACM certificate has create before destroy enabled. It is recommended to enable the resource lifecycle configuration block create_before_destroy argument in this resource configuration to manage all requests that use this certificate, avoiding an outage."
  query       = query.acm_certificate_create_before_destroy_enabled
  tags        = local.acm_compliance_common_tags
}

control "acm_certificate_transparency_logging_enabled" {
  title       = "ACM certificates should have transparency logging preference enabled"
  description = "Ensure ACM certificates transparency logging preference is enabled as certificate transparency logging guards against SSL/TLS certificates issued by mistake or by a compromised certificate authority."
  query       = query.acm_certificate_transparency_logging_enabled

  tags = merge(local.acm_compliance_common_tags, {
    other_checks = "true"
  })
}