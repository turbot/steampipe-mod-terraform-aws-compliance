locals {
  eks_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/EKS"
  })
}

benchmark "eks" {
  title       = "EKS"
  description = "This benchmark provides a set of controls that detect Terraform AWS EKS resources deviating from security best practices."

  children = [
    control.eks_cluster_endpoint_restrict_public_access,
    control.eks_cluster_log_types_enabled,
    control.eks_cluster_secrets_encrypted
  ]

  tags = merge(local.eks_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "eks_cluster_endpoint_restrict_public_access" {
  title         = "EKS clusters endpoint should restrict public access"
  description   = "Ensure whether Amazon Elastic Kubernetes Service (Amazon EKS) endpoint is not publicly accessible. The rule is complaint if the endpoint is publicly accessible."
  sql           = query.eks_cluster_endpoint_restrict_public_access.sql

  tags = merge(local.eks_compliance_common_tags, {
    nist_csf = "true"
  })
}

control "eks_cluster_log_types_enabled" {
  title         = "EKS cluster log types should be enabled"
  description   = "Ensure Amazon EKS cluster logging is enabled for all log types"
  sql           = query.eks_cluster_log_types_enabled.sql

  tags = local.eks_compliance_common_tags
}

control "eks_cluster_secrets_encrypted" {
  title         = "EKS clusters should be configured to have kubernetes secrets encrypted using KMS"
  description   = "Ensure if Amazon Elastic Kubernetes Service clusters are configured to have Kubernetes secrets encrypted using AWS Key Management Service (KMS) keys."
  sql           = query.eks_cluster_secrets_encrypted.sql

  tags = merge(local.eks_compliance_common_tags, {
    hipaa = "true"
  })
}