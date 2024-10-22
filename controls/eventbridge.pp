locals {
  eventbridge_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EventBridge"
  })
}

benchmark "eventbridge" {
  title       = "EventBridge"
  description = "This benchmark provides a set of controls that detect Terraform AWS EventBridge resources deviating from security best practices."

  children = [
    control.eventbridge_scheduler_schedule_encrypted_with_kms_cmk
  ]

  tags = merge(local.eventbridge_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "eventbridge_scheduler_schedule_encrypted_with_kms_cmk" {
  title       = "EventBridge Scheduler Schedule should be encrypted with KMS CMK"
  description = "This control checks whether EventBridge Scheduler Schedule is encrypted with KMS CMK."
  query       = query.eventbridge_scheduler_schedule_encrypted_with_kms_cmk

  tags = local.eventbridge_compliance_common_tags
}
