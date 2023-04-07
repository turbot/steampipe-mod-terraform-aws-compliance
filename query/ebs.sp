query "ebs_attached_volume_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined.'
        when (arguments ->> 'encrypted')::bool then ' encrypted.'
        else ' not encrypted.'
      end || '.' as reason,
      path || ':' || start_line
    from
      terraform_resource
    where
      type = 'aws_ebs_volume';
  EOQ
}

query "ebs_volume_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined.'
        when (arguments ->> 'encrypted')::bool then ' encrypted.'
        else ' not encrypted.'
      end || '.' as reason,
      path || ':' || start_line
    from
      terraform_resource
    where
      type = 'aws_ebs_volume';
  EOQ
}
