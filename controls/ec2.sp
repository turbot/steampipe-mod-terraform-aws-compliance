locals {
  ec2_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ec2"
  })
}

benchmark "ec2" {
  title         = "EC2"
  children = [
    control.ec2_classic_lb_connection_draining_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.ec2_instance_detailed_monitoring_enabled,
    control.ec2_instance_ebs_optimized,
    control.ec2_instance_not_publicly_accessible,
    control.ec2_instance_not_use_multiple_enis,
    control.ec2_instance_termination_protection_enabled,
    control.ec2_instance_uses_imdsv2
  ]
  tags          = local.ec2_compliance_common_tags
}

control "ec2_classic_lb_connection_draining_enabled" {
  title         = "Classic Load Balancers should have connection draining enabled"
  description   = "This control checks whether Classic Load Balancers have connection draining enabled."
  sql           = query.ec2_classic_lb_connection_draining_enabled.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_ebs_default_encryption_enabled" {
  title         = "EBS default encryption should be enabled"
  description   = "To help protect data at rest, ensure that encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ec2_ebs_default_encryption_enabled.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_detailed_monitoring_enabled" {
  title         = "EC2 instance detailed monitoring should be enabled"
  description   = "Enable this rule to help improve Amazon Elastic Compute Cloud (Amazon EC2) instance monitoring on the Amazon EC2 console, which displays monitoring graphs with a 1-minute period for the instance."
  sql           = query.ec2_instance_detailed_monitoring_enabled.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_ebs_optimized" {
  title         = "EC2 instance should have EBS optimization enabled"
  description   = "An optimized instance in Amazon Elastic Block Store (Amazon EBS) provides additional, dedicated capacity for Amazon EBS I/O operations."
  sql           = query.ec2_instance_ebs_optimized.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_not_publicly_accessible" {
  title         = "EC2 instances should not have a public IP address"
  description   = "Manage access to the AWS Cloud by ensuring Amazon Elastic Compute Cloud (Amazon EC2) instances cannot be publicly accessed."
  sql           = query.ec2_instance_not_publicly_accessible.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_not_use_multiple_enis" {
  title         = "EC2 instances should not use multiple ENIs"
  description   = "This control checks whether an EC2 instance uses multiple Elastic Network Interfaces (ENIs) or Elastic Fabric Adapters (EFAs). This control passes if a single network adapter is used. The control includes an optional parameter list to identify the allowed ENIs."
  sql           = query.ec2_instance_not_use_multiple_enis.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_termination_protection_enabled" {
  title         = "EC2 instances termination protection should be enabled"
  description   = "To prevent your instance from being accidentally terminated using Amazon EC2, you can enable termination protection for the instance."
  sql           = query.ec2_instance_termination_protection_enabled.sql

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_uses_imdsv2" {
  title         = "EC2 instances should use IMDSv2"
  description   = "Ensure the Instance Metadata Service Version 2 (IMDSv2) method is enabled to help protect access and control of Amazon Elastic Compute Cloud (Amazon EC2) instance metadata."
  sql           = query.ec2_instance_uses_imdsv2.sql

  tags = local.ec2_compliance_common_tags
}

#control "review_ec2_instance_in_vpc" {
  #title         = "EC2 instances should be in a VPC"
  #description   = "Deploy Amazon Elastic Compute Cloud (Amazon EC2) instances within an Amazon #Virtual Private Cloud (Amazon VPC) to enable secure communication between an instance and other #services within the amazon VPC, without requiring an internet gateway, NAT device, or VPN #connection."
  #sql           = query.review_ec2_instance_in_vpc.sql

  #tags = local.ec2_compliance_common_tags
#}

