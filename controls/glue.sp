locals {
  glue_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Glue"
  })
}

benchmark "glue" {
  title       = "Glue"
  description = "This benchmark provides a set of controls that detect Terraform AWS Glue resources deviating from security best practices."

  children = [
    control.glue_crawler_security_configuration_enabled,
    control.glue_dev_endpoint_security_configuration_enabled,
    control.glue_job_security_configuration_enabled
  ]

  tags = merge(local.glue_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "glue_crawler_security_configuration_enabled" {
  title       = "Glue crawler security configuration should be enabled"
  description = "This control checks whether the security configuration is enabled for the Glue crawler."
  query       = query.glue_crawler_security_configuration_enabled

  tags = local.glue_compliance_common_tags
}

control "glue_dev_endpoint_security_configuration_enabled" {
  title       = "Glue dev endpoint security configuration should be enabled"
  description = "This control checks whether the security configuration is enabled for the Glue dev endpoint."
  query       = query.glue_dev_endpoint_security_configuration_enabled

  tags = local.glue_compliance_common_tags
}

control "glue_job_security_configuration_enabled" {
  title       = "Glue job security configuration should be enabled"
  description = "This control checks whether the security configuration is enabled for the Glue job."
  query       = query.glue_job_security_configuration_enabled

  tags = local.glue_compliance_common_tags
}
