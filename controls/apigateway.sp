locals {
  apigateway_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/APIGateway"
  })
}

benchmark "apigateway" {
  title       = "API Gateway"
  description = "This benchmark provides a set of controls that detect Terraform AWS API Gateway resources deviating from security best practices."

  children = [
    control.apigateway_deployment_create_before_destroy_enabled,
    control.apigateway_method_settings_cache_enabled,
    control.apigateway_method_settings_cache_encrypted,
    control.apigateway_method_settings_data_trace_enabled,
    control.apigateway_rest_api_create_before_destroy_enabled,
    control.apigateway_rest_api_stage_use_ssl_certificate,
    control.apigateway_rest_api_stage_xray_tracing_enabled,
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.apigateway_stage_logging_enabled,
    control.apigatewayv2_route_set_authorization_type
  ]

  tags = merge(local.apigateway_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "apigateway_rest_api_stage_use_ssl_certificate" {
  title       = "API Gateway stage should uses SSL certificate"
  description = "Ensure if a REST API stage uses a Secure Sockets Layer (SSL) certificate. This rule is complaint if the REST API stage does not have an associated SSL certificate."
  query       = query.apigateway_rest_api_stage_use_ssl_certificate

  tags = merge(local.apigateway_compliance_common_tags, {
    rbi_cyber_security = "true"
  })
}

control "apigateway_rest_api_stage_xray_tracing_enabled" {
  title       = "API Gateway REST API stages should have AWS X-Ray tracing enabled"
  description = "This control checks whether AWS X-Ray active tracing is enabled for your Amazon API Gateway REST API stages."
  query       = query.apigateway_rest_api_stage_xray_tracing_enabled

  tags = merge(local.apigateway_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "apigateway_stage_cache_encryption_at_rest_enabled" {
  title       = "API Gateway REST API cache data should be encrypted at rest"
  description = "This control checks whether all methods in API Gateway REST API stages that have cache enabled are encrypted. The control fails if any method in an API Gateway REST API stage is configured to cache and the cache is not encrypted."
  query       = query.apigateway_stage_cache_encryption_at_rest_enabled

  tags = merge(local.apigateway_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "apigateway_stage_logging_enabled" {
  title       = "API Gateway REST and WebSocket API logging should be enabled"
  description = "This control checks whether all stages of an Amazon API Gateway REST or WebSocket API have logging enabled. The control fails if logging is not enabled for all methods of a stage or if loggingLevel is neither ERROR nor INFO."
  query       = query.apigateway_stage_logging_enabled

  tags = merge(local.apigateway_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "apigateway_rest_api_create_before_destroy_enabled" {
  title       = "AWS API Gateway REST API should have create_before_destroy enabled"
  description = "This control checks whether AWS API Gateway REST API has create_before_destroy enabled. It is recommended to enable the resource lifecycle configuration block create_before_destroy argument in this resource configuration to manage all requests that use this API, avoiding an outage."
  query       = query.apigateway_rest_api_create_before_destroy_enabled

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_deployment_create_before_destroy_enabled" {
  title       = "AWS API Gateway Deployment should have create_before_destroy enabled"
  description = "This control checks whether AWS API Gateway Deployment has create_before_destroy enabled. It is recommended to enable the resource lifecycle configuration block create_before_destroy argument in this resource configuration to manage all requests that use this API, avoiding an outage."
  query       = query.apigateway_deployment_create_before_destroy_enabled

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_method_settings_cache_enabled" {
  title       = "AWS API Gateway Method Settings should have cache enabled"
  description = "This control checks whether AWS API Gateway Method Settings has cache enabled. It is recommended to enable cache for all methods in API Gateway."
  query       = query.apigateway_method_settings_cache_enabled

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_method_settings_cache_encrypted" {
  title       = "AWS API Gateway Method Settings should have cache encrypted"
  description = "This control checks whether AWS API Gateway Method Settings has cache encrypted. It is recommended to enable cache encryption for all methods in API Gateway."
  query       = query.apigateway_method_settings_cache_encrypted

  tags = local.apigateway_compliance_common_tags
}

control "apigateway_method_settings_data_trace_enabled" {
  title       = "Ensure Data Trace is not enabled in API Gateway Method Setting"
  description = "This control checks whether AWS API Gateway Method Settings has data trace enabled. It is recommended to disable data trace for all methods in API Gateway."
  query       = query.apigateway_method_settings_data_trace_enabled

  tags = local.apigateway_compliance_common_tags
}

control "apigatewayv2_route_set_authorization_type" {
  title       = "Ensure API GatewayV2 routes specify an authorization type"
  description = "This control checks whether API Gateway V2 Route has authorization type set. It is recommended to set authorization type for all routes in API Gateway V2."
  query       = query.apigatewayv2_route_set_authorization_type

  tags = local.apigateway_compliance_common_tags
}