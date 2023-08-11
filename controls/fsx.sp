locals {
  fsx_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/FSX"
  })
}

benchmark "fsx" {
  title       = "FSX"
  description = "This benchmark provides a set of controls that detect Terraform AWS FSX resources deviating from security best practices."

  children = [
    control.fsx_ontap_file_system_encrypted_with_kms_cmk
  ]

  tags = merge(local.fsx_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "fsx_ontap_file_system_encrypted_with_kms_cmk" {
  title       = "FSX ONTAP File System Encrypted with KMS CMK"
  description = "This control checks whether FSX ontap file system is encrypted with KMS CMK."
  query       = query.fsx_ontap_file_system_encrypted_with_kms_cmk

  tags = local.fsx_compliance_common_tags
}