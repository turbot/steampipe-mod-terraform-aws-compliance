locals {
  sagemaker_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sagemaker"
  })
}

benchmark "sagemaker" {
  title    = "SageMaker"
  children = [
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_direct_internet_access_disabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled
  ]
  tags          = local.sagemaker_compliance_common_tags
}
