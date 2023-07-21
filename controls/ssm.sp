locals {
  ssm_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/SSM"
  })
}

benchmark "ssm" {
  title       = "SSM"
  description = "This benchmark provides a set of controls that detect Terraform AWS SSM resources deviating from security best practices."

  children = [
    control.ssm_document_prohibit_public_access,
    control.ssm_parameter_encrypted_with_kms_cmk
  ]

  tags = merge(local.ssm_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ssm_document_prohibit_public_access" {
  title       = "SSM documents should not be public"
  description = "This control checks whether AWS Systems Manager documents that are owned by the account are public. This control fails if SSM documents with the owner Self are public."
  query       = query.ssm_document_prohibit_public_access

  tags = local.ssm_compliance_common_tags

}

control "ssm_parameter_encrypted_with_kms_cmk" {
  title       = "SSM parameter should be encypted using KMS CMKs"
  description = "To help protect data at rest, ensure encryption is enabled for your SSM parameter using KMS."
  query       = query.ssm_parameter_encrypted_with_kms_cmk

  tags = local.ssm_compliance_common_tags
}
