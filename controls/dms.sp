locals {
  dms_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "dms"
  })
}

benchmark "dms" {
  title       = "DMS"
  description = "This benchmark provides a set of controls that detect Terraform AWS DMS resources deviating from security best practices."

  children = [
    control.dms_replication_instance_not_publicly_accessible
  ]
  tags          = local.dms_compliance_common_tags
}

control "dms_replication_instance_not_publicly_accessible" {
  title         = "DMS replication instances should not be publicly accessible"
  description   = "Manage access to the AWS Cloud by ensuring DMS replication instances cannot be publicly accessed."
  sql           = query.dms_replication_instance_not_publicly_accessible.sql

  tags = merge(local.dms_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}