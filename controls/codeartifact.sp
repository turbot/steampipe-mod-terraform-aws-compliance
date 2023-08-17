locals {
  codeartifact_domain_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CodeArtifactDomain"
  })
}

benchmark "codeartifact_domain" {
  title       = "CodeArtifactDomain"
  description = "This benchmark provides a set of controls that detect Terraform AWS CodeArtifactDomain resources deviating from security best practices."

  children = [
    control.codeartifact_domain_encrypted_with_kms_cmk
  ]

  tags = merge(local.codeartifact_domain_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "codeartifact_domain_encrypted_with_kms_cmk" {
  title       = "CodeArtifact Domain should be encrypted with KMS CMK"
  description = "This control checks whether CodeArtifact Domain is encrypted with KMS CMK."
  query       = query.codeartifact_domain_encrypted_with_kms_cmk

  tags = local.codeartifact_domain_compliance_common_tags
}
