locals {
  cloudformation_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudFormation"
  })
}

benchmark "cloudformation" {
  title       = "CloudFormation"
  description = "This benchmark provides a set of controls that detect Terraform AWS CloudFormation resources deviating from security best practices."

  children = [
    control.acm_certificate_create_before_destroy_enabled,
    control.cloudsearch_domain_uses_latest_tls_version
  ]

  tags = merge(local.cloudformation_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudformation_stack_notifications_enabled" {
  title       = "CloudFormation stacks should have notifications enabled"
  description = "This control checks whether CloudFormation stacks are associated with an SNS topic to receive notifications when an event occurs."
  query       = query.cloudformation_stack_notifications_enabled

  tags = merge(local.cloudformation_compliance_common_tags, {
    nist_csf     = "true"
    other_checks = "true"
  })
}