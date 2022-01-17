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

control "dms_replication_instance_not_publicly_accessible" {
  title         = "DMS replication instances should not be publicly accessible"
  description   = "Manage access to the AWS Cloud by ensuring DMS replication instances cannot be publicly accessed."
  sql           = query.dms_replication_instance_not_publicly_accessible.sql

  tags = local.dms_compliance_common_tags
}