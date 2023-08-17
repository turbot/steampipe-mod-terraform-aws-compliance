locals {
  msk_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/MSK"
  })
}

benchmark "msk" {
  title       = "MQBroker"
  description = "This benchmark provides a set of controls that detect Terraform AWS MSK resources deviating from security best practices."

  children = [
    control.msk_cluster_encrypted_with_kms_cmk,
    control.msk_cluster_encryption_in_transit_enabled,
    control.msk_cluster_logging_enabled,
    control.msk_cluster_nodes_publicly_accessible
  ]

  tags = merge(local.msk_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "msk_cluster_nodes_publicly_accessible" {
  title       = "MSK Cluster Nodes should not be publicly accessible"
  description = "This control checks whether MSK Cluster Nodes are private. This control fails if MSK Cluster Nodes are publicly accessible."
  query       = query.msk_cluster_nodes_publicly_accessible

  tags = local.msk_compliance_common_tags
}

control "msk_cluster_logging_enabled" {
  title       = "MSK Cluster Nodes should have logging enabled"
  description = "This control checks whether logging is enabled for the MSK Cluster."
  query       = query.msk_cluster_logging_enabled

  tags = local.msk_compliance_common_tags
}

control "msk_cluster_encryption_in_transit_enabled" {
  title       = "MSK Cluster Nodes should have encryption in transt enabled"
  description = "This control checks whether the MSK Cluster has encryption in transit enabled."
  query       = query.msk_cluster_encryption_in_transit_enabled

  tags = local.msk_compliance_common_tags
}

control "msk_cluster_encrypted_with_kms_cmk" {
  title       = "MSK Cluster Nodes should have be encrypted with a customer-managed key"
  description = "This control checks whether the MSK Cluster is encrypted with a customer-managed key."
  query       = query.msk_cluster_encrypted_with_kms_cmk

  tags = local.msk_compliance_common_tags
}
