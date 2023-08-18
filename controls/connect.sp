locals {
  connect_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Connect"
  })
}

benchmark "eventbridge" {
  title       = "Connect"
  description = "This benchmark provides a set of controls that detect Terraform AWS Connect resources deviating from security best practices."

  children = [
    control.connect_instance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk,
    control.connect_instance_s3_storage_config_encrypted_with_kms_cmk
  ]

  tags = merge(local.connect_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "connect_instance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk" {
  title       = "Connect instance kinesis video stream storage config is encrypted with KMS CMK"
  description = "This control checks whether Connect instance Kinesis video stream storage config is encrypted with KMS CMK."
  query       = query.connect_instance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk

  tags = local.connect_compliance_common_tags
}

control "connect_instance_s3_storage_config_encrypted_with_kms_cmk" {
  title       = "Connect instance S3 storage config is encrypted with KMS CMK"
  description = "This control checks whether Connect instance S3 storage config is encrypted with KMS CMK."
  query       = query.connect_instance_s3_storage_config_encrypted_with_kms_cmk

  tags = local.connect_compliance_common_tags
}
