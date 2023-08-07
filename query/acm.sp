
query "acm_certificate_create_before_destroy_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (lifecycle ->> 'create_before_destroy') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (lifecycle ->> 'create_before_destroy') = 'true' then ' create before destroy enabled'
        else ' create before destroy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_acm_certificate';
  EOQ
}

query "acm_certificate_transparency_logging_enabled" {
  sql = <<-EOQ
      select
      type || ' ' || name as resource,
      case
        when (arguments -> 'options' ->> 'certificate_transparency_logging_preference')::text = 'ENABLED' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'options' ->> 'certificate_transparency_logging_preference')::text = 'ENABLED' then ' certificate transparency logging preference enabled'
        else ' certificate transparency logging preference disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_acm_certificate';
  EOQ
}