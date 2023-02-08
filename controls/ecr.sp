locals {
  ecr_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ECR"
  })
}

benchmark "ecr" {
  title       = "ECR"
  description = "This benchmark provides a set of controls that detect Terraform AWS ECR resources deviating from security best practices."

  children = [
    control.ecr_repository_tags_immutable,
    control.ecr_repository_use_image_scanning,
    control.ecr_repository_encrypted_with_kms
  ]

  tags = local.ecr_compliance_common_tags
}

control "ecr_repository_tags_immutable" {
  title       = "ECR repository tags should be immutable"
  description = "AWS ECR should have all tags be immutable - once a container is published, another image cannot assume the same tag."
  query       = query.ecr_repository_tags_immutable

  tags = merge(local.ecr_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "ecr_repository_use_image_scanning" {
  title       = "ECR repository should use image scanning"
  description = "One of the best practices when making containers available through AWS ECR is to scan them for vulnerabilities before sharing or using them."
  query       = query.ecr_repository_use_image_scanning

  tags = local.ecr_compliance_common_tags
}

control "ecr_repository_encrypted_with_kms" {
  title       = "ECR repository should be encrypted with KMS"
  description = "Ensure ECR repositories being created are set to be encrypted at rest using customer-managed CMK."
  query       = query.ecr_repository_encrypted_with_kms

  tags = local.ecr_compliance_common_tags
}
