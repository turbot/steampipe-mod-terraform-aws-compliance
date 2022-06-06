locals {
  athena_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Athena"
  })
}

benchmark "athena" {
  title       = "Athena"
  description = "This benchmark provides a set of controls that detect Terraform AWS Athena resources deviating from security best practices."

  children = [
    control.athena_database_encryption_at_rest_enabled,
    control.athena_workgroup_encryption_at_rest_enabled
  ]

  tags = merge(local.athena_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "athena_database_encryption_at_rest_enabled" {
  title       = "Athena database encryption at rest should be enabled"
  description = "Ensure Athena database is encrypted at rest to protect sensitive data."
  sql           = query.athena_database_encryption_at_rest_enabled.sql

  tags = local.athena_compliance_common_tags

}

control "athena_workgroup_encryption_at_rest_enabled" {
  title       = "Athena workgroup encryption at rest should be enabled"
  description = "Ensure Athena workgroup is encrypted at rest to protect sensitive data."
  sql           = query.athena_workgroup_encryption_at_rest_enabled.sql

  tags = local.athena_compliance_common_tags

}
