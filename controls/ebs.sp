locals {
  ebs_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EBS"
  })
}

benchmark "ebs" {
  title       = "EBS"
  description = "This benchmark provides a set of controls that detect Terraform AWS EBS resources deviating from security best practices."

  children = [
    control.ebs_snapshot_copy_encrypted_with_kms_cmk,
    control.ebs_volume_encryption_at_rest_enabled
  ]

  tags = merge(local.ebs_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ebs_volume_encryption_at_rest_enabled" {
  title       = "EBS volumes should have encryption enabled"
  description = "Because sensitive data can exist and to help protect data at rest, ensure encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  query       = query.ebs_volume_encryption_at_rest_enabled

  tags = merge(local.ebs_compliance_common_tags, {
    cis                = "true"
    gdpr               = "true"
    hipaa              = "true"
    rbi_cyber_security = "true"
  })
}

control "ebs_snapshot_copy_encrypted_with_kms_cmk" {
  title       = "EBS snapshots should be encrypted with CMK"
  description = "This control checks whether EBS snapshots are encrypted with customer-managed key."
  query       = query.ebs_snapshot_copy_encrypted_with_kms_cmk

  tags = local.ebs_compliance_common_tags
}