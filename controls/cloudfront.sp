locals {
  cloudfront_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cloudfront"
  })
}

benchmark "cloudfront" {
  title         = "CloudFront"
  children = [
    control.cloudfront_distribution_configured_with_origin_failover,
    control.cloudfront_distribution_default_root_object_configured,
    control.cloudfront_distribution_encryption_in_transit_enabled,
    control.cloudfront_distribution_logging_enabled,
    control.cloudfront_distribution_origin_access_identity_enabled,
    control.cloudfront_distribution_waf_enabled,
    control.cloudfront_protocol_version_is_low
  ]
  tags          = local.cloudfront_compliance_common_tags
}
