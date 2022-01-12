locals {
  eks_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "eks"
  })
}

benchmark "eks" {
  title         = "EKS"
  children = [
    control.eks_cluster_endpoint_restrict_public_access,
    control.eks_cluster_log_types_enabled,
    control.eks_cluster_secrets_encrypted
  ]
  tags          = local.eks_compliance_common_tags
}
