locals {
  emr_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EMR"
  })
}

benchmark "emr" {
  title       = "EMR"
  description = "This benchmark provides a set of controls that detect Terraform AWS EMR resources deviating from security best practices."

  children = [
    control.emr_cluster_kerberos_enabled
  ]

  tags = merge(local.emr_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "emr_cluster_kerberos_enabled" {
  title         = "EMR cluster Kerberos should be enabled"
  description   = "The access permissions and authorizations can be managed and incorporated with the principles of least privilege and separation of duties, by enabling Kerberos for Amazon EMR clusters."
  sql           = query.emr_cluster_kerberos_enabled.sql

  tags = merge(local.emr_compliance_common_tags, {
    hipaa             = "true"
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
  })
}
