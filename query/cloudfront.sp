query "cloudfront_distribution_configured_with_origin_failover" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'origin_group' -> 'member') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'origin_group' -> 'member' ) is not null then ' origin group is configured'
        else ' origin group not configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}

query "cloudfront_distribution_default_root_object_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'default_root_object') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'default_root_object') is not null then ' default root object configured'
        else ' default root object not configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}

query "cloudfront_distribution_encryption_in_transit_enabled" {
  sql = <<-EOQ
    with cloudfront_distribution as (
      select
        *
      from
        terraform_resource
      where type = 'aws_cloudfront_distribution'
    ), data as (
      select
        distinct name
      from
        cloudfront_distribution,
        jsonb_array_elements(
        case jsonb_typeof(arguments -> 'ordered_cache_behavior' -> 'Items')
          when 'array' then (arguments -> 'ordered_cache_behavior' -> 'Items')
          else null end
        ) as cb
      where
        cb ->> 'ViewerProtocolPolicy' = 'allow-all'
  )
  select
    type || ' ' || b.name as resource,
    case
      when d.name is not null or (arguments -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then 'alarm'
      else 'ok'
    end status,
    case
      when d.name is not null or (arguments -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then ' data not encrypted in transit'
      else ' data encrypted in transit'
    end || '.' reason
    ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "b.")}
    ${local.common_dimensions_sql}
  from
    cloudfront_distribution as b
    left join data as d on b.name = d.name;
  EOQ
}

query "cloudfront_distribution_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_config') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'logging_config') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}

query "cloudfront_distribution_origin_access_identity_enabled" {
  sql = <<-EOQ
    with cloudfront_distribution as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_cloudfront_distribution'
    ), origins as (
        select
          count(*),
          name
        from
          cloudfront_distribution,
          jsonb_array_elements(arguments -> 'origin') as o
        where
          (o ->> 'domain_name' ) like '%aws_s3_bucket%' and
          (o -> 's3_origin_config' ->> 'origin_access_identity') = ''
        group by name
    )
    select
      type || ' ' || a.name as resource,
      case
        when b.name is not null then 'alarm'
        else 'ok'
      end as status,
      case
        when b.name is not null then ' origin access identity not configured'
        else ' origin access identity configured'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${local.common_dimensions_sql}
    from
      cloudfront_distribution as a
      left join origins as b on a.name = b.name;
  EOQ
}

query "cloudfront_distribution_waf_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'web_acl_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'web_acl_id') is not null then ' associated with WAF'
        else ' not associated with WAF'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}

query "cloudfront_protocol_version_is_low" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then 'ok'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then ' minimum protocol version is set to TLSv1.2_2019'
        else ' minimum protocol version is not set to TLSv1.2_2019'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}

query "cloudfront_response_header_use_strict_transport_policy_setting" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'access_control_max_age_sec')::integer = 31536000
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'include_subdomains')::boolean
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'preload')::boolean
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'override')::boolean
        then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'access_control_max_age_sec')::integer = 31536000
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'include_subdomains')::boolean
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'preload')::boolean
        and (arguments -> 'security_headers_config' -> 'strict_transport_security' ->> 'override')::boolean then ' CloudFront response header policy enforces Strict Transport Security settings'
        else ' CloudFront response header policy not enforcing Strict Transport Security settings'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_response_headers_policy';
  EOQ
}
