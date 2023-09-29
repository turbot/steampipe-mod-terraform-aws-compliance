query "cloudfront_distribution_configured_with_origin_failover" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'origin_group' -> 'member') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'origin_group' -> 'member' ) is not null then ' origin group is configured'
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
      address as resource,
      case
        when (attributes_std -> 'default_root_object') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'default_root_object') is not null then ' default root object configured'
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
        case jsonb_typeof(attributes_std -> 'ordered_cache_behavior' -> 'Items')
          when 'array' then (attributes_std -> 'ordered_cache_behavior' -> 'Items')
          else null end
        ) as cb
      where
        cb ->> 'ViewerProtocolPolicy' = 'allow-all'
  )
  select
    type || ' ' || b.name as resource,
    case
      when d.name is not null or (attributes_std -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then 'alarm'
      else 'ok'
    end status,
    case
      when d.name is not null or (attributes_std -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then ' data not encrypted in transit'
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
      address as resource,
      case
        when (attributes_std -> 'logging_config') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'logging_config') is not null then ' logging enabled'
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
    ), origin_type as (
        select
          distinct name
        from
          cloudfront_distribution,
          jsonb_array_elements(
            case jsonb_typeof(attributes_std -> 'origin')
            when 'array' then (attributes_std -> 'origin')
            else null end
            ) as o
        where
          (o ->> 'domain_name' ) like '%aws_s3_bucket%'
        group by name
    ),origins as (
        select
          count(*),
          name
        from
          cloudfront_distribution,
          jsonb_array_elements(
            case jsonb_typeof(attributes_std -> 'origin')
            when 'array' then (attributes_std -> 'origin')
            else null end
            ) as o
        where
          (o ->> 'domain_name' ) like '%aws_s3_bucket%'
          and(
          (o -> 's3_origin_config' ->> 'origin_access_identity') = ''
          or (o -> 's3_origin_config' ) is null
          )
        group by name
    )
    select
      type || ' ' || a.name as resource,
      case
        when (attributes_std -> 'origin') is null then 'alarm'
        when (attributes_std -> 'origin' ->> 'domain_name' ) like '%aws_s3_bucket%' and (( not((attributes_std -> 'origin' -> 's3_origin_config' ->> 'origin_access_identity') = '')) and (attributes_std -> 'origin' -> 's3_origin_config' -> 'origin_access_identity') is not null) then 'ok'
        when (attributes_std -> 'origin' ->> 'domain_name' ) like '%aws_s3_bucket%' and (((attributes_std -> 'origin' -> 's3_origin_config' ->> 'origin_access_identity') = '') or ((attributes_std -> 'origin' -> 's3_origin_config') is null)) then 'alarm'
        when b.name is not null then 'alarm'
        when (t.name is null ) and ((attributes_std -> 'origin' ->> 'domain_name') not like '%aws_s3_bucket%') then 'skip'
        else 'ok'
      end as status,
      a.address || case
        when (attributes_std -> 'origin') is null then ' origins not defined'
        when (attributes_std -> 'origin' ->> 'domain_name' ) like '%aws_s3_bucket%' and (( not((attributes_std -> 'origin' -> 's3_origin_config' ->> 'origin_access_identity') = '')) and (attributes_std -> 'origin' -> 's3_origin_config' -> 'origin_access_identity') is not null) then ' origin access identity configured'
        when (attributes_std -> 'origin' ->> 'domain_name' ) like '%aws_s3_bucket%' and (((attributes_std -> 'origin' -> 's3_origin_config' ->> 'origin_access_identity') = '') or ((attributes_std -> 'origin' -> 's3_origin_config') is null)) then ' origin access identity not configured'
        when b.name is not null then ' origin access identity not configured'
        when (t.name is null ) and ((attributes_std -> 'origin' ->> 'domain_name') not like '%aws_s3_bucket%') then ' origin type is not S3'
        else ' origin access identity configured'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${local.common_dimensions_sql}
    from
      cloudfront_distribution as a
      left join origin_type as t on a.name = t.name
      left join origins as b on a.name = b.name;
  EOQ
}

query "cloudfront_distribution_waf_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'web_acl_id') is not null then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'web_acl_id') is not null then ' associated with WAF'
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
      address as resource,
      case
        when (attributes_std -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then 'ok'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then ' minimum protocol version is set to TLSv1.2_2019'
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
      address as resource,
      case
        when (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'access_control_max_age_sec')::integer = 31536000
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'include_subdomains')::boolean
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'preload')::boolean
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'override')::boolean
        then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'access_control_max_age_sec')::integer = 31536000
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'include_subdomains')::boolean
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'preload')::boolean
        and (attributes_std -> 'security_headers_config' -> 'strict_transport_security' ->> 'override')::boolean then ' enforces Strict Transport Security settings'
        else ' does not enforce Strict Transport Security settings'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_response_headers_policy';
  EOQ
}

query "cloudfront_distribution_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'enabled')::boolean then 'ok'
        else 'info'
      end status,
      address || case
        when(attributes_std ->> 'enabled')::boolean then ' is enabled'
        else ' is disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudfront_distribution';
  EOQ
}
