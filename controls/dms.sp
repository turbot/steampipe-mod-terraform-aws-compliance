locals {
  dms_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "dms"
  })
}

benchmark "dms" {
  title         = "DMS"
  children = [
    control.dms_replication_instance_not_publicly_accessible
  ]
  tags          = local.dms_compliance_common_tags
}
