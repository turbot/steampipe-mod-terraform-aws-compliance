locals {
  workspace_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/WorkSpaces"
  })
}

benchmark "workspace" {
  title       = "WorkSpaces"
  description = "This benchmark provides a set of controls that detect Terraform AWS WorkSpaces resources deviating from security best practices."

  children = [
    control.workspace_root_volume_encryption_at_rest_enabled,
    control.workspace_user_volume_encryption_at_rest_enabled
  ]

  tags = merge(local.workspace_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "workspace_root_volume_encryption_at_rest_enabled" {
  title       = "AWS workspaces root volume should be encrypted at rest"
  description = "Ensure Workspaces being created are set to encrypt root volume at rest."
  sql           = query.workspace_root_volume_encryption_at_rest_enabled.sql

  tags = local.workspace_compliance_common_tags

}

control "workspace_user_volume_encryption_at_rest_enabled" {
  title       = "AWS workspaces user volume should be encrypted at rest"
  description = "Ensure Workspaces being created are set to encrypt user volume at rest."
  sql           = query.workspace_user_volume_encryption_at_rest_enabled.sql

  tags = local.workspace_compliance_common_tags

}
