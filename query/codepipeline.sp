query "codepipeline_artifacts_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'artifact_store' -> 'encryption_key' ->> 'id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'artifact_store' -> 'encryption_key' ->> 'id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codepipeline';
  EOQ
}