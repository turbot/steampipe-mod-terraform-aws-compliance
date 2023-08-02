locals {
  kinesis_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Kinesis"
  })
}

benchmark "kinesis" {
  title       = "Kinesis"
  description = "This benchmark provides a set of controls that detect Terraform AWS Kinesis resources deviating from security best practices."

  children = [
    control.kinesis_firehose_delivery_stream_encrypted_with_kms_cmk,
    control.kinesis_firehose_delivery_stream_server_side_encryption_enabled,
    control.kinesis_stream_encrypted_with_kms_cmk,
    control.kinesis_stream_encryption_at_rest_enabled,
    control.kinesis_video_stream_encrypted_with_kms_cmk
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

control "kinesis_firehose_delivery_stream_server_side_encryption_enabled" {
  title       = "Kinesis firehose delivery streams should have server side encryption enabled"
  description = "Enable server-side-encryption (SSE) of your AWS Kinesis Server data at rest, in order to protect your data and metadata from breaches or unauthorized access, and fulfill compliance requirements for data-at-rest encryption within your organization."
  query       = query.kinesis_firehose_delivery_stream_server_side_encryption_enabled

  tags = local.kinesis_compliance_common_tags
}

control "kinesis_firehose_delivery_stream_encrypted_with_kms_cmk" {
  title       = "Kinesis firehose delivery streams should be encrypted with KMS CMK"
  description = "Ensure that Kinesis Firehose Delivery Streams are encrypted with KMS CMK."
  query       = query.kinesis_firehose_delivery_stream_encrypted_with_kms_cmk

  tags = local.kinesis_compliance_common_tags
}

control "kinesis_stream_encrypted_with_kms_cmk" {
  title       = "Kinesis streams should be encrypted with KMS CMK"
  description = "Ensure that Kinesis streams are encrypted with KMS CMK."
  query       = query.kinesis_stream_encrypted_with_kms_cmk

  tags = local.kinesis_compliance_common_tags
}

control "kinesis_video_stream_encrypted_with_kms_cmk" {
  title       = "Kinesis vidoe streams should be encrypted with KMS CMK"
  description = "Ensure that Kinesis video streams are encrypted with KMS CMK."
  query       = query.kinesis_video_stream_encrypted_with_kms_cmk

  tags = local.kinesis_compliance_common_tags
}
