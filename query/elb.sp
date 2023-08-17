query "elb_application_classic_network_lb_logging_enabled" {
  sql = <<-EOQ
  (
    select
      type || ' ' || name as resource,
      case
      --The Gateway Load Balancer does not generate access logs since it is a transparent layer 3 load balancer that does not terminate flows.
      --Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified.
        when (arguments ->> 'load_balancer_type') = 'gateway' then 'skip'
        when (arguments -> 'access_logs') is null then 'alarm'
        when (arguments -> 'access_logs' -> 'enabled')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'load_balancer_type') = 'gateway' then ' load balancer is of ' || (arguments ->> 'load_balancer_type') || ' type'
        when (arguments -> 'access_logs') is null then ' logging disabled'
        when (arguments -> 'access_logs' -> 'enabled')::bool then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('aws_lb', 'aws_alb')
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
        ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb';
  EOQ
}

query "elb_application_network_gateway_lb_use_desync_mitigation_mode" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'desync_mitigation_mode') like any (array ['defensive', 'strictest']) then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'desync_mitigation_mode') like any (array ['defensive', 'strictest']) then ' configured with ' || (arguments ->> 'desync_mitigation_mode') || ' mitigation mode'
        else ' not configured with defensive or strictest desync mitigation mode'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('aws_lb', 'aws_alb');
  EOQ
}

query "elb_classic_lb_use_desync_mitigation_mode" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'desync_mitigation_mode') like any (array ['defensive', 'strictest']) then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'desync_mitigation_mode') like any (array ['defensive', 'strictest']) then ' configured with ' || (arguments ->> 'desync_mitigation_mode') || ' mitigation mode'
        else ' not configured with defensive or strictest desync mitigation mode'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb';
  EOQ
}

# Note: Even aws_alb is known as aws_lb, the functionality is identical.
# We are still keeping the union queries, as users can still use aws_alb or aws_lb or user may have scripts using both the resourct types
query "elb_application_lb_drop_invalid_header_fields" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'load_balancer_type') like any (array ['gateway', 'network']) then 'skip'
        when (arguments ->> 'drop_invalid_header_fields')::boolean and ((arguments ->> 'load_balancer_type') is null or (arguments ->> 'load_balancer_type') = 'application')
        then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'load_balancer_type') like any (array ['gateway', 'network']) then ' load balancer is of ' || (arguments ->> 'load_balancer_type') || ' type'
        when (arguments ->> 'drop_invalid_header_fields')::boolean
        and ((arguments ->> 'load_balancer_type') is null or (arguments ->> 'load_balancer_type') = 'application')
        then ' configured to drop invalid http header field(s)'
        else ' not configured to drop invalid http header field(s)'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('aws_lb', 'aws_alb');
  EOQ
}

query "elb_lb_use_secure_protocol_listener" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'protocol') like any (array ['HTTPS', 'TLS', 'TCP', 'UDP', 'TCP_UDP']) then 'ok'
        when (arguments -> 'default_action' ->> 'type') = 'redirect' and (arguments -> 'default_action' -> 'redirect' ->> 'protocol') = 'HTTPS' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'protocol') like any (array ['HTTPS', 'TLS', 'TCP', 'UDP', 'TCP_UDP']) then ' listener configured with ' || (arguments ->> 'protocol') || ' secure protocol'
        when (arguments -> 'default_action' ->> 'type') = 'redirect' and (arguments -> 'default_action' -> 'redirect' ->> 'protocol') = 'HTTPS' then ' listener configured with ' || (arguments -> 'default_action' ->> 'type') || ' and ' || (arguments -> 'default_action' -> 'redirect' ->> 'protocol') || ' secure protocol'
        else ' listener not configured with any secured protocol'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('aws_lb_listener', 'aws_alb_listener');
  EOQ
}

query "elb_application_network_gateway_lb_cross_zone_load_balancing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'load_balancer_type') = 'application' or (arguments ->> 'load_balancer_type') is null) and (arguments -> 'enable_cross_zone_load_balancing') is null then 'ok'
        when (arguments ->> 'load_balancer_type') like any (array ['gateway', 'network']) and (arguments -> 'enable_cross_zone_load_balancing')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'load_balancer_type') = 'application' and (arguments -> 'enable_cross_zone_load_balancing') is null then ' cross-zone load balancing enabled default for ' || (arguments ->> 'load_balancer_type') || ' type'
        when (arguments ->> 'load_balancer_type') like any (array ['gateway', 'network']) and (arguments -> 'enable_cross_zone_load_balancing')::boolean then ' cross-zone load balancing enabled for ' || (arguments ->> 'load_balancer_type') || ' type'
        else ' cross-zone load balancing disabled'
        end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('aws_alb', 'aws_lb');
  EOQ
}
