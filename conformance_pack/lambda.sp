locals {
  conformance_pack_lambda_common_tags = {
    service = "lambda"
  }
}

control "lambda_function_concurrent_execution_limit_configured" {
  title       = "Lambda functions concurrent execution limit configured"
  description = "Checks whether the AWS Lambda function is configured with function-level concurrent execution limit. The control is non complaint if the Lambda function is not configured with function-level concurrent execution limit."
  sql           = query.lambda_function_concurrent_execution_limit_configured.sql

  tags = local.conformance_pack_lambda_common_tags
}

control "lambda_function_dead_letter_queue_configured" {
  title       = "Lambda functions should be configured with a dead-letter queue"
  description = "Enable this rule to help notify the appropriate personnel through Amazon Simple Queue Service (Amazon SQS) or Amazon Simple Notification Service (Amazon SNS) when a function has failed."
  sql           = query.lambda_function_dead_letter_queue_configured.sql

  tags = local.conformance_pack_lambda_common_tags
}

control "lambda_function_in_vpc" {
  title       = "Lambda functions should be in a VPC"
  description = "Deploy AWS Lambda functions within an Amazon Virtual Private Cloud (Amazon VPC) for a secure communication between a function and other services within the Amazon VPC."
  sql           = query.lambda_function_in_vpc.sql

  tags = local.conformance_pack_lambda_common_tags
}

control "lambda_function_use_latest_runtime" {
  title         = "Lambda functions should use latest runtimes"
  description   = "This control checks that the Lambda function settings for runtimes match the expected values set for the latest runtimes for each supported language. This control checks for the following runtimes: nodejs14.x, nodejs12.x, nodejs10.x, python3.8, python3.7, python3.6, ruby2.7, ruby2.5,java11, java8, go1.x, dotnetcore3.1, dotnetcore2.1."
  sql           = query.lambda_function_use_latest_runtime.sql

  tags = local.conformance_pack_lambda_common_tags
}

control "lambda_function_xray_tracing_enabled" {
  title       = "Lambda functions xray tracing should be enabled"
  description = "X-Ray tracing in lambda functions allows you to visualize and troubleshoot errors and performance bottlenecks, and investigate requests that resulted in an error."
  sql           = query.lambda_function_xray_tracing_enabled.sql

  tags = local.conformance_pack_lambda_common_tags
}
