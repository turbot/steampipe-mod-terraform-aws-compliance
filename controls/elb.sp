locals {
  elb_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ELB"
  })
}

benchmark "elb" {
  title       = "ELB"
  description = "This benchmark provides a set of controls that detect Terraform AWS ELB resources deviating from security best practices."

  children = [
    control.ec2_classic_lb_connection_draining_enabled,
    control.elb_all_lb_logging_enabled,
    control.elb_application_lb_deletion_protection_enabled,
    control.elb_application_lb_drop_http_headers,
    control.elb_application_lb_drop_invalid_header_fields,
    control.elb_application_lb_waf_enabled,
    control.elb_application_network_gateway_lb_use_desync_mitigation_mode,
    control.elb_classic_lb_cross_zone_load_balancing_enabled,
    control.elb_classic_lb_use_desync_mitigation_mode,
    control.elb_classic_lb_use_ssl_certificate,
    control.elb_classic_lb_use_tls_https_listeners,
    control.elb_lb_use_secure_protocol_listener
  ]

  tags = merge(local.elb_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ec2_classic_lb_connection_draining_enabled" {
  title       = "Classic Load Balancers should have connection draining enabled"
  description = "This control checks whether Classic Load Balancers have connection draining enabled."
  query       = query.ec2_classic_lb_connection_draining_enabled

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "elb_all_lb_logging_enabled" {
  title       = "ELB application and classic load balancer logging should be enabled"
  description = "Elastic Load Balancing activity is a central point of communication within an environment. Ensure that logging is enabled to track the activities of the load balancer."
  query       = query.elb_all_lb_logging_enabled

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
    soc_2                     = "true"
  })
}

control "elb_application_lb_deletion_protection_enabled" {
  title       = "ELB application load balancer deletion protection should be enabled"
  description = "This rule ensures that Elastic Load Balancing has deletion protection enabled."
  query       = query.elb_application_lb_deletion_protection_enabled

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_csf                  = "true"
  })
}

control "elb_application_lb_drop_http_headers" {
  title       = "ELB application load balancers should be drop HTTP headers"
  description = "Ensure that your Elastic Load Balancers (ELB) are configured to drop http headers."
  query       = query.elb_application_lb_drop_http_headers

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    gdpr                      = "true"
    nist_800_53_rev_4         = "true"
    rbi_cyber_security        = "true"
  })
}

control "elb_application_lb_waf_enabled" {
  title       = "ELB application load balancers should have Web Application Firewall (WAF) enabled"
  description = "Ensure AWS WAF is enabled on Elastic Load Balancers (ELB) to help protect web applications."
  query       = query.elb_application_lb_waf_enabled

  tags = merge(local.elb_compliance_common_tags, {
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "elb_classic_lb_cross_zone_load_balancing_enabled" {
  title       = "ELB classic load balancers should have cross-zone load balancing enabled"
  description = "Enable cross-zone load balancing for your Elastic Load Balancers (ELBs) to help maintain adequate capacity and availability. The cross-zone load balancing reduces the need to maintain equivalent number of instances in each enabled availability zone."
  query       = query.elb_classic_lb_cross_zone_load_balancing_enabled

  tags = merge(local.elb_compliance_common_tags, {
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
  })
}

control "elb_classic_lb_use_ssl_certificate" {
  title       = "ELB classic load balancers should use SSL certificates"
  description = "Because sensitive data can exist and to help protect data at transit, ensure encryption is enabled for your Elastic Load Balancing."
  query       = query.elb_classic_lb_use_ssl_certificate

  tags = merge(local.elb_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "elb_classic_lb_use_tls_https_listeners" {
  title       = "ELB classic load balancers should only use SSL or HTTPS listeners"
  description = "Ensure that your Elastic Load Balancers (ELBs) are configured with SSL or HTTPS listeners. Because sensitive data can exist, enable encryption in transit to help protect that data."
  query       = query.elb_classic_lb_use_tls_https_listeners

  tags = merge(local.elb_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    rbi_cyber_security        = "true"
  })
}

control "elb_application_network_gateway_lb_use_desync_mitigation_mode" {
  title       = "ELB application, network and gateway load balancers should have defensive or strictest desync mitigation mode configured"
  description = "Ensure that your Elastic Load Balancers (ELBs) are configured with defensive or strictest desync mitigation mode."
  query       = query.elb_application_network_gateway_lb_use_desync_mitigation_mode

  tags = local.elb_compliance_common_tags
}

control "elb_classic_lb_use_desync_mitigation_mode" {
  title       = "ELB classic load balancers should have defensive or strictest desync mitigation mode configured"
  description = "Ensure that your classic load balancers (ELBs) are configured with defensive or strictest desync mitigation mode."
  query       = query.elb_classic_lb_use_desync_mitigation_mode

  tags = local.elb_compliance_common_tags
}

control "elb_application_lb_drop_invalid_header_fields" {
  title       = "ELB application load balancers should have drop invalid header fields configured"
  description = "Ensure that your application load balancers are configured to drop invalid header fields."
  query       = query.elb_application_lb_drop_invalid_header_fields

  tags = local.elb_compliance_common_tags
}

control "elb_lb_use_secure_protocol_listener" {
  title       = "ELB load balancer listeners should use a secure protocol"
  description = "Ensure that your load balancer listener are configured with secure protocol including redirections."
  query       = query.elb_lb_use_secure_protocol_listener

  tags = local.elb_compliance_common_tags
}