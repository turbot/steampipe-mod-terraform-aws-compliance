locals {
  emr_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "emr"
  })
}

benchmark "emr" {
  title    = "EMR"
  children = [
    control.emr_cluster_kerberos_enabled
  ]
  tags          = local.emr_compliance_common_tags
}

control "emr_cluster_kerberos_enabled" {
  title         = "EMR cluster Kerberos should be enabled"
  description   = "The access permissions and authorizations can be managed and incorporated with the principles of least privilege and separation of duties, by enabling Kerberos for Amazon EMR clusters."
  sql           = query.emr_cluster_kerberos_enabled.sql

  tags = local.emr_compliance_common_tags
}
