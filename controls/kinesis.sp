locals {
  kinesis_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "kinesis"
  })
}

benchmark "kinesis" {
  title       = "Kinesis"
  description = "This benchmark provides a set of controls that detect Terraform AWS Kinesis resources deviating from security best practices."

  children = [
    control.kinesis_stream_encryption_at_rest_enabled
  ]

  tags = local.kinesis_compliance_common_tags
}

control "kinesis_stream_encryption_at_rest_enabled" {
  title         = "Kinesis stream encryption at rest should be enabled"
  description   = "Ensure Kinesis streams are set to be encrypted at rest to protect sensitive data."
  sql           = query.kinesis_stream_encryption_at_rest_enabled.sql

  tags = local.kinesis_compliance_common_tags
}