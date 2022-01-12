locals {
  apigateway_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "apigateway"
  })
}

benchmark "apigateway" {
  title         = "API Gateway"
  children = [
    control.apigateway_rest_api_stage_use_ssl_certificate,
    control.apigateway_rest_api_stage_xray_tracing_enabled,
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.apigateway_stage_logging_enabled
  ]
  tags          = local.apigateway_compliance_common_tags
}
