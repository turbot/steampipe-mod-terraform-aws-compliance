locals {
  emr_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EMR"
  })
}

benchmark "emr" {
  title       = "EMR"
  description = "This benchmark provides a set of controls that detect Terraform AWS EMR resources deviating from security best practices."

  children = [
    control.emr_cluster_kerberos_enabled,
    control.emr_cluster_security_configuration_ebs_encryption_enabled,
    control.emr_cluster_security_configuration_encryption_in_transit_enabled,
    control.emr_cluster_security_configuration_encryption_uses_sse_kms,
    control.emr_cluster_security_configuration_local_disk_encryption_enabled
  ]

  tags = merge(local.emr_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "emr_cluster_kerberos_enabled" {
  title       = "EMR cluster Kerberos should be enabled"
  description = "The access permissions and authorizations can be managed and incorporated with the principles of least privilege and separation of duties, by enabling Kerberos for Amazon EMR clusters."
  query       = query.emr_cluster_kerberos_enabled

  tags = merge(local.emr_compliance_common_tags, {
    hipaa             = "true"
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
  })
}

control "emr_cluster_security_configuration_encryption_in_transit_enabled" {
  title       = "EMR cluster security configurations should have encryption in transit enabled"
  description = "This control checks whether EMR cluster security configurations are encrypted in transit."
  query       = query.emr_cluster_security_configuration_encryption_in_transit_enabled

  tags = local.emr_compliance_common_tags
}

control "emr_cluster_security_configuration_local_disk_encryption_enabled" {
  title       = "EMR cluster security configurations should have local disk encryption enabled"
  description = "This control checks whether EMR cluster security configurations have local disk encryption enabled."
  query       = query.emr_cluster_security_configuration_local_disk_encryption_enabled

  tags = local.emr_compliance_common_tags
}

control "emr_cluster_security_configuration_ebs_encryption_enabled" {
  title       = "EMR cluster security configurations should have EBS encryption enabled"
  description = "This control checks whether EMR cluster security configurations have EBS encryption enabled."
  query       = query.emr_cluster_security_configuration_ebs_encryption_enabled

  tags = local.emr_compliance_common_tags
}

control "emr_cluster_security_configuration_encryption_uses_sse_kms" {
  title       = "EMR cluster security configurations should use SSE-KMS"
  description = "This control checks whether EMR cluster security configurations use SSE-KMS."
  query       = query.emr_cluster_security_configuration_encryption_uses_sse_kms

  tags = local.emr_compliance_common_tags
}
