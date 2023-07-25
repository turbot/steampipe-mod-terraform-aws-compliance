locals {
  timestream_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Timestream"
  })
}

benchmark "timestream" {
  title       = "Timestream"
  description = "This benchmark provides a set of controls that detect Terraform AWS Timestream resources deviating from security best practices."

  children = [
    control.timestream_database_encrypted_with_kms_cmk,
  ]

  tags = merge(local.timestream_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "timestream_database_encrypted_with_kms_cmk" {
  title       = "SSM documents should not be public"
  description = "To help protect data at rest, ensure encryption with AWS Key Management Service (AWS KMS) is enabled for your SageMaker endpoint."
  query       = query.timestream_database_encrypted_with_kms_cmk

  tags = local.timestream_compliance_common_tags
}