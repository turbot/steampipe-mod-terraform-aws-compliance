locals {
  fsx_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/FSx"
  })
}

benchmark "fsx" {
  title       = "FSx"
  description = "This benchmark provides a set of controls that detect Terraform AWS FSx resources deviating from security best practices."

  children = [
    control.fsx_lustre_file_system_encrypted_with_kms_cmk,
    control.fsx_ontap_file_system_encrypted_with_kms_cmk,
    control.fsx_openzfs_file_system_encrypted_with_kms_cmk,
    control.fsx_windows_file_system_encrypted_with_kms_cmk
  ]

  tags = merge(local.fsx_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "fsx_ontap_file_system_encrypted_with_kms_cmk" {
  title       = "FSx ONTAP File System should be encrypted with KMS CMK"
  description = "This control checks whether FSx ontap file system is encrypted with KMS CMK."
  query       = query.fsx_ontap_file_system_encrypted_with_kms_cmk

  tags = local.fsx_compliance_common_tags
}

control "fsx_openzfs_file_system_encrypted_with_kms_cmk" {
  title       = "FSx OpenZFS File System should be encrypted with KMS CMK"
  description = "This control checks whether FSx openzfs file system is encrypted with KMS CMK."
  query       = query.fsx_openzfs_file_system_encrypted_with_kms_cmk

  tags = local.fsx_compliance_common_tags
}

control "fsx_windows_file_system_encrypted_with_kms_cmk" {
  title       = "FSx Windows File System should be encrypted with KMS CMK"
  description = "This control checks whether FSx windows file system is encrypted with KMS CMK."
  query       = query.fsx_windows_file_system_encrypted_with_kms_cmk

  tags = local.fsx_compliance_common_tags
}

control "fsx_lustre_file_system_encrypted_with_kms_cmk" {
  title       = "FSx Lustre File System should be encrypted with KMS CMK"
  description = "This control checks whether FSx lustre file system is encrypted with KMS CMK."
  query       = query.fsx_lustre_file_system_encrypted_with_kms_cmk

  tags = local.fsx_compliance_common_tags
}
