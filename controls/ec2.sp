locals {
  ec2_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EC2"
  })
}

benchmark "ec2" {
  title       = "EC2"
  description = "This benchmark provides a set of controls that detect Terraform AWS EC2 resources deviating from security best practices."

  children = [
    control.ec2_ami_copy_encrypted_with_kms_cmk,
    control.ec2_ami_copy_encryption_enabled,
    control.ec2_ami_encryption_enabled,
    control.ec2_ami_imagebuilder_component_encrypted_with_kms_cmk,
    control.ec2_ami_imagebuilder_distribution_configuration_encrypted_with_kms_cmk,
    control.ec2_ami_imagebuilder_image_recipe_encrypted_with_kms_cmk,
    control.ec2_ebs_default_encryption_enabled,
    control.ec2_instance_detailed_monitoring_enabled,
    control.ec2_instance_ebs_encryption_check,
    control.ec2_instance_ebs_optimized,
    control.ec2_instance_not_publicly_accessible,
    control.ec2_instance_not_use_default_vpc,
    control.ec2_instance_not_use_multiple_enis,
    control.ec2_instance_termination_protection_enabled,
    control.ec2_instance_user_data_no_secrets,
    control.ec2_instance_uses_imdsv2,
    control.ec2_launch_configuration_ebs_encryption_check,
    control.ec2_launch_configuration_metadata_hop_limit_check,
    control.ec2_launch_template_metadata_hop_limit_check
  ]

  tags = merge(local.ec2_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ec2_ebs_default_encryption_enabled" {
  title       = "EBS default encryption should be enabled"
  description = "To help protect data at rest, ensure that encryption is enabled for your Amazon Elastic Block Store (Amazon EBS) volumes."
  query       = query.ec2_ebs_default_encryption_enabled

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
  })
}

control "ec2_instance_not_use_default_vpc" {
  title       = "Ensure EC2 instances do not use default VPC"
  description = "One of the best practices when using EC2s in AWS is not to deploy any resources to the default VPC."
  query       = query.ec2_instance_not_use_default_vpc

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_detailed_monitoring_enabled" {
  title       = "EC2 instance detailed monitoring should be enabled"
  description = "Enable this rule to help improve Amazon Elastic Compute Cloud (Amazon EC2) instance monitoring on the Amazon EC2 console, which displays monitoring graphs with a one minute period for the instance."
  query       = query.ec2_instance_detailed_monitoring_enabled

  tags = merge(local.ec2_compliance_common_tags, {
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
    soc_2             = "true"
  })
}

control "ec2_instance_ebs_optimized" {
  title       = "EC2 instance should have EBS optimization enabled"
  description = "An optimized instance in Amazon Elastic Block Store (Amazon EBS) provides additional, dedicated capacity for Amazon EBS I/O operations."
  query       = query.ec2_instance_ebs_optimized

  tags = merge(local.ec2_compliance_common_tags, {
    hipaa    = "true"
    nist_csf = "true"
    soc_2    = "true"
  })
}

control "ec2_instance_not_publicly_accessible" {
  title       = "EC2 instances should not have a public IP address"
  description = "Manage access to the AWS Cloud by ensuring Amazon Elastic Compute Cloud (Amazon EC2) instances cannot be publicly accessed."
  query       = query.ec2_instance_not_publicly_accessible

  tags = merge(local.ec2_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "ec2_instance_not_use_multiple_enis" {
  title       = "EC2 instances should not use multiple ENIs"
  description = "This control checks whether an EC2 instance uses multiple Elastic Network Interfaces (ENIs) or Elastic Fabric Adapters (EFAs). This control passes if a single network adapter is used. The control includes an optional parameter list to identify the allowed ENIs."
  query       = query.ec2_instance_not_use_multiple_enis

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "ec2_instance_termination_protection_enabled" {
  title       = "EC2 instances termination protection should be enabled"
  description = "To prevent your instance from being accidentally terminated using Amazon EC2, you can enable termination protection for the instance."
  query       = query.ec2_instance_termination_protection_enabled

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_uses_imdsv2" {
  title       = "EC2 instances should use IMDSv2"
  description = "Ensure the Instance Metadata Service Version 2 (IMDSv2) method is enabled to help protect access and control of Amazon Elastic Compute Cloud (Amazon EC2) instance metadata."
  query       = query.ec2_instance_uses_imdsv2

  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_800_53_rev_4         = "true"
  })
}

control "ec2_instance_user_data_no_secrets" {
  title       = "EC2 instances should not contain secrets in user data"
  description = "To help protect sensitive information, ensure that Amazon Elastic Compute Cloud (Amazon EC2) instances do not contain secrets in user data."
  query       = query.ec2_instance_user_data_no_secrets

  tags = merge(local.ec2_compliance_common_tags, {
    other_checks = "true"
  })
}

control "ec2_ami_imagebuilder_component_encrypted_with_kms_cmk" {
  title       = "EC2 AMI image builder components should be encrypted with KMS CMK"
  description = "This control checks whether EC2 AMI image builder components are encrypted with a KMS CMK."
  query       = query.ec2_ami_imagebuilder_component_encrypted_with_kms_cmk

  tags = local.ec2_compliance_common_tags
}

control "ec2_ami_imagebuilder_distribution_configuration_encrypted_with_kms_cmk" {
  title       = "EC2 AMI image builder distribution configurations should be encrypted with KMS CMK"
  description = "This control checks whether EC2 AMI image builder distribution configurations are encrypted with a KMS CMK."
  query       = query.ec2_ami_imagebuilder_distribution_configuration_encrypted_with_kms_cmk

  tags = local.ec2_compliance_common_tags
}

control "ec2_ami_imagebuilder_image_recipe_encrypted_with_kms_cmk" {
  title       = "EC2 AMI image builder image recipes should be encrypted with KMS CMK"
  description = "This control checks whether EC2 AMI image builder image recipes are encrypted with a KMS CMK."
  query       = query.ec2_ami_imagebuilder_image_recipe_encrypted_with_kms_cmk

  tags = local.ec2_compliance_common_tags
}

control "ec2_launch_template_metadata_hop_limit_check" {
  title       = "EC2 launch template should not have a metadata response hop limit greater than 1"
  description = "This control checks whether EC2 launch templates have a metadata response hop limit less than 1."
  query       = query.ec2_launch_template_metadata_hop_limit_check

  tags = local.ec2_compliance_common_tags
}

control "ec2_launch_configuration_metadata_hop_limit_check" {
  title       = "EC2 launch configuration should not have a metadata response hop limit greater than 1"
  description = "This control checks whether EC2 launch configurations have a metadata response hop limit less than 1."
  query       = query.ec2_launch_configuration_metadata_hop_limit_check


  tags = merge(local.ec2_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_800_53_rev_4         = "true"
  })
}

control "ec2_launch_configuration_ebs_encryption_check" {
  title       = "EC2 launch configuration EBS encryption should be enabled"
  description = "This control checks whether EC2 launch configurations have EBS encryption enabled."
  query       = query.ec2_launch_configuration_ebs_encryption_check

  tags = local.ec2_compliance_common_tags
}

control "ec2_instance_ebs_encryption_check" {
  title       = "EC2 instance EBS encryption should be enabled"
  description = "This control checks whether EC2 instances have EBS encryption enabled."
  query       = query.ec2_instance_ebs_encryption_check

  tags = local.ec2_compliance_common_tags
}

control "ec2_ami_copy_encryption_enabled" {
  title       = "EC2 AMI copy should be encrypted"
  description = "This control checks whether EC2 AMI copy has encryption enabled."
  query       = query.ec2_ami_copy_encryption_enabled

  tags = local.ec2_compliance_common_tags
}

control "ec2_ami_copy_encrypted_with_kms_cmk" {
  title       = "EC2 AMI copy should be encrypted with KMS CMK"
  description = "This control checks whether EC2 AMI copy is encrypted with a KMS CMK."
  query       = query.ec2_ami_copy_encrypted_with_kms_cmk

  tags = local.ec2_compliance_common_tags
}

control "ec2_ami_encryption_enabled" {
  title       = "EC2 AMI should be encrypted"
  description = "This control checks whether EC2 AMI has encryption enabled."
  query       = query.ec2_ami_encryption_enabled

  tags = local.ec2_compliance_common_tags
}
