locals {
  efs_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EFS"
  })
}

benchmark "efs" {
  title       = "EFS"
  description = "This benchmark provides a set of controls that detect Terraform AWS EFS resources deviating from security best practices."

  children = [
    control.efs_access_point_has_root_directory,
    control.efs_access_point_has_user_identity,
    control.efs_file_system_automatic_backups_enabled,
    control.efs_file_system_encrypt_data_at_rest,
    control.efs_file_system_encrypted_with_kms_cmk
  ]

  tags = merge(local.efs_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "efs_file_system_automatic_backups_enabled" {
  title       = "EFS file systems should be in a backup plan"
  description = "To help with data back-up processes, ensure your Amazon Elastic File System (Amazon EFS) file systems are a part of an AWS Backup plan."
  query       = query.efs_file_system_automatic_backups_enabled

  tags = merge(local.efs_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
    soc_2                     = "true"
  })
}

control "efs_file_system_encrypt_data_at_rest" {
  title       = "EFS file system encryption at rest should be enabled"
  description = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic File System (EFS)."
  query       = query.efs_file_system_encrypt_data_at_rest

  tags = merge(local.efs_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
  })
}

control "efs_access_point_has_user_identity" {
  title       = "EFS access point should have a user identity"
  description = "This control checks whether the Elastic File System access point has a user identity associated with it."
  query       = query.efs_access_point_has_user_identity

  tags = local.efs_compliance_common_tags
}

control "efs_access_point_has_root_directory" {
  title       = "EFS access point should have a root directory"
  description = "This control checks whether the Elastic File System access point has a root directory associated with it."
  query       = query.efs_access_point_has_root_directory

  tags = local.efs_compliance_common_tags
}

control "efs_file_system_encrypted_with_kms_cmk" {
  title       = "EFS file system should be encrypted with a KMS CMK"
  description = "This control checks whether the Elastic File System file system is encrypted with a KMS CMK."
  query       = query.efs_file_system_encrypted_with_kms_cmk

  tags = local.efs_compliance_common_tags
}
