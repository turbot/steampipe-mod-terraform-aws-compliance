locals {
  sfn_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/StepFunctions"
  })
}

benchmark "sfn" {
  title       = "Step Functions"
  description = "This benchmark provides a set of controls that detect Terraform AWS Step Functions resources deviating from security best practices."

  children = [
    control.sfn_state_machine_xray_tracing_enabled,
    control.sfn_state_machine_execution_history_logging_enabled
  ]

  tags = merge(local.sfn_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "sfn_state_machine_xray_tracing_enabled" {
  title       = "Step Functions state machine should have X-Ray tracing enabled"
  description = "Ensure State Machine has X-Ray tracing enabled."
  query       = query.sfn_state_machine_xray_tracing_enabled

  tags = local.sfn_compliance_common_tags
}

control "sfn_state_machine_execution_history_logging_enabled" {
  title       = "Step Functions state machine should have execution history logging enabled"
  description = "Ensure State Machine have execution history logging enabled."
  query       = query.sfn_state_machine_execution_history_logging_enabled

  tags = local.sfn_compliance_common_tags
}
