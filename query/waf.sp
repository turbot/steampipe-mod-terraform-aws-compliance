query "waf_web_acl_rule_attached" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'rules') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'rules') is not null then ' has rule(s) attached'
        else ' has no attached rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_waf_web_acl'
  EOQ
}

query "waf_regional_web_acl_rule_attached" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'rule') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'rule') is not null then ' has rule(s) attached'
        else ' has no attached rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_wafregional_web_acl'
  EOQ
}

query "waf_web_acl_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' ->> 'log_destination') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' ->> 'log_destination') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_waf_web_acl'
  EOQ
}

query "wafregional_web_acl_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' ->> 'log_destination') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' ->> 'log_destination' ) is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_wafregional_web_acl'
  EOQ
}

query "waf_web_acl_rule_with_action" {
  sql = <<-EOQ
    with rules_without_action as (
      select
        type || ' ' || name as name
      from
        terraform_resource,
        jsonb_array_elements(
        case jsonb_typeof(arguments -> 'rules')
          when 'array' then (arguments -> 'rules')
          else null end
        ) as r
      where
       ( r -> 'action' is null or (r -> 'action' = '{}'))
        and type = 'aws_waf_web_acl'
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when (jsonb_typeof(arguments -> 'rules') = 'array') and a.name is null then 'ok'
        when (jsonb_typeof(arguments -> 'rules') = 'array') and a.name is not null then 'alarm'
        when (arguments -> 'rules' ->> 'action') is not null then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when (jsonb_typeof(arguments -> 'rules') = 'array') and a.name is null then ' has all rules with action attached'
        when (jsonb_typeof(arguments -> 'rules') = 'array') and a.name is not null then ' has rules with no action attached'
        when (arguments -> 'rules' ->> 'action') is not null then ' has rule with action attached'
        else ' has rules with no action attached'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules_without_action as a on a.name = concat(r.type || ' ' || r.name)
    where
      r.type = 'aws_waf_web_acl';
  EOQ
}

query "wafregional_web_acl_rule_with_action" {
  sql = <<-EOQ
    with rules_without_action as (
      select
        type || ' ' || name as name
      from
        terraform_resource,
        jsonb_array_elements(
        case jsonb_typeof(arguments -> 'rule')
          when 'array' then (arguments -> 'rule')
          else null end
        ) as r
      where
       ( r -> 'action' is null or (r -> 'action' = '{}'))
        and type = 'aws_wafregional_web_acl'
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when (jsonb_typeof(arguments -> 'rule') = 'array') and a.name is null then 'ok'
        when (jsonb_typeof(arguments -> 'rule') = 'array') and a.name is not null then 'alarm'
        when ((arguments -> 'rule' ->> 'action') is not null) then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when (jsonb_typeof(arguments -> 'rule') = 'array') and a.name is null then ' has all rules with action attached'
        when (jsonb_typeof(arguments -> 'rule') = 'array') and a.name is not null then ' has rules with no action attached'
        when ((arguments -> 'rule' ->> 'action') is not null) then ' has rule with action attached'
        else ' has rules with no action attached'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules_without_action as a on a.name = concat(r.type || ' ' || r.name)
    where
      r.type = 'aws_wafregional_web_acl';
  EOQ
}
