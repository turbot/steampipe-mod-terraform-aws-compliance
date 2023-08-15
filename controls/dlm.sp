locals {
  dlm_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/DLM"
  })
}

benchmark "dlm" {
  title       = "DLM"
  description = "This benchmark provides a set of controls that detect Terraform AWS DLM resources deviating from security best practices."

  children = [
    control.dlm_lifecycle_policy_events_cross_region_encrypted_with_kms_cmk,
    control.dlm_lifecycle_policy_events_cross_region_encryption_enabled,
    control.dlm_schedule_cross_region_encrypted_with_kms_cmk,
    control.dlm_schedule_cross_region_encryption_enabled
  ]

  tags = merge(local.dlm_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dlm_lifecycle_policy_events_cross_region_encryption_enabled" {
  title       = "DLM lifecycle policy events cross region encryption should be enabled"
  description = "This control checks whether the DLM lifecycle policy events cross region encryption is enabled."
  query       = query.dlm_lifecycle_policy_events_cross_region_encryption_enabled

  tags = local.dlm_compliance_common_tags
}

control "dlm_lifecycle_policy_events_cross_region_encrypted_with_kms_cmk" {
  title       = "DLM lifecycle policy events cross encrypted with KMS CMK should be enabled"
  description = "This control checks whether the DLM lifecycle policy events cross encrypted with KMS CMK."
  query       = query.dlm_lifecycle_policy_events_cross_region_encrypted_with_kms_cmk

  tags = local.dlm_compliance_common_tags
}

control "dlm_schedule_cross_region_encryption_enabled" {
  title       = "DLM schedule cross region encryption should be enabled"
  description = "This control checks whether the DLM schedule cross region encryption is enabled."
  query       = query.dlm_schedule_cross_region_encryption_enabled

  tags = local.dlm_compliance_common_tags
}

control "dlm_schedule_cross_region_encrypted_with_kms_cmk" {
  title       = "DLM schedule cross encrypted with KMS CMK should be enabled"
  description = "This control checks whether the DLM schedule cross encrypted with KMS CMK."
  query       = query.dlm_schedule_cross_region_encrypted_with_kms_cmk

  tags = local.dlm_compliance_common_tags
}