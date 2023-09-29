query "kinesis_stream_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encryption_type') = 'KMS' then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std ->> 'encryption_type') = 'KMS' then ' encrypted aty rest'
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
      address as resource,
      case
        when (attributes_std -> 'server_side_encryption' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'server_side_encryption' ->> 'enabled') = 'true' then ' server side encryption enabled'
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
      address as resource,
      case
        when (attributes_std -> 'server_side_encryption' ->> 'key_type') = 'CUSTOMER_MANAGED_CMK' and (attributes_std -> 'server_side_encryption' ->> 'key_arn') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'server_side_encryption' ->> 'key_type') = 'CUSTOMER_MANAGED_CMK' and (attributes_std -> 'server_side_encryption' ->> 'key_arn') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std ->> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std ->> 'kms_key_id') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kinesis_video_stream';
  EOQ
}