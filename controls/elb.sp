locals {
  elb_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "elb"
  })
}

benchmark "elb" {
  title       = "ELB"
  description = "This benchmark provides a set of controls that detect Terraform AWS ELB resources deviating from security best practices."

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

control "elb_application_classic_lb_logging_enabled" {
  title         = "ELB application and classic load balancer logging should be enabled"
  description   = "Elastic Load Balancing activity is a central point of communication within an environment."
  sql           = query.elb_application_classic_lb_logging_enabled.sql

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "elb_application_lb_deletion_protection_enabled" {
  title         = "ELB application load balancer deletion protection should be enabled"
  description   = "This rule ensures that Elastic Load Balancing has deletion protection enabled."
  sql           = query.elb_application_lb_deletion_protection_enabled.sql

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa    = "true"
    nist_csf = "true"
  })
}

control "elb_application_lb_drop_http_headers" {
  title         = "ELB application load balancers should be drop HTTP headers"
  description   = "Ensure that your Elastic Load Balancers (ELB) are configured to drop http headers."
  sql           = query.elb_application_lb_drop_http_headers.sql

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa              = "true"
    gdpr               = "true"
    nist_800_53_rev_4  = "true"
    rbi_cyber_security = "true"
  })
}

control "elb_application_lb_waf_enabled" {
  title         = "ELB application load balancers should have Web Application Firewall (WAF) enabled"
  description   = "Ensure AWS WAF is enabled on Elastic Load Balancers (ELB) to help protect web applications."
  sql           = query.elb_application_lb_waf_enabled.sql

  tags = merge(local.elb_compliance_common_tags, {
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "elb_classic_lb_cross_zone_load_balancing_enabled" {
  title         = "ELB classic load balancers should have cross-zone load balancing enabled"
  description   = "Enable cross-zone load balancing for your Elastic Load Balancers (ELBs) to help maintain adequate capacity and availability. The cross-zone load balancing reduces the need to maintain equivalent number of instances in each enabled availability zone."
  sql           = query.elb_classic_lb_cross_zone_load_balancing_enabled.sql

  tags = merge(local.elb_compliance_common_tags, {
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
  })
}

control "elb_classic_lb_use_ssl_certificate" {
  title         = "ELB classic load balancers should use SSL certificates"
  description   = "Because sensitive data can exist and to help protect data at transit, ensure encryption is enabled for your Elastic Load Balancing."
  sql           = query.elb_classic_lb_use_ssl_certificate.sql

  tags = merge(local.elb_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "elb_classic_lb_use_tls_https_listeners" {
  title         = "ELB classic load balancers should only use SSL or HTTPS listeners"
  description   = "Ensure that your Elastic Load Balancers (ELBs) are configured with SSL or HTTPS listeners. Because sensitive data can exist, enable encryption in transit to help protect that data."
  sql           = query.elb_classic_lb_use_tls_https_listeners.sql

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    rbi_cyber_security        = "true"
  })
}
