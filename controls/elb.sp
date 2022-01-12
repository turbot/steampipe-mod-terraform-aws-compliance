locals {
  elb_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "elb"
  })
}

benchmark "elb" {
  title    = "ELB"
  children = [
    control.elb_application_classic_lb_logging_enabled,
    control.elb_application_lb_deletion_protection_enabled,
    control.elb_application_lb_drop_http_headers,
    control.elb_application_lb_waf_enabled,
    control.elb_classic_lb_cross_zone_load_balancing_enabled,
    control.elb_classic_lb_use_ssl_certificate,
    control.elb_classic_lb_use_tls_https_listeners
  ]
  tags          = local.elb_compliance_common_tags
}
