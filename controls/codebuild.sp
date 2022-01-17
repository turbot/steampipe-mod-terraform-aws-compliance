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

control "codebuild_project_plaintext_env_variables_no_sensitive_aws_values" {
  title         = "CodeBuild project plaintext environment variables should not contain sensitive AWS values"
  description   = "Ensure authentication credentials AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY do not exist within AWS CodeBuild project environments. Do not store these variables in clear text. Storing these variables in clear text leads to unintended data exposure and unauthorized access."
  sql           = query.codebuild_project_plaintext_env_variables_no_sensitive_aws_values.sql

  tags = local.codebuild_compliance_common_tags
}

control "codebuild_project_source_repo_oauth_configured" {
  title         = "CodeBuild GitHub or Bitbucket source repository URLs should use OAuth"
  description   = "Ensure the GitHub or Bitbucket source repository URL does not contain personal access tokens, user name and password within AWS Codebuild project environments."
  sql           = query.codebuild_project_source_repo_oauth_configured.sql

  tags = local.codebuild_compliance_common_tags
}
