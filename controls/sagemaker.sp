locals {
  sagemaker_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/SageMaker"
  })
}

benchmark "sagemaker" {
  title       = "SageMaker"
  description = "This benchmark provides a set of controls that detect Terraform AWS SageMaker resources deviating from security best practices."

  children = [
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_direct_internet_access_disabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_in_vpc,
    control.sagemaker_notebook_instance_root_access_disabled,
    control.sagemaker_domain_encrypted_with_kms_cmk
  ]

  tags = merge(local.sagemaker_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "sagemaker_endpoint_configuration_encryption_at_rest_enabled" {
  title       = "SageMaker endpoint configuration encryption should be enabled"
  description = "To help protect data at rest, ensure encryption with AWS Key Management Service (AWS KMS) is enabled for your SageMaker endpoint."
  query       = query.sagemaker_endpoint_configuration_encryption_at_rest_enabled

  tags = merge(local.sagemaker_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "sagemaker_notebook_instance_direct_internet_access_disabled" {
  title       = "SageMaker notebook instances should not have direct internet access"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon SageMaker notebooks do not allow direct internet access."
  query       = query.sagemaker_notebook_instance_direct_internet_access_disabled

  tags = merge(local.sagemaker_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "sagemaker_notebook_instance_encryption_at_rest_enabled" {
  title       = "SageMaker notebook instance encryption should be enabled"
  description = "To help protect data at rest, ensure encryption with AWS Key Management Service (AWS KMS) is enabled for your SageMaker notebook."
  query       = query.sagemaker_notebook_instance_encryption_at_rest_enabled

  tags = merge(local.sagemaker_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "sagemaker_notebook_instance_in_vpc" {
  title       = "SageMaker notebook instances should be in a VPC"
  description = "Manage access to the AWS Cloud by ensuring SageMaker notebook instances are within an Amazon Virtual Private Cloud (Amazon VPC)."
  query       = query.sagemaker_notebook_instance_in_vpc

  tags = local.sagemaker_compliance_common_tags
}

control "sagemaker_notebook_instance_root_access_disabled" {
  title       = "SageMaker notebook instances root access should be disabled"
  description = "Users with root access have administrator privileges and users can access and edit all files on a notebook instance. It is recommeneded to disable root access to restrict users from accessing and editing all the files."
  query       = query.sagemaker_notebook_instance_root_access_disabled

  tags = local.sagemaker_compliance_common_tags
}

control "sagemaker_domain_encrypted_with_kms_cmk" {
  title       = "SageMaker domain should be encypted using KMS CMKs"
  description = "To help protect data at rest, ensure encryption is enabled for your SageMaker domain using KMS."
  query       = query.sagemaker_domain_encrypted_with_kms_cmk

  tags = local.sagemaker_compliance_common_tags
}