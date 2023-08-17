locals {
  appsync_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/AppSync"
  })
}

benchmark "appsync" {
  title       = "AppSync"
  description = "This benchmark provides a set of controls that detect Terraform AWS AppSync resources deviating from security best practices."

  children = [
    control.appsync_api_cache_encryption_at_rest_enabled,
    control.appsync_api_cache_encryption_in_transit_enabled,
    control.appsync_graphql_api_cloudwatch_logs_enabled,
    control.appsync_graphql_api_field_level_logs_enabled
  ]

  tags = merge(local.appsync_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "appsync_graphql_api_field_level_logs_enabled" {
  title       = "AppSync GraphQL API field level logs should be enabled"
  description = "This control checks whether field level logs are enabled for the AppSync GraphQL API."
  query       = query.appsync_graphql_api_field_level_logs_enabled

  tags = local.appsync_compliance_common_tags
}

control "appsync_graphql_api_cloudwatch_logs_enabled" {
  title       = "AppSync GraphQL API CloudWatch logs should be enabled"
  description = "This control checks whether the CloudWatch logs are enabled for the AppSync GraphQL API."
  query       = query.appsync_graphql_api_cloudwatch_logs_enabled

  tags = local.appsync_compliance_common_tags
}

control "appsync_api_cache_encryption_at_rest_enabled" {
  title       = "AppSync API cache encryption at rest should be enabled"
  description = "This control checks whether encryption at rest is enabled for the AppSync API cache."
  query       = query.appsync_api_cache_encryption_at_rest_enabled

  tags = local.appsync_compliance_common_tags
}

control "appsync_api_cache_encryption_in_transit_enabled" {
  title       = "AppSync API cache encryption at transit should be enabled"
  description = "This control checks whether encryption at transit is enabled for the AppSync API cache."
  query       = query.appsync_api_cache_encryption_in_transit_enabled

  tags = local.appsync_compliance_common_tags
}
