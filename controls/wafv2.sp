locals {
  wafv2_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/WAFv2"
  })
}

benchmark "wafv2" {
  title       = "WAFV2"
  description = "This benchmark provides a set of controls that detect Terraform AWS WAFV2 deviating from security best practices."

  children = [
    control.wafv2_web_acl_rule_attached
  ]

  tags = merge(local.wafv2_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "wafv2_web_acl_rule_attached" {
  title       = "WAFV2 web ACL should have at least one rule or rule group attached"
  description = "This control checks if a WAFV2 Web ACL contains any WAF rules or rule groups. The rule is non compliant if there are no WAF rules or rule groups present within a Web ACL."
  query       = query.wafv2_web_acl_rule_attached

  tags = local.wafv2_compliance_common_tags
}