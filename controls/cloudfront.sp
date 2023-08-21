locals {
  cloudfront_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudFront"
  })
}

benchmark "cloudfront" {
  title       = "CloudFront"
  description = "This benchmark provides a set of controls that detect Terraform AWS CloudFront resources deviating from security best practices."

  children = [
    control.cloudfront_distribution_configured_with_origin_failover,
    control.cloudfront_distribution_default_root_object_configured,
    control.cloudfront_distribution_encryption_in_transit_enabled,
    control.cloudfront_distribution_logging_enabled,
    control.cloudfront_distribution_origin_access_identity_enabled,
    control.cloudfront_distribution_waf_enabled,
    control.cloudfront_protocol_version_is_low,
    control.cloudfront_response_header_use_strict_transport_policy_setting
  ]

  tags = merge(local.cloudfront_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "cloudfront_distribution_configured_with_origin_failover" {
  title       = "CloudFront distributions should have origin failover configured"
  description = "This control checks whether an Amazon CloudFront distribution is configured with an origin group that has two or more origins. CloudFront origin failover can increase availability. Origin failover automatically redirects traffic to a secondary origin if the primary origin is unavailable or if it returns specific HTTP response status codes."
  query       = query.cloudfront_distribution_configured_with_origin_failover

  tags = merge(local.cloudfront_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "cloudfront_distribution_default_root_object_configured" {
  title       = "CloudFront distributions should have a default root object configured"
  description = "This control checks whether an Amazon CloudFront distribution is configured to return a specific object that is the default root object. The control fails if the CloudFront distribution does not have a default root object configured."
  query       = query.cloudfront_distribution_default_root_object_configured

  tags = merge(local.cloudfront_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "cloudfront_distribution_encryption_in_transit_enabled" {
  title       = "CloudFront distributions should require encryption in transit"
  description = "This control checks whether an Amazon CloudFront distribution requires viewers to use HTTPS directly or whether it uses redirection. The control fails if ViewerProtocolPolicy is set to allow-all for defaultCacheBehavior or for cacheBehaviors."
  query       = query.cloudfront_distribution_encryption_in_transit_enabled

  tags = merge(local.cloudfront_compliance_common_tags, {
    gdpr  = "true"
    hipaa = "true"
  })
}

control "cloudfront_distribution_logging_enabled" {
  title       = "CloudFront distributions should have logging enabled"
  description = "This control checks whether server access logging is enabled on CloudFront distributions. The control fails if access logging is not enabled for a distribution."
  query       = query.cloudfront_distribution_logging_enabled

  tags = merge(local.cloudfront_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "cloudfront_distribution_origin_access_identity_enabled" {
  title       = "CloudFront distributions should have origin access identity enabled"
  description = "This control checks whether an Amazon CloudFront distribution with Amazon S3 Origin type has Origin Access Identity (OAI) configured. The control fails if OAI is not configured."
  query       = query.cloudfront_distribution_origin_access_identity_enabled

  tags = merge(local.cloudfront_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "cloudfront_distribution_waf_enabled" {
  title       = "CloudFront distributions should have AWS WAF enabled"
  description = "This control checks whether CloudFront distributions are associated with either AWS WAF or AWS WAFv2 web ACLs. The control fails if the distribution is not associated with a web ACL."
  query       = query.cloudfront_distribution_waf_enabled

  tags = merge(local.cloudfront_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "cloudfront_protocol_version_is_low" {
  title       = "CloudFront distributions minimum protocol version should be set"
  description = "CloudFront distributions minimum protocol version should be a good one. Minimum recommended version is TLSv1.2_2019."
  query       = query.cloudfront_protocol_version_is_low

  tags = local.cloudfront_compliance_common_tags
}

control "cloudfront_response_header_use_strict_transport_policy_setting" {
  title       = "CloudFront response header policy should be configured with Strict Transport Security"
  description = "This control checks whether CloudFront response header policy enforces Strict Transport Security."
  query       = query.cloudfront_response_header_use_strict_transport_policy_setting

  tags = local.cloudfront_compliance_common_tags
}

control "cloudfront_distribution_enabled" {
  title       = "CloudFront distriibution should be in enabled state"
  description = "This control checks whether CloudFront distriibution is enabled."
  query       = query.cloudfront_distribution_enabled

  tags = local.cloudfront_compliance_common_tags
}
