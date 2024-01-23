locals {
  ses_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/SES"
  })
}

benchmark "ses" {
  title       = "Simple Email Service"
  description = "This benchmark provides a set of controls that detect Terraform AWS Simple Email Service resources deviating from security best practices."

  children = [
    control.ses_configuration_set_tls_enforced
  ]

  tags = merge(local.ses_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ses_configuration_set_tls_enforced" {
  title       = "SES configuration set should enforce TLS usage"
  description = "This control ensures that TLS is enforced for SES configuration set. Enforcing TLS usage in SES configuration set is essential in securing email communications, ensuring data privacy, and maintaining compliance with various data protection standards."
  query       = query.ses_configuration_set_tls_enforced

  tags = local.ses_compliance_common_tags
}
