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
    control.glue_data_catalog_encryption_enabled,
    control.glue_dev_endpoint_security_configuration_enabled,
    control.glue_job_security_configuration_enabled,
    control.glue_security_configuration_encryption_enabled
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


control "glue_data_catalog_encryption_enabled" {
  title       = "Glue data catalog encryption should be enabled"
  description = "This control checks whether data catalog encryption is enabled. This control is non-complaint if data catalog encryption is disabled."
  query       = query.glue_data_catalog_encryption_enabled

  tags = local.glue_compliance_common_tags
}

control "glue_security_configuration_encryption_enabled" {
  title       = "Glue security configuration encryption should be enabled"
  description = "This control checks whether Glue security configuration encryption is enabled. This control is non-complaint if Glue security configuration encryption is disabled."
  query       = query.glue_security_configuration_encryption_enabled

  tags = local.glue_compliance_common_tags
}

