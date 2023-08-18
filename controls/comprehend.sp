locals {
  comprehend_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Comprehend"
  })
}

benchmark "comprehend" {
  title       = "Comprehend"
  description = "This benchmark provides a set of controls that detect Terraform AWS Comprehend resources deviating from security best practices."

  children = [
    control.comprehend_entity_recognizer_model_encrypted_with_kms_cmk,
    control.comprehend_entity_recognizer_volume_encrypted_with_kms_cmk
  ]

  tags = merge(local.comprehend_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "comprehend_entity_recognizer_volume_encrypted_with_kms_cmk" {
  title       = "Comprehend entity recognizer volume encrypted with KMS CMK"
  description = "This control checks whether AWS Comprehend entity recognizer volumes are encrypted with KMS CMKs."
  query       = query.comprehend_entity_recognizer_volume_encrypted_with_kms_cmk

  tags = local.comprehend_compliance_common_tags
}

control "comprehend_entity_recognizer_model_encrypted_with_kms_cmk" {
  title       = "Comprehend entity recognizer model encrypted with KMS CMK"
  description = "This control checks whether AWS Comprehend entity recognizer models are encrypted with KMS CMKs."
  query       = query.comprehend_entity_recognizer_model_encrypted_with_kms_cmk

  tags = local.comprehend_compliance_common_tags
}
