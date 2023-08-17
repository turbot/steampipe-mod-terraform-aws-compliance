locals {
  codepipeline_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CodePipeline"
  })
}

benchmark "codepipeline" {
  title       = "CodePipeline"
  description = "This benchmark provides a set of controls that detect Terraform AWS CodePipeline resources deviating from security best practices."

  children = [
    control.codepipeline_artifacts_encrypted_with_kms_cmk
  ]

  tags = merge(local.codepipeline_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "codepipeline_artifacts_encrypted_with_kms_cmk" {
  title       = "CodePipeline Artifacts encrypted with KMS CMK"
  description = "This control checks whether the CodePipeline Artifacts are encrypted."
  query       = query.codepipeline_artifacts_encrypted_with_kms_cmk

  tags = local.codepipeline_compliance_common_tags
}
