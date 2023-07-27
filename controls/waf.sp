locals {
  waf_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/WAF"
  })
}

benchmark "waf" {
  title       = "WAF"
  description = "This benchmark provides a set of controls that detect Terraform AWS WAF deviating from security best practices."

  children = [
    control.waf_regional_web_acl_logging_enabled,
    control.waf_regional_web_acl_rule_attached,
    control.waf_regional_web_acl_rule_with_action,
    control.waf_web_acl_logging_enabled,
    control.waf_web_acl_rule_attached,
    control.waf_web_acl_rule_with_action
  ]

  tags = merge(local.waf_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "waf_web_acl_rule_attached" {
  title       = "WAF web ACL should have at least one rule or rule group"
  description = "This control checks whether WAF web ACL contains at least one WAF rule or WAF rule group. The control fails if a web ACL does not contain any WAF rules or rule groups."
  query       = query.waf_web_acl_rule_attached

  tags = local.waf_compliance_common_tags
}

control "waf_regional_web_acl_rule_attached" {
  title       = "WAF regional web ACL should have at least one rule or rule group attached"
  description = "This control checks if a WAF regional Web ACL contains any WAF rules or rule groups. The rule is non compliant if there are no WAF rules or rule groups present within a Web ACL."
  query       = query.waf_regional_web_acl_rule_attached

  tags = local.waf_compliance_common_tags
}

control "waf_web_acl_logging_enabled" {
  title       = "WAF web ACL logging should be enabled"
  description = "To help with logging and monitoring within your environment, enable AWS WAF logging on regional and global web ACLs."
  query       = query.waf_web_acl_logging_enabled

  tags = local.waf_compliance_common_tags
}

control "waf_regional_web_acl_logging_enabled" {
  title       = "WAF regional web ACL logging should be enabled"
  description = "To help with logging and monitoring within your environment, enable AWS WAF logging on regional and global web ACLs."
  query       = query.waf_regional_web_acl_logging_enabled

  tags = local.waf_compliance_common_tags
}

control "waf_web_acl_rule_with_action" {
  title       = "WAF web ACLs should have rules with actions"
  description = "Ensure WAF web ACLs have all have rules actions defined."
  query       = query.waf_web_acl_rule_with_action

  tags = local.waf_compliance_common_tags
}

control "waf_regional_web_acl_rule_with_action" {
  title       = "WAF regional web ACLs should have rules with actions"
  description = "Ensure WAF regional web ACLs have all have rules actions defined."
  query       = query.waf_regional_web_acl_rule_with_action

  tags = local.waf_compliance_common_tags
}

