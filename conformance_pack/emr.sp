locals {
  conformance_pack_emr_common_tags = {
    service = "emr"
  }
}

control "emr_cluster_kerberos_enabled" {
  title         = "EMR cluster Kerberos should be enabled"
  description   = "The access permissions and authorizations can be managed and incorporated with the principles of least privilege and separation of duties, by enabling Kerberos for Amazon EMR clusters."
  sql           = query.emr_cluster_kerberos_enabled.sql

  tags = local.conformance_pack_emr_common_tags
}
