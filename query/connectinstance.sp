query "connectinstance_kinesis_video_stream_storage_config_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'storage_config' -> 'kinesis_video_stream_config' -> 'encryption_config' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'storage_config' -> 'kinesis_video_stream_config' -> 'encryption_config' ->> 'key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_connect_instance_storage_config';
  EOQ
}

query "connectinstance_s3_storage_config_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'storage_config' -> 's3_config' -> 'encryption_config' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'storage_config' -> 's3_config' -> 'encryption_config' ->> 'key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_connect_instance_storage_config';
  EOQ
}