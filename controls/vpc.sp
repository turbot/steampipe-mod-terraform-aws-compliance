locals {
  vpc_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "vpc"
  })
}

benchmark "vpc" {
  title    = "VPC"
  children = [
    control.vpc_default_security_group_restricts_all_traffic,
    control.vpc_eip_associated,
    control.vpc_flow_logs_enabled,
    control.vpc_igw_attached_to_authorized_vpc,
    control.vpc_network_acl_unused,
    control.vpc_security_group_description_for_rules,
    control.vpc_security_group_rule_description_for_rules,
    control.vpc_subnet_auto_assign_public_ip_disabled,
    control.vpc_security_group_associated_to_eni
  ]
  tags          = local.vpc_compliance_common_tags
}