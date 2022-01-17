locals {
  sns_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sns"
  })
}

benchmark "sns" {
  title    = "SNS"
  children = [
    control.sns_topic_encrypted_at_rest
  ]
  tags          = local.sns_compliance_common_tags
}

control "sns_topic_encrypted_at_rest" {
  title       = "SNS topics should be encrypted at rest"
  description = "To help protect data at rest, ensure that your Amazon Simple Notification Service (Amazon SNS) topics require encryption using AWS Key Management Service (AWS KMS)."
  sql           = query.sns_topic_encrypted_at_rest.sql

  tags = local.sns_compliance_common_tags
}