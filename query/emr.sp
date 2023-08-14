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

query "emr_cluster_security_configuration_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'configuration' -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption') is null then 'skip'
        when (arguments -> 'configuration' -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'configuration' -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption') is null then ' encryption configuration not set'
        when (arguments -> 'configuration' -> 'EncryptionConfiguration' ->> 'EnableInTransitEncryption')::bool then ' encryption in transit enabled'
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