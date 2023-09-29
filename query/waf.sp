query "waf_web_acl_rule_attached" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'rules') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'rules') is not null then ' has rule(s) attached'
        else ' has no attached rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_waf_web_acl';
  EOQ
}

query "waf_regional_web_acl_rule_attached" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'rule') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'rule') is not null then ' has rule(s) attached'
        else ' has no attached rules'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_wafregional_web_acl';
  EOQ
}

query "waf_web_acl_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging_configuration' ->> 'log_destination') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'logging_configuration' ->> 'log_destination') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_waf_web_acl';
  EOQ
}

query "waf_regional_web_acl_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging_configuration' ->> 'log_destination') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'logging_configuration' ->> 'log_destination' ) is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_wafregional_web_acl';
  EOQ
}

query "waf_web_acl_rule_with_action" {
  sql = <<-EOQ
    with rules_without_action as (
      select
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
        case jsonb_typeof(attributes_std -> 'rules')
          when 'array' then (attributes_std -> 'rules')
          else null end
        ) as r
      where
       ( r -> 'action' is null or (r -> 'action' = '{}'))
        and type = 'aws_waf_web_acl'
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when (jsonb_typeof(attributes_std -> 'rules') = 'array') and a.name is null then 'ok'
        when (jsonb_typeof(attributes_std -> 'rules') = 'array') and a.name is not null then 'alarm'
        when (attributes_std -> 'rules' ->> 'action') is not null then 'ok'
        else 'alarm'
      end as status,
      r.address || case
        when (jsonb_typeof(attributes_std -> 'rules') = 'array') and a.name is null then ' has all rules with action attached'
        when (jsonb_typeof(attributes_std -> 'rules') = 'array') and a.name is not null then ' has rules with no action attached'
        when (attributes_std -> 'rules' ->> 'action') is not null then ' has rule with action attached'
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

query "waf_regional_web_acl_rule_with_action" {
  sql = <<-EOQ
    with rules_without_action as (
      select
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
        case jsonb_typeof(attributes_std -> 'rule')
          when 'array' then (attributes_std -> 'rule')
          else null end
        ) as r
      where
       ( r -> 'action' is null or (r -> 'action' = '{}'))
        and type = 'aws_wafregional_web_acl'
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when (jsonb_typeof(attributes_std -> 'rule') = 'array') and a.name is null then 'ok'
        when (jsonb_typeof(attributes_std -> 'rule') = 'array') and a.name is not null then 'alarm'
        when ((attributes_std -> 'rule' ->> 'action') is not null) then 'ok'
        else 'alarm'
      end as status,
      r.address || case
        when (jsonb_typeof(attributes_std -> 'rule') = 'array') and a.name is null then ' has all rules with action attached'
        when (jsonb_typeof(attributes_std -> 'rule') = 'array') and a.name is not null then ' has rules with no action attached'
        when ((attributes_std -> 'rule' ->> 'action') is not null) then ' has rule with action attached'
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
