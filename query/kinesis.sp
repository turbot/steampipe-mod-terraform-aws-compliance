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
