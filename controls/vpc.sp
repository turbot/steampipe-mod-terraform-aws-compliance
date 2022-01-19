locals {
  vpc_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "vpc"
  })
}

benchmark "vpc" {
  title       = "VPC"
  description = "This benchmark provides a set of controls that detect Terraform AWS VPC resources deviating from security best practices."

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

control "vpc_default_security_group_restricts_all_traffic" {
  title       = "VPC default security group should not allow inbound and outbound traffic"
  description = "Amazon Elastic Compute Cloud (Amazon EC2) security groups can help in the management of network access by providing stateful filtering of ingress and egress network traffic to AWS resources."
  sql           = query.vpc_default_security_group_restricts_all_traffic.sql

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
    cis                       = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "vpc_eip_associated" {
  title       = "VPC EIPs should be associated with an EC2 instance or ENI"
  description = "This rule ensures Elastic IPs allocated to a Amazon Virtual Private Cloud (Amazon VPC) are attached to Amazon Elastic Compute Cloud (Amazon EC2) instances or in-use Elastic Network Interfaces."
  sql           = query.vpc_eip_associated.sql

  tags = merge(local.vpc_compliance_common_tags, {
    nist_csf = "true"
    pci      = "true"
  })
}

control "vpc_flow_logs_enabled" {
  title       = "VPC flow logs should be enabled"
  description = "The VPC flow logs provide detailed records for information about the IP traffic going to and from network interfaces in your Amazon Virtual Private Cloud (Amazon VPC."
  sql           = query.vpc_flow_logs_enabled.sql

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
    cis                       = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
    soc_2                     = "true"
  })
}

control "vpc_igw_attached_to_authorized_vpc" {
  title       = "VPC internet gateways should be attached to authorized vpc"
  description = "Manage access to resources in the AWS Cloud by ensuring that internet gateways are only attached to authorized Amazon Virtual Private Cloud (Amazon VPC)."
  sql           = query.vpc_igw_attached_to_authorized_vpc.sql

  tags = merge(local.vpc_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "vpc_network_acl_unused" {
  title         = "Unused network access control lists should be removed"
  description   = "This control checks whether there are any unused network access control lists (ACLs). The control checks the item configuration of the resource AWS::EC2::NetworkAcl and determines the relationships of the network ACL."
  sql           = query.vpc_network_acl_unused.sql

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "vpc_security_group_associated_to_eni" {
  title       = "VPC security groups should be associated with at least one ENI"
  description = "This rule ensures the security groups are attached to an Amazon Elastic Compute Cloud (Amazon EC2) instance or to an ENI. This rule helps monitoring unused security groups in the inventory and the management of your environment."
  sql           = query.vpc_security_group_associated_to_eni.sql

  tags = merge(local.vpc_compliance_common_tags, {
    nist_csf = "true"
  })
}

control "vpc_security_group_description_for_rules" {
  title         = "VPC security group should have description for rules"
  description   = "One of the best practices when creating security groups in AWS is to add a description to the group for better clarity."
  sql           = query.vpc_security_group_description_for_rules.sql

  tags = local.vpc_compliance_common_tags
}

control "vpc_security_group_rule_description_for_rules" {
  title         = "VPC security group rule should have description for rules"
  description   = "One of the best practices when creating security groups rule in AWS is to add a description to the group and each of its rules for better clarity."
  sql           = query.vpc_security_group_rule_description_for_rules.sql

  tags = local.vpc_compliance_common_tags
}

control "vpc_subnet_auto_assign_public_ip_disabled" {
  title       = "VPC subnet auto assign public IP should be disabled"
  description = "Ensure if Amazon Virtual Private Cloud (Amazon VPC) subnets are assigned a public IP address. The control is complaint if Amazon VPC does not have subnets that are assigned a public IP address."
  sql           = query.vpc_subnet_auto_assign_public_ip_disabled.sql

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
  })
}