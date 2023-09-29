query "wafv2_web_acl_rule_attached" {
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
      type = 'aws_wafv2_web_acl';
  EOQ
}
