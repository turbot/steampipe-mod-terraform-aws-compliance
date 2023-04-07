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
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_emr_cluster';
  EOQ
}
