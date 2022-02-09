locals {
  ec2_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ec2"
  })
}

benchmark "ec2" {
  title       = "EC2"
  description = "This benchmark provides a set of controls that detect Terraform AWS EC2 resources deviating from security best practices."

  children = [
    control.ec2_ebs_default_encryption_enabled,
    control.ec2_instance_detailed_monitoring_enabled,
    control.ec2_instance_ebs_optimized,
    control.ec2_instance_not_publicly_accessible,
    control.ec2_instance_not_use_default_vpc,
    control.ec2_instance_not_use_multiple_enis,
    control.ec2_instance_termination_protection_enabled,
    control.ec2_instance_uses_imdsv2
  ]
  tags  = local.ec2_compliance_common_tags
}

control "ec2_ebs_default_encryption_enabled" {
  title         = "EBS default encryption should be enabled"
  description   = "To help protect data at rest, ensure that encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  sql           = query.ec2_ebs_default_encryption_enabled.sql

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
  })
}

control "ec2_instance_not_use_default_vpc" {
  title         = "Ensure EC2 instances do not use default VPC"
  description   = "One of the best practices when using EC2s in AWS is not to deploy any resources to the default VPC."
  sql           = query.ec2_instance_not_use_default_vpc.sql

  tags  = local.ec2_compliance_common_tags
}

control "ec2_instance_detailed_monitoring_enabled" {
  title         = "EC2 instance detailed monitoring should be enabled"
  description   = "Enable this rule to help improve Amazon Elastic Compute Cloud (Amazon EC2) instance monitoring on the Amazon EC2 console, which displays monitoring graphs with a one minute period for the instance."
  sql           = query.ec2_instance_detailed_monitoring_enabled.sql

  tags = merge(local.ec2_compliance_common_tags, {
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
    soc_2             = "true"
  })
}

control "ec2_instance_ebs_optimized" {
  title         = "EC2 instance should have EBS optimization enabled"
  description   = "An optimized instance in Amazon Elastic Block Store (Amazon EBS) provides additional, dedicated capacity for Amazon EBS I/O operations."
  sql           = query.ec2_instance_ebs_optimized.sql

  tags = merge(local.ec2_compliance_common_tags, {
    hipaa                       = "true"
    nist_csf                    = "true"
    soc_2                       = "true"
  })
}

control "ec2_instance_not_publicly_accessible" {
  title         = "EC2 instances should not have a public IP address"
  description   = "Manage access to the AWS Cloud by ensuring Amazon Elastic Compute Cloud (Amazon EC2) instances cannot be publicly accessed."
  sql           = query.ec2_instance_not_publicly_accessible.sql

  tags = merge(local.ec2_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "ec2_instance_not_use_multiple_enis" {
  title         = "EC2 instances should not use multiple ENIs"
  description   = "This control checks whether an EC2 instance uses multiple Elastic Network Interfaces (ENIs) or Elastic Fabric Adapters (EFAs). This control passes if a single network adapter is used. The control includes an optional parameter list to identify the allowed ENIs."
  sql           = query.ec2_instance_not_use_multiple_enis.sql

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
  })
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

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_800_53_rev_4         = "true"
  })
}