locals {
  kendra_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Kendra"
  })
}

benchmark "kendra" {
  title       = "Kendra"
  description = "This benchmark provides a set of controls that detect Terraform AWS Kendra resources deviating from security best practices."

  children = [
    control.kendra_index_server_side_encryption_uses_kms_cmk
  ]

  tags = merge(local.kendra_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kendra_index_server_side_encryption_uses_kms_cmk" {
  title       = "Kendra indexes should use KMS CMKs for server-side encryption"
  description = "This control checks whether Kendra indexes are using KMS CMKs for server-side encryption."
  query       = query.kendra_index_server_side_encryption_uses_kms_cmk

  tags = local.kendra_compliance_common_tags
}