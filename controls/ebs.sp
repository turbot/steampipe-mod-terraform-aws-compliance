locals {
  ebs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ebs"
  })
}

benchmark "ebs" {
  title         = "EBS"
  children = [
    control.ebs_attached_volume_encryption_enabled
  ]
  tags          = local.ebs_compliance_common_tags
}
