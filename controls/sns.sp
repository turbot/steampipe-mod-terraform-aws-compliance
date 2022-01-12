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
