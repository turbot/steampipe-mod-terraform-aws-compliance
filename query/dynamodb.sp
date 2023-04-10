query "dynamodb_table_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        -- // kms_key_arn - This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb.
        -- This query only checks if table is encrypted by default AWS KMS i.e. If enabled is false then server-side encryption is set to AWS owned CMK
        when (arguments -> 'server_side_encryption' ->> 'enabled')::bool is false then 'alarm'
        when (arguments -> 'server_side_encryption'->> 'enabled')::bool is true and (arguments -> 'server_side_encryption' ->> 'kms_key_arn') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'server_side_encryption' ->> 'enabled')::bool is false then ' encrypted by DynamoDB managed and owned AWS KMS key'
        when (arguments -> 'server_side_encryption'->> 'enabled')::bool is true and (arguments -> 'server_side_encryption' ->> 'kms_key_arn') is not null then ' encrypted by AWS managed CMK'
        else ' not encrypted by AWS managed CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dynamodb_table';
  EOQ
}

query "dynamodb_table_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'server_side_encryption') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'server_side_encryption') is not null then ' server-side encryption not set to DynamoDB owned KMS key'
        else ' server-side encryption set to AWS owned CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dynamodb_table';
  EOQ
}

query "dynamodb_table_point_in_time_recovery_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'point_in_time_recovery') is null then 'alarm'
        when (arguments -> 'point_in_time_recovery' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'point_in_time_recovery') is null then ' ''point_in_time_recovery'' disabled'
        when (arguments -> 'point_in_time_recovery' ->> 'enabled')::boolean then ' ''point_in_time_recovery'' enabled'
        else ' ''point_in_time_recovery'' disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dynamodb_table';
  EOQ
}

query "dynamodb_vpc_endpoint_routetable_association" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then 'alarm'
        when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then ' VPC Endpoint for DynamoDB disabled'
        when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then ' VPC Endpoint for DynamoDB enabled'
        else ' VPC Endpoint for DynamoDB disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_vpc_endpoint';
  EOQ
}
