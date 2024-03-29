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
    control.athena_workgroup_encryption_at_rest_enabled,
    control.athena_workgroup_enforce_workgroup_configuration
  ]

  tags = merge(local.athena_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "athena_database_encryption_at_rest_enabled" {
  title       = "Athena database encryption at rest should be enabled"
  description = "Ensure Athena database is encrypted at rest to protect sensitive data."
  query       = query.athena_database_encryption_at_rest_enabled

  tags = local.athena_compliance_common_tags

}

control "athena_workgroup_encryption_at_rest_enabled" {
  title       = "Athena workgroup encryption at rest should be enabled"
  description = "Ensure Athena workgroup is encrypted at rest to protect sensitive data."
  query       = query.athena_workgroup_encryption_at_rest_enabled

  tags = local.athena_compliance_common_tags

}

control "athena_workgroup_enforce_workgroup_configuration" {
  title       = "Athena workgroup configuration should be enforced"
  description = "This control checks whether Athena Workgroup should enforce configuration to prevent client disabling encryption."
  query       = query.athena_workgroup_enforce_workgroup_configuration

  tags = local.athena_compliance_common_tags

}
