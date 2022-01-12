locals {
  codebuild_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "codebuild"
  })
}

benchmark "codebuild" {
  title         = "CodeBuild"
  children = [
    control.codebuild_project_plaintext_env_variables_no_sensitive_aws_values,
    control.codebuild_project_source_repo_oauth_configured
  ]
  tags          = local.codebuild_compliance_common_tags
}
