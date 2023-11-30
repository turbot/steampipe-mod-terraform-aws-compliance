locals {
  lambda_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Lambda"
  })
}

benchmark "lambda" {
  title       = "Lambda"
  description = "This benchmark provides a set of controls that detect Terraform AWS Lambda resources deviating from security best practices."

  children = [
    control.lambda_function_code_signing_configured,
    control.lambda_function_concurrent_execution_limit_configured,
    control.lambda_function_dead_letter_queue_configured,
    control.lambda_function_environment_encryption_enabled,
    control.lambda_function_in_vpc,
    control.lambda_function_url_auth_type_configured,
    control.lambda_function_use_latest_runtime,
    control.lambda_function_variables_no_sensitive_data,
    control.lambda_function_xray_tracing_enabled,
    control.lambda_permission_restricted_service_permission
  ]

  tags = merge(local.lambda_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "lambda_function_concurrent_execution_limit_configured" {
  title       = "Lambda functions concurrent execution limit configured"
  description = "Checks whether the AWS Lambda function is configured with function-level concurrent execution limit. The control is non complaint if the Lambda function is not configured with function-level concurrent execution limit."
  query       = query.lambda_function_concurrent_execution_limit_configured

  tags = merge(local.lambda_compliance_common_tags, {
    nist_csf = "true"
    soc_2    = "true"
  })
}

control "lambda_function_dead_letter_queue_configured" {
  title       = "Lambda functions should be configured with a dead-letter queue"
  description = "Enable this rule to help notify the appropriate personnel through Amazon Simple Queue Service (Amazon SQS) or Amazon Simple Notification Service (Amazon SNS) when a function has failed."
  query       = query.lambda_function_dead_letter_queue_configured

  tags = merge(local.lambda_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_csf                  = "true"
    soc_2                     = "true"
  })
}

control "lambda_function_in_vpc" {
  title       = "Lambda functions should be in a VPC"
  description = "Deploy AWS Lambda functions within an Amazon Virtual Private Cloud (Amazon VPC) for a secure communication between a function and other services within the Amazon VPC."
  query       = query.lambda_function_in_vpc

  tags = merge(local.lambda_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    pci                = "true"
    rbi_cyber_security = "true"
  })
}

control "lambda_function_use_latest_runtime" {
  title       = "Lambda functions should use latest runtimes"
  description = "This control checks that the Lambda function settings for runtimes match the expected values set for the latest runtimes for each supported language. This control checks for the following runtimes: nodejs14.x, nodejs12.x, nodejs10.x, python3.8, python3.7, python3.6, ruby2.7, ruby2.5,java11, java8, go1.x, dotnetcore3.1, dotnetcore2.1."
  query       = query.lambda_function_use_latest_runtime

  tags = merge(local.lambda_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "lambda_function_xray_tracing_enabled" {
  title       = "Lambda functions xray tracing should be enabled"
  description = "X-Ray tracing in lambda functions allows you to visualize and troubleshoot errors and performance bottlenecks, and investigate requests that resulted in an error."
  query       = query.lambda_function_xray_tracing_enabled

  tags = local.lambda_compliance_common_tags
}

control "lambda_function_url_auth_type_configured" {
  title       = "Lambda functions should not have URLs AuthType as 'None'"
  description = "This control checks whether lambda function have URL AuthType set to 'None'."
  query       = query.lambda_function_url_auth_type_configured

  tags = local.lambda_compliance_common_tags
}

control "lambda_function_code_signing_configured" {
  title       = "Lambda functions should have code signing configured"
  description = "This control checks whether code signing is configured for lambda function."
  query       = query.lambda_function_code_signing_configured

  tags = local.lambda_compliance_common_tags
}

control "lambda_function_variables_no_sensitive_data" {
  title       = "Lambda functions variable should not have any sensitive data"
  description = "Ensure functions environment variables is not having any sensitive data. Leveraging Secrets Manager enables secure provisioning of database credentials to Lambda functions while also ensuring the security of databases. This approach eliminates the need to hardcode secrets in code or pass them through environmental variables. Additionally, Secrets Manager facilitates the secure retrieval of credentials for establishing connections to databases and performing queries, enhancing overall security measures."
  query       = query.lambda_function_variables_no_sensitive_data

  tags = local.lambda_compliance_common_tags
}

control "lambda_function_environment_encryption_enabled" {
  title       = "Lambda functions variable encryption should be enabled"
  description = "Ensure that functions environment variables encryption is enabled."
  query       = query.lambda_function_environment_encryption_enabled

  tags = local.lambda_compliance_common_tags
}

control "lambda_permission_restricted_service_permission" {
  title       = "Lambda permissions should restrict service permission by source account or source arn"
  description = "Ensure that Lambda permissions restricts service permission by source account or source arn."
  query       = query.lambda_permission_restricted_service_permission

  tags = local.lambda_compliance_common_tags
}
