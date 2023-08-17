locals {
  connectinstance_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ConnectInstance"
  })
}

benchmark "eventbridge" {
  title       = "Connect Instance"
  description = "This benchmark provides a set of controls that detect Terraform AWS Connect Instance resources deviating from security best practices."

  children = [
    control.connectinstance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk,
    control.connectinstance_s3_storage_config_encrypted_with_kms_cmk
  ]

  tags = merge(local.connectinstance_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "connectinstance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk" {
  title       = "Connect instance kinesis video stream storage config is encrypted with KMS CMK"
  description = "This control checks whether Connect instance Kinesis video stream storage config is encrypted with KMS CMK."
  query       = query.connectinstance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk

  tags = local.connectinstance_compliance_common_tags
}

control "connectinstance_s3_storage_config_encrypted_with_kms_cmk" {
  title       = "Connect instance S3 storage config is encrypted with KMS CMK"
  description = "This control checks whether Connect instance S3 storage config is encrypted with KMS CMK."
  query       = query.connectinstance_s3_storage_config_encrypted_with_kms_cmk

  tags = local.connectinstance_compliance_common_tags
}