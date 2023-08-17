locals {
  dax_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/DAX"
  })
}

benchmark "dax" {
  title       = "DAX"
  description = "This benchmark provides a set of controls that detect Terraform AWS DAX resources deviating from security best practices."

  children = [
    control.dax_cluster_encryption_at_rest_enabled,
    control.dax_cluster_endpoint_encryption_tls_enabled
  ]

  tags = merge(local.dax_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dax_cluster_encryption_at_rest_enabled" {
  title       = "DynamoDB Accelerator (DAX) clusters should be encrypted at rest"
  description = "This control checks whether a DAX cluster is encrypted at rest. Encrypting data at rest reduces the risk of data stored on disk being accessed by a user not authenticated to AWS. The encryption adds another set of access controls to limit the ability of unauthorized users to access to the data. For example, API permissions are required to decrypt the data before it can be read."
  query       = query.dax_cluster_encryption_at_rest_enabled

  tags = merge(local.dax_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
  })
}

control "dax_cluster_endpoint_encryption_tls_enabled" {
  title       = "DAX clusters endpoint encryption should have TLS enabled"
  description = "This control checks whether a DAX cluster endpoint encryption has TLS enabled. TLS encrypts the connection between the application and the DAX cluster. Encrypting data in transit protects it from being intercepted by a user not authenticated to AWS. The encryption adds another set of access controls to limit the ability of unauthorized users to access to the data. For example, API permissions are required to decrypt the data before it can be read."
  query       = query.dax_cluster_endpoint_encryption_tls_enabled

  tags = local.dax_compliance_common_tags
}
