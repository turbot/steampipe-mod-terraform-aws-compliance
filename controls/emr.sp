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
