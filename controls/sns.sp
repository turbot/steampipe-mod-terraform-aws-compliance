locals {
  sns_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sns"
  })
}

benchmark "sns" {
  title       = "SNS"
  description = "This benchmark provides a set of controls that detect Terraform AWS SNS resources deviating from security best practices."

  children = [
    control.sns_topic_encrypted_at_rest
  ]

  tags = local.sns_compliance_common_tags
}

control "sns_topic_encrypted_at_rest" {
  title       = "SNS topics should be encrypted at rest"
  description = "To help protect data at rest, ensure that your Amazon Simple Notification Service (Amazon SNS) topics require encryption using AWS Key Management Service (AWS KMS)."
  sql           = query.sns_topic_encrypted_at_rest.sql

  tags = merge(local.sns_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
  })
}