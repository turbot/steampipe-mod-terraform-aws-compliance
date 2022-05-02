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
    control.sagemaker_notebook_instance_encryption_at_rest_enabled
  ]

  tags = merge(local.sagemaker_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "sagemaker_endpoint_configuration_encryption_at_rest_enabled" {
  title       = "SageMaker endpoint configuration encryption should be enabled"
  description = "To help protect data at rest, ensure encryption with AWS Key Management Service (AWS KMS) is enabled for your SageMaker endpoint."
  sql           = query.sagemaker_endpoint_configuration_encryption_at_rest_enabled.sql

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
  sql           = query.sagemaker_notebook_instance_direct_internet_access_disabled.sql

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
  sql           = query.sagemaker_notebook_instance_encryption_at_rest_enabled.sql

  tags = merge(local.sagemaker_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}