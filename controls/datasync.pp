locals {
  datasync_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/DataSync"
  })
}

benchmark "datasync" {
  title       = "DataSync"
  description = "This benchmark provides a set of controls that detect Terraform AWS DataSync resources deviating from security best practices."

  children = [
    control.datasync_location_object_storage_expose_secret
  ]

  tags = merge(local.datasync_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "datasync_location_object_storage_expose_secret" {
  title       = "DataSync object storage location configuration should restrict secret key exposure"
  description = "This control checks whether DataSync object storage location configuration exposes to any access key secrets."
  query       = query.datasync_location_object_storage_expose_secret

  tags = local.datasync_compliance_common_tags
}
