query "config_aggregator_enabled_all_regions" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'account_aggregation_source' ->> 'all_regions')::boolean then 'ok'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'account_aggregation_source' ->> 'all_regions')::boolean then ' enabled in all regions'
        else ' not enabled in all regions'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_config_configuration_aggregator';
  EOQ
}
