locals {
  glacier_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Glacier"
  })
}

benchmark "glacier" {
  title       = "Glacier"
  description = "This benchmark provides a set of controls that detect Terraform AWS Glacier resources deviating from security best practices."

  children = [
    control.glacier_vault_restrict_public_access
  ]

  tags = merge(local.glacier_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "glacier_vault_restrict_public_access" {
  title       = "Glacier vault should restrict public access"
  description = "Manage access to resources in the AWS Cloud by ensuring AWS Glacier vault cannot be publicly accessed."
  query       = query.glacier_vault_restrict_public_access

  tags = local.glacier_compliance_common_tags
}


