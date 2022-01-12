locals {
  dynamodb_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "dynamodb"
  })
}

benchmark "dynamodb" {
  title         = "DynamoDB"
  children = [
    control.dynamodb_table_encrypted_with_kms_cmk,
    control.dynamodb_table_encryption_enabled,
    control.dynamodb_table_point_in_time_recovery_enabled,
    control.dynamodb_vpc_endpoint_routetable_association
  ]
  tags          = local.dynamodb_compliance_common_tags
}
