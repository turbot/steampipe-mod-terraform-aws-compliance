locals {
  dynamodb_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "dynamodb"
  })
}

benchmark "dynamodb" {
  title       = "DynamoDB"
  description = "This benchmark provides a set of controls that detect Terraform AWS DynamoDB resources deviating from security best practices."

  children = [
    control.dynamodb_table_encrypted_with_kms_cmk,
    control.dynamodb_table_encryption_enabled,
    control.dynamodb_table_point_in_time_recovery_enabled,
    control.dynamodb_vpc_endpoint_routetable_association
  ]
  tags          = local.dynamodb_compliance_common_tags
}

control "dynamodb_table_encrypted_with_kms_cmk" {
  title         = "DynamoDB table should be encrypted with AWS KMS"
  description   = "Ensure that encryption is enabled for your Amazon DynamoDB tables. Because sensitive data can exist at rest in these tables, enable encryption at rest to help protect that data."
  sql           = query.dynamodb_table_encrypted_with_kms_cmk.sql

  tags = merge(local.dynamodb_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    rbi_cyber_security = "true"
  })
}

control "dynamodb_table_encryption_enabled" {
  title         = "DynamoDB table should have encryption enabled"
  description   = "Ensure that encryption is enabled for your Amazon DynamoDB tables. Because sensitive data can exist at rest in these tables, enable encryption at rest to help protect that data."
  sql           = query.dynamodb_table_encryption_enabled.sql

  tags = merge(local.dynamodb_compliance_common_tags, {
    gdpr  = "true"
    hipaa = "true"
  })
}

control "dynamodb_table_point_in_time_recovery_enabled" {
  title         = "DynamoDB table point-in-time recovery should be enabled"
  description   = "Enable this rule to check that information has been backed up. It also maintains the backups by ensuring that point-in-time recovery is enabled in Amazon DynamoDB."
  sql           = query.dynamodb_table_point_in_time_recovery_enabled.sql

  tags = merge(local.dynamodb_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
    soc_2                     = "true"
  })
}

control "dynamodb_vpc_endpoint_routetable_association" {
  title         = "DynamoDB VPC endpoint should be enabled in all route tables in use in a VPC"
  description   = "Using VPC endpoints helps to secure traffic by ensuring that the data does not traverse the internet or access public networks. It also helps keep private subnets private. Setting up VPC endpoints can be complicated."
  sql           = query.dynamodb_vpc_endpoint_routetable_association.sql

  tags = local.dynamodb_compliance_common_tags
}