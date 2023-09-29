query "comprehend_entity_recognizer_volume_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'volume_kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'volume_kms_key_id') is not null then ' uses KMS CMK'
        else ' does not use KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_comprehend_entity_recognizer';
  EOQ
}

query "comprehend_entity_recognizer_model_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'model_kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'model_kms_key_id') is not null then ' uses KMS CMK'
        else ' does not use KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_comprehend_entity_recognizer';
  EOQ
}