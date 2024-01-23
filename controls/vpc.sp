locals {
  vpc_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/VPC"
  })
}

benchmark "vpc" {
  title       = "VPC"
  description = "This benchmark provides a set of controls that detect Terraform AWS VPC resources deviating from security best practices."

  children = [
    control.vpc_default_security_group_restricts_all_traffic,
    control.vpc_ec2_transit_gateway_auto_accept_attachment_requests_disabled,
    control.vpc_eip_associated,
    control.vpc_endpoint_service_acceptance_enabled,
    control.vpc_flow_logs_enabled,
    control.vpc_igw_attached_to_authorized_vpc,
    control.vpc_network_acl_allow_ftp_port_20_ingress,
    control.vpc_network_acl_allow_ftp_port_21_ingress,
    control.vpc_network_acl_allow_rdp_port_3389_ingress,
    control.vpc_network_acl_allow_ssh_port_22_ingress,
    control.vpc_network_acl_rule_restrict_ingress_ports_all,
    control.vpc_network_acl_unused,
    control.vpc_network_firewall_deletion_protection_enabled,
    control.vpc_network_firewall_encrypted_with_kms_cmk,
    control.vpc_network_firewall_policy_encrypted_with_kms_cmk,
    control.vpc_network_firewall_rule_group_encrypted_with_kms_cmk,
    control.vpc_security_group_associated_to_eni,
    control.vpc_security_group_description_for_rules,
    control.vpc_security_group_restrict_ingress_rdp_all,
    control.vpc_security_group_restrict_ingress_ssh_all,
    control.vpc_security_group_rule_description_for_rules,
    control.vpc_subnet_auto_assign_public_ip_disabled,
    control.vpc_transfer_server_allows_only_secure_protocols,
    control.vpc_transfer_server_not_publicly_accesible
  ]

  tags = merge(local.vpc_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "vpc_default_security_group_restricts_all_traffic" {
  title       = "VPC default security group should not allow inbound and outbound traffic"
  description = "Amazon Elastic Compute Cloud (Amazon EC2) security groups can help in the management of network access by providing stateful filtering of ingress and egress network traffic to AWS resources."
  query       = query.vpc_default_security_group_restricts_all_traffic

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
  description = "This rule ensures Elastic IPs allocated to an Amazon Virtual Private Cloud (Amazon VPC) are attached to Amazon Elastic Compute Cloud (Amazon EC2) instances or in-use Elastic Network Interfaces."
  query       = query.vpc_eip_associated

  tags = merge(local.vpc_compliance_common_tags, {
    nist_csf = "true"
    pci      = "true"
  })
}

control "vpc_flow_logs_enabled" {
  title       = "VPC flow logs should be enabled"
  description = "The VPC flow logs provide detailed records for information about the IP traffic going to and from network interfaces in your Amazon Virtual Private Cloud (Amazon VPC."
  query       = query.vpc_flow_logs_enabled

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
  title       = "VPC internet gateways should be attached to authorized VPC"
  description = "Manage access to resources in the AWS Cloud by ensuring that internet gateways are only attached to authorized Amazon Virtual Private Cloud (Amazon VPC)."
  query       = query.vpc_igw_attached_to_authorized_vpc

  tags = merge(local.vpc_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "vpc_network_acl_unused" {
  title       = "Unused network access control lists should be removed"
  description = "This control checks whether there are any unused network access control lists (ACLs). The control checks the item configuration of the resource AWS::EC2::NetworkAcl and determines the relationships of the network ACL."
  query       = query.vpc_network_acl_unused

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "vpc_security_group_associated_to_eni" {
  title       = "VPC security groups should be associated with at least one ENI"
  description = "This rule ensures the security groups are attached to an Amazon Elastic Compute Cloud (Amazon EC2) instance or to an ENI. This rule helps monitor unused security groups in the inventory and the management of your environment."
  query       = query.vpc_security_group_associated_to_eni

  tags = merge(local.vpc_compliance_common_tags, {
    nist_csf = "true"
  })
}

control "vpc_security_group_description_for_rules" {
  title       = "VPC security group should have description for rules"
  description = "One of the best practices when creating security groups in AWS is to add a description to the group for better clarity."
  query       = query.vpc_security_group_description_for_rules

  tags = local.vpc_compliance_common_tags
}

control "vpc_security_group_rule_description_for_rules" {
  title       = "VPC security group rule should have description for rules"
  description = "One of the best practices when creating security group rules in AWS is to add a description to the group and each of its rules for better clarity."
  query       = query.vpc_security_group_rule_description_for_rules

  tags = local.vpc_compliance_common_tags
}

control "vpc_subnet_auto_assign_public_ip_disabled" {
  title       = "VPC subnet auto-assign public IP should be disabled"
  description = "Ensure that Amazon Virtual Private Cloud (Amazon VPC) subnets are assigned a public IP address. The control is complaint if Amazon VPC does not have subnets that are assigned a public IP address."
  query       = query.vpc_subnet_auto_assign_public_ip_disabled

  tags = merge(local.vpc_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
  })
}

control "vpc_transfer_server_not_publicly_accesible" {
  title       = "VPC transfer server should not be publicly accessible"
  description = "This control checks whether the VPC transfer server is not publicly accessible."
  query       = query.vpc_transfer_server_not_publicly_accesible

  tags = local.vpc_compliance_common_tags
}

control "vpc_endpoint_service_acceptance_enabled" {
  title       = "VPC endpoint service acceptance should be enabled"
  description = "This control checks whether the VPC endpoint service acceptance is enabled for manual acceptance."
  query       = query.vpc_endpoint_service_acceptance_enabled

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_firewall_encrypted_with_kms_cmk" {
  title       = "VPC network firewall should be encrypted with KMS CMK"
  description = "This control checks whether the Network Firewall is encrypted with KMS CMK."
  query       = query.vpc_network_firewall_encrypted_with_kms_cmk

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_firewall_rule_group_encrypted_with_kms_cmk" {
  title       = "VPC network firewall rule group should be encrypted with KMS CMK"
  description = "This control checks whether the Network Firewall Rule Group is encrypted with KMS CMK."
  query       = query.vpc_network_firewall_rule_group_encrypted_with_kms_cmk

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_firewall_policy_encrypted_with_kms_cmk" {
  title       = "VPC network firewall policy should define a encryption configuration that uses KMS CMK"
  description = "This control checks whether the Network Firewall Policy is encrypted with KMS CMK."
  query       = query.vpc_network_firewall_policy_encrypted_with_kms_cmk

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_firewall_deletion_protection_enabled" {
  title       = "VPC network firewall should have deletion protection enabled"
  description = "This control checks whether the Network Firewall has deletion protection enabled."
  query       = query.vpc_network_firewall_deletion_protection_enabled

  tags = local.vpc_compliance_common_tags
}

control "vpc_ec2_transit_gateway_auto_accept_attachment_requests_disabled" {
  title       = "VPC EC2 transit gateway should not automatically accept VPC attachment requests"
  description = "This control checks whether the EC2 Transit Gateway has auto-accept attachment requests disabled."
  query       = query.vpc_ec2_transit_gateway_auto_accept_attachment_requests_disabled

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_acl_allow_ftp_port_20_ingress" {
  title       = "Network ACL should not allow unrestricted FTP port 20 access"
  description = "This control checks whether the Network ACL allows unrestricted ingress on FTP port 20."
  query       = query.vpc_network_acl_allow_ftp_port_20_ingress

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_acl_allow_ftp_port_21_ingress" {
  title       = "Network ACL should not allow unrestricted FTP port 21 access"
  description = "This control checks whether the Network ACL allows unrestricted ingress on FTP port 21."
  query       = query.vpc_network_acl_allow_ftp_port_21_ingress

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_acl_allow_ssh_port_22_ingress" {
  title       = "Network ACL should not allow unrestricted SSH port 22 access"
  description = "This control checks whether the Network ACL allows unrestricted ingress on SSH port 22."
  query       = query.vpc_network_acl_allow_ssh_port_22_ingress

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_acl_allow_rdp_port_3389_ingress" {
  title       = "Network ACL should not allow unrestricted RDP port 3389 access"
  description = "This control checks whether the Network ACL allows unrestricted ingress on RDP port 3389."
  query       = query.vpc_network_acl_allow_rdp_port_3389_ingress

  tags = local.vpc_compliance_common_tags
}

control "vpc_network_acl_rule_restrict_ingress_ports_all" {
  title       = "Network ACL ingress rule should not allow access to all ports"
  description = "This control checks whether the Network ACL ingress rule does not allow access to all ports."
  query       = query.vpc_network_acl_rule_restrict_ingress_ports_all

  tags = local.vpc_compliance_common_tags
}

control "vpc_transfer_server_allows_only_secure_protocols" {
  title       = "VPC transfer server should allow only secure protocols"
  description = "This control checks whether the VPC transfer server allows only secure protocols."
  query       = query.vpc_transfer_server_allows_only_secure_protocols

  tags = local.vpc_compliance_common_tags
}

control "vpc_security_group_restrict_ingress_rdp_all" {
  title       = "Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389"
  description = "Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. It is recommended that no security group allows unrestricted ingress access to port 3389."
  query       = query.vpc_security_group_restrict_ingress_rdp_all

  tags = local.vpc_compliance_common_tags
}

control "vpc_security_group_restrict_ingress_ssh_all" {
  title       = "VPC security groups should restrict ingress SSH access from 0.0.0.0/0"
  description = "AWS Elastic Compute Cloud (AWS EC2) Security Groups can help manage network access by providing stateful filtering of ingress and egress network traffic to AWS resources. It is recommended that no security group allows unrestricted SSH access from 0.0.0.0/0."
  query       = query.vpc_security_group_restrict_ingress_ssh_all

  tags = local.vpc_compliance_common_tags
}
