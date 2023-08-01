query "kinesis_stream_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'encryption_type') = 'KMS' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'encryption_type') = 'KMS' then ' encrypted aty rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_stream';
  EOQ
}

query "kinesis_firehose_delivery_stream_server_side_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'server_side_encryption' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'server_side_encryption' ->> 'enabled') = 'true' then ' server side encryption enabled'
        else ' server side encryption disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_firehose_delivery_stream';
  EOQ
}

query "kinesis_firehose_delivery_stream_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'server_side_encryption' ->> 'key_type') = 'CUSTOMER_MANAGED_CMK' and (arguments -> 'server_side_encryption' ->> 'key_arn') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'server_side_encryption' ->> 'key_type') = 'CUSTOMER_MANAGED_CMK' and (arguments -> 'server_side_encryption' ->> 'key_arn') is not null then ' encrypted by KMS CMK'
        else ' not encrypted by KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_firehose_delivery_stream';
  EOQ
}

query "kinesis_stream_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'kms_key_id') is not null then ' encrypted by KMS CMK'
        else ' not encrypted by KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_stream';
  EOQ
}

query "kinesis_video_stream_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'kms_key_id') is not null then ' encrypted by KMS CMK'
        else ' not encrypted by KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_video_stream';
  EOQ
}