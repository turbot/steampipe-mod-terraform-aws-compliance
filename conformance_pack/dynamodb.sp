locals {
  conformance_pack_dynamodb_common_tags = {
    service = "dynamodb"
  }
}

control "dynamodb_table_encrypted_with_kms_cmk" {
  title         = "DynamoDB table should be encrypted with AWS KMS"
  description   = "Ensure that encryption is enabled for your Amazon DynamoDB tables. Because sensitive data can exist at rest in these tables, enable encryption at rest to help protect that data."
  sql           = query.dynamodb_table_encrypted_with_kms_cmk.sql

  tags = local.conformance_pack_dynamodb_common_tags
}

control "dynamodb_table_encryption_enabled" {
  title         = "DynamoDB table should have encryption enabled"
  description   = "Ensure that encryption is enabled for your Amazon DynamoDB tables. Because sensitive data can exist at rest in these tables, enable encryption at rest to help protect that data."
  sql           = query.dynamodb_table_encryption_enabled.sql

  tags = local.conformance_pack_dynamodb_common_tags
}

control "dynamodb_table_point_in_time_recovery_enabled" {
  title         = "DynamoDB table point-in-time recovery should be enabled"
  description   = "Enable this rule to check that information has been backed up. It also maintains the backups by ensuring that point-in-time recovery is enabled in Amazon DynamoDB."
  sql           = query.dynamodb_table_point_in_time_recovery_enabled.sql

  tags = local.conformance_pack_dynamodb_common_tags
}

control "dynamodb_vpc_endpoint_routetable_association" {
  title         = "DynamoDB VPC endpoint should be enabled in all route tables in use in a VPC"
  description   = "Using VPC endpoints helps secure traffic by ensuring the data does not traverse the Internet or access public networks. It also helps keep private subnets private. Setting up VPC endpoints can be complicated."
  sql           = query.dynamodb_vpc_endpoint_routetable_association.sql

  tags = local.conformance_pack_dynamodb_common_tags
}