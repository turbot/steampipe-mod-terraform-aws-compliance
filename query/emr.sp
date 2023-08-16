query "emr_cluster_kerberos_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kerberos_attributes') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kerberos_attributes') is null then ' kerberos disabled'
        else ' kerberos enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_cluster';
  EOQ
}

query "emr_cluster_security_configuration_local_disk_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' ->> 'LocalDiskEncryptionConfiguration') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' ->> 'LocalDiskEncryptionConfiguration') is not null then ' local disk encryption enabled'
        else ' local disk encryption disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_security_configuration';
  EOQ
}

query "emr_cluster_security_configuration_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption') is null then skip
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption') is null then ' encryption in transit is not set'
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption')::bool then ' encryption in transit enabled'
        else ' encryption in transit disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_security_configuration';
  EOQ
}

query "emr_cluster_security_configuration_ebs_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' -> 'LocalDiskEncryptionConfiguration' ->> 'EnableEbsEncryption')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' -> 'LocalDiskEncryptionConfiguration' ->> 'EnableEbsEncryption')::bool then ' ebs encryption enabled'
        else ' ebs encryption disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_security_configuration';
  EOQ
}

query "emr_cluster_security_configuration_encryption_uses_sse_kms" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' -> 'S3EncryptionConfiguration' ->> 'EncryptionMode') = 'SSE-KMS' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' ->> 'EnableAtRestEncryption')::bool and ((arguments ->> 'configuration')::jsonb -> 'EncryptionConfiguration' -> 'AtRestEncryptionConfiguration' -> 'S3EncryptionConfiguration' ->> 'EncryptionMode') = 'SSE-KMS' then ' encryption uses SSE-KMS'
        else ' encryption does not use SSE-KMS'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_security_configuration';
  EOQ
}