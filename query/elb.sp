query "elb_application_classic_lb_logging_enabled" {
  sql = <<-EOQ
  (
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'access_logs') is null then 'alarm'
        when (arguments -> 'access_logs' -> 'enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'access_logs') is null then ' logging disabled'
        when (arguments -> 'access_logs' -> 'enabled')::bool then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lb'
  )
  union
  (
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'access_logs') is null then 'alarm'
        when (arguments -> 'access_logs' -> 'enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'access_logs') is null then ' logging disabled'
        when (arguments -> 'access_logs' -> 'enabled')::bool then ' logging enabled'
        else ' logging disabled'
        end || '.' reason
        ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb'
  );
  EOQ
}

query "elb_application_lb_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_deletion_protection') is null then 'alarm'
        when (arguments -> 'enable_deletion_protection')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'enable_deletion_protection') is null then ' ''enable_deletion_protection'' not defined'
        when (arguments -> 'enable_deletion_protection')::boolean then ' deletion protection enabled'
        else ' deletion protection disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lb';
  EOQ
}

query "elb_application_lb_drop_http_headers" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'drop_invalid_header_fields') is null then 'alarm'
        when (arguments -> 'drop_invalid_header_fields')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'drop_invalid_header_fields') is null then ' ''drop_invalid_header_fields'' disabled'
        when (arguments -> 'drop_invalid_header_fields')::boolean then ' ''drop_invalid_header_fields'' enabled'
        else ' ''drop_invalid_header_fields'' disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lb';
  EOQ
}

query "elb_application_lb_waf_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_waf_fail_open') is null then 'alarm'
        when (arguments -> 'enable_waf_fail_open')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'enable_waf_fail_open') is null then ' WAF disabled'
        when (arguments -> 'enable_waf_fail_open')::boolean then ' WAF enabled'
        else ' WAF disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lb';
  EOQ
}

query "elb_classic_lb_cross_zone_load_balancing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cross_zone_load_balancing') is null then 'ok'
        when (arguments -> 'cross_zone_load_balancing')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'cross_zone_load_balancing') is null then ' cross-zone load balancing enabled'
        when (arguments -> 'cross_zone_load_balancing')::boolean then ' cross-zone load balancing enabled'
        else ' cross-zone load balancing disabled'
        end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb'
  EOQ
}

query "elb_classic_lb_use_ssl_certificate" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'listener') is null then 'skip'
        when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' -> 'ssl_certificate_id') is null then 'alarm'
        when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' ->> 'ssl_certificate_id') like 'arn:aws:acm%' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'listener') is null then ' has no listener'
        when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' -> 'ssl_certificate_id') is null then ' does not use certificate provided by ACM'
        when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' ->> 'ssl_certificate_id') like 'arn:aws:acm%' then ' uses certificates provided by ACM'
        else ' does not use certificate provided by ACM'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb';
  EOQ
}

query "elb_classic_lb_use_tls_https_listeners" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'listener' ->> 'lb_protocol') like any (array ['HTTPS', 'TLS']) then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'listener' ->> 'lb_protocol') like any (array ['HTTPS', 'TLS']) then ' configured with ' || (arguments -> 'listener' ->> 'lb_protocol') || ' protocol'
        else ' not configured with HTTPS or TLS protocol'
        end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb';
  EOQ
}
