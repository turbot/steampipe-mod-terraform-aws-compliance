locals {
  ebs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "AWS/EBS"
  })
}

benchmark "ebs" {
  title       = "EBS"
  description = "This benchmark provides a set of controls that detect Terraform AWS EBS resources deviating from security best practices."

  children = [
    control.ebs_attached_volume_encryption_enabled,
    control.ebs_volume_encryption_at_rest_enabled
  ]

  tags = local.ebs_compliance_common_tags
}

control "ebs_attached_volume_encryption_enabled" {
  title         = "Attached EBS volumes should have encryption enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ebs_attached_volume_encryption_enabled.sql

  tags = merge(local.ebs_compliance_common_tags, {
    aws_foundational_security   = "true"
    gdpr                        = "true"
    hipaa                       = "true"
    nist_800_53_rev_4           = "true"
    nist_csf                    = "true"
    rbi_cyber_security          = "true"
  })
}

control "ebs_volume_encryption_at_rest_enabled" {
  title         = "EBS volumes should have encryption enabled"
  description   = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ebs_attached_volume_encryption_enabled.sql

  tags = merge(local.ebs_compliance_common_tags, {
    cis                = "true"
    gdpr               = "true"
    hipaa              = "true"
    rbi_cyber_security = "true"
  })
}
