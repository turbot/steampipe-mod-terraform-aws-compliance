locals {
  ecr_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ecr"
  })
}

benchmark "ecr" {
  title         = "ECR"
  children = [
    control.ecr_repository_tags_immutable,
    control.ecr_repository_use_image_scanning,
  ]
  tags          = local.ecr_compliance_common_tags
}
