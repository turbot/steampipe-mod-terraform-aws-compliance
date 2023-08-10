locals {
  appflow_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/AppFlow"
  })
}

benchmark "appflow" {
  title       = "AppFlow"
  description = "This benchmark provides a set of controls that detect Terraform AWS AppFlow resources deviating from security best practices."

  children = [
    control.appflow_connector_profile_encrypted_with_kms_cmk,
    control.appflow_flow_encrypted_with_kms_cmk
  ]

  tags = merge(local.appflow_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "appflow_flow_encrypted_with_kms_cmk" {
  title       = "AppFlow should be encrypted with KMS CMK"
  description = "This control checks whether AppFlow is encrypted with KMS CMK."
  query       = query.appflow_flow_encrypted_with_kms_cmk

  tags = local.appflow_compliance_common_tags
}

control "appflow_connector_profile_encrypted_with_kms_cmk" {
  title       = "AppFlow Connector Profile should be encrypted with KMS CMK"
  description = "This control checks whether AppFlow Connector Profile is encrypted with KMS CMK."
  query       = query.appflow_connector_profile_encrypted_with_kms_cmk

  tags = local.appflow_compliance_common_tags
}