locals {
  kinesis_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Kinesis"
  })
}

benchmark "kinesis" {
  title       = "Kinesis"
  description = "This benchmark provides a set of controls that detect Terraform AWS Kinesis resources deviating from security best practices."

  children = [
    control.kinesis_stream_encryption_at_rest_enabled
  ]

  tags = merge(local.kinesis_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kinesis_stream_encryption_at_rest_enabled" {
  title       = "Kinesis stream encryption at rest should be enabled"
  description = "Ensure Kinesis streams are set to be encrypted at rest to protect sensitive data."
  query       = query.kinesis_stream_encryption_at_rest_enabled

  tags = local.kinesis_compliance_common_tags
}
