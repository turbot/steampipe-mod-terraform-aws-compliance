locals {
  conformance_pack_efs_common_tags = {
    service = "efs"
  }
}

control "efs_file_system_automatic_backups_enabled" {
  title         = "EFS file systems should be in a backup plan"
  description   = "To help with data back-up processes, ensure your Amazon Elastic File System (Amazon EFS) file systems are a part of an AWS Backup plan."
  sql           = query.efs_file_system_automatic_backups_enabled.sql

  tags = local.conformance_pack_efs_common_tags
}

control "efs_file_system_encrypt_data_at_rest" {
  title         = "EFS file system encryption at rest should be enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic File System (EFS)."
  sql           = query.efs_file_system_encrypt_data_at_rest.sql

  tags = local.conformance_pack_efs_common_tags
}