locals {
  codebuild_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CodeBuild"
  })
}

benchmark "codebuild" {
  title       = "CodeBuild"
  description = "This benchmark provides a set of controls that detect Terraform AWS CodeBuild resources deviating from security best practices."

  children = [
    control.codebuild_project_encryption_at_rest_enabled,
    control.codebuild_project_logging_enabled,
    control.codebuild_project_plaintext_env_variables_no_sensitive_aws_values,
    control.codebuild_project_s3_logs_encryption_enabled,
    control.codebuild_project_source_repo_oauth_configured
  ]

  tags = merge(local.codebuild_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "codebuild_project_plaintext_env_variables_no_sensitive_aws_values" {
  title       = "CodeBuild project plaintext environment variables should not contain sensitive AWS values"
  description = "Ensure authentication credentials AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY do not exist within AWS CodeBuild project environments. Do not store these variables in clear text. Storing these variables in clear text leads to unintended data exposure and unauthorized access."
  query       = query.codebuild_project_plaintext_env_variables_no_sensitive_aws_values

  tags = merge(local.codebuild_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    soc_2                     = "true"
  })
}

control "codebuild_project_source_repo_oauth_configured" {
  title       = "CodeBuild GitHub or Bitbucket source repository URLs should use OAuth"
  description = "Ensure the GitHub or Bitbucket source repository URL does not contain personal access tokens, user name and password within AWS Codebuild project environments."
  query       = query.codebuild_project_source_repo_oauth_configured

  tags = merge(local.codebuild_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    soc_2                     = "true"
  })
}

control "codebuild_project_encryption_at_rest_enabled" {
  title       = "CodeBuild project encryption at rest should be enabled"
  description = "Ensure CodeBuild projects are set to be encrypted at rest with customer-managed CMK to protect sensitive data."
  query       = query.codebuild_project_encryption_at_rest_enabled

  tags = local.codebuild_compliance_common_tags
}

control "codebuild_project_s3_logs_encryption_enabled" {
  title       = "CodeBuild S3 logs encryption should be enabled"
  description = "Ensure that CodeBuild S3 logs are encrypted."
  query       = query.codebuild_project_s3_logs_encryption_enabled

  tags = merge(local.codebuild_compliance_common_tags, {
    aws_foundational_security = "true"
    gxp_21_cfr_part_11        = "true"
    gxp_eu_annex_11           = "true"
    nist_csf                  = "true"
  })
}

control "codebuild_project_logging_enabled" {
  title       = "CodeBuild project environments should have a logging configuration"
  description = "Ensure CodeBuild project environments have a logging configuration."
  query       = query.codebuild_project_logging_enabled

  tags = merge(local.codebuild_compliance_common_tags, {
    aws_foundational_security              = "true"
    hipaa_final_omnibus_security_rule_2013 = "true"
    hipaa_security_rule_2003               = "true"
    nist_csf                               = "true"
  })
}