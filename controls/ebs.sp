locals {
  ebs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ebs"
  })
}

benchmark "ebs" {
  title         = "EBS"
  children = [
    control.ebs_attached_volume_encryption_enabled,
    control.ebs_volume_encryption_at_rest_enabled
  ]
  tags          = local.ebs_compliance_common_tags
}

control "ebs_attached_volume_encryption_enabled" {
  title         = "Attached EBS volumes should have encryption enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ebs_attached_volume_encryption_enabled.sql

  tags = local.ebs_compliance_common_tags
}

control "ebs_volume_encryption_at_rest_enabled" {
  title         = "EBS volumes should have encryption enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ebs_attached_volume_encryption_enabled.sql

  tags = local.ebs_compliance_common_tags
}
