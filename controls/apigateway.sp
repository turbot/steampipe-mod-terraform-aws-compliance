locals {
  apigateway_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "apigateway"
  })
}

benchmark "apigateway" {
  title         = "API Gateway"
  description = "Amazon API Gateway is an AWS service for creating, publishing, maintaining, monitoring, and securing REST, HTTP, and WebSocket APIs at any scale. This benchmark provides a set of controls that detect your Terraform resources deviating from security best practices prior to deployment in your AWS accounts."
  children = [
    control.apigateway_rest_api_stage_use_ssl_certificate,
    control.apigateway_rest_api_stage_xray_tracing_enabled,
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.apigateway_stage_logging_enabled
  ]
  tags          = local.apigateway_compliance_common_tags
}

control "apigateway_rest_api_stage_use_ssl_certificate" {
  title         = "API Gateway stage should uses SSL certificate"
  description   = "Ensure if a REST API stage uses a Secure Sockets Layer (SSL) certificate. This rule is complaint if the REST API stage does not have an associated SSL certificate."
  sql           = query.apigateway_rest_api_stage_use_ssl_certificate.sql

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_rest_api_stage_xray_tracing_enabled" {
  title         = "API Gateway REST API stages should have AWS X-Ray tracing enabled"
  description   = "This control checks whether AWS X-Ray active tracing is enabled for your Amazon API Gateway REST API stages."
  sql           = query.apigateway_rest_api_stage_xray_tracing_enabled.sql

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_stage_cache_encryption_at_rest_enabled" {
  title         = "API Gateway REST API cache data should be encrypted at rest"
  description   = "This control checks whether all methods in API Gateway REST API stages that have cache enabled are encrypted. The control fails if any method in an API Gateway REST API stage is configured to cache and the cache is not encrypted."
  sql           = query.apigateway_stage_cache_encryption_at_rest_enabled.sql

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_stage_logging_enabled" {
  title         = "API Gateway REST and WebSocket API logging should be enabled"
  description   = "This control checks whether all stages of an Amazon API Gateway REST or WebSocket API have logging enabled. The control fails if logging is not enabled for all methods of a stage or if loggingLevel is neither ERROR nor INFO."
  sql           = query.apigateway_stage_logging_enabled.sql

  tags = local.apigateway_compliance_common_tags
}