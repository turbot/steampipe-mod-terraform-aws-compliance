locals {
  conformance_pack_ebs_common_tags = {
    service = "ebs"
  }
}

control "ebs_attached_volume_encryption_enabled" {
  title         = "Attached EBS volumes should have encryption enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ebs_attached_volume_encryption_enabled.sql

  tags = local.conformance_pack_ebs_common_tags
}
