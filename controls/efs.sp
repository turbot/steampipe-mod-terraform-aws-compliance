locals {
  efs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "efs"
  })
}

benchmark "efs" {
  title       = "EFS"
  description = "This benchmark provides a set of controls that detect Terraform AWS EFS resources deviating from security best practices."

  children = [
    control.efs_file_system_automatic_backups_enabled,
    control.efs_file_system_encrypt_data_at_rest,
  ]

  tags = local.efs_compliance_common_tags
}

control "efs_file_system_automatic_backups_enabled" {
  title         = "EFS file systems should be in a backup plan"
  description   = "To help with data back-up processes, ensure your Amazon Elastic File System (Amazon EFS) file systems are a part of an AWS Backup plan."
  sql           = query.efs_file_system_automatic_backups_enabled.sql

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
  title         = "EFS file system encryption at rest should be enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic File System (EFS)."
  sql           = query.efs_file_system_encrypt_data_at_rest.sql

  tags = merge(local.efs_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
  })
}