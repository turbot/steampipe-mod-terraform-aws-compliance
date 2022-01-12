locals {
  lambda_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "lambda"
  })
}

benchmark "lambda" {
  title    = "Lambda"
  children = [
    control.lambda_function_concurrent_execution_limit_configured,
    control.lambda_function_dead_letter_queue_configured,
    control.lambda_function_in_vpc,
    control.lambda_function_use_latest_runtime,
    control.lambda_function_xray_tracing_enabled,
    control.lambda_function_log_groups_enabled
  ]
  tags          = local.kms_compliance_common_tags
}
