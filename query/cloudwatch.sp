query "cloudwatch_alarm_action_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'alarm_actions') is null
        and (attributes_std -> 'insufficient_data_actions') is null
        and (attributes_std -> 'ok_actions') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'alarm_actions') is null
        and (attributes_std -> 'insufficient_data_actions') is null
        and (attributes_std -> 'ok_actions') is null then ' no action enabled'
        when (attributes_std -> 'alarm_actions') is not null then ' alarm action enabled'
        when (attributes_std -> 'insufficient_data_actions') is not null then ' insufficient data action enabled.'
        when (attributes_std -> 'ok_actions') is not null then ' ok action enabled.'
        else ' action enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudwatch_metric_alarm';
  EOQ
}

query "cloudwatch_destination_policy_wildcards" {
  sql = <<-EOQ
    with access_policy as (
      select
        name
      from
        terraform_data_source
      where
        type = 'aws_iam_policy_document'
        and (arguments -> 'statement' ->> 'actions') like '%*%'
    ), cloudwatch_log_destination_policy as (
      select
        name,
        type,
        address,
        path,
        start_line,
        _ctx,
        split_part((attributes_std ->> 'access_policy')::text, '.', 3) as ap
      from
        terraform_resource
      where
        type = 'aws_cloudwatch_log_destination_policy'
    )
    select
      a.address as resource,
      case
        when e.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
        when e.name is null then ' policy is ok'
        else ' policy is not ok'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      cloudwatch_log_destination_policy as a
      left join access_policy as e on a.ap = e.name;
  EOQ
}

query "cloudwatch_log_group_retention_period_365" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'retention_in_days') is null or (attributes_std -> 'retention_in_days')::int < 365 then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'retention_in_days') is null then ' retention period not set'
        when (attributes_std -> 'retention_in_days')::int < 365 then ' retention period less than 365 days'
        else ' retention period 365 days or above'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudwatch_log_group';
  EOQ
}

query "log_group_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_key_id') is not null then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudwatch_log_group';
  EOQ
}

query "cloudwatch_log_group_retention" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'retention_in_days') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'retention_in_days') is null then ' retention period not set'
        else ' retention period set'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudwatch_log_group';
  EOQ
}
