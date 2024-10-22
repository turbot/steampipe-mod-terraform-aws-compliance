locals {
  keyspaces_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Keyspaces"
  })
}

benchmark "keyspaces" {
  title       = "Keyspaces"
  description = "This benchmark provides a set of controls that detect Terraform AWS Keyspaces resources deviating from security best practices."

  children = [
    control.keyspaces_table_encrypted_with_kms_cmk
  ]

  tags = merge(local.keyspaces_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "keyspaces_table_encrypted_with_kms_cmk" {
  title       = "Keyspaces tables should be encrypted with KMS CMK"
  description = "This control checks whether Keyspaces tables are encrypted with KMS CMK."
  query       = query.keyspaces_table_encrypted_with_kms_cmk

  tags = local.keyspaces_compliance_common_tags
}
