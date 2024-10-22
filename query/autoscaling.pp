query "autoscaling_group_with_lb_use_health_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'load_balancers') is null and (attributes_std -> 'target_group_arns') is null then 'alarm'
        when (attributes_std ->> 'health_check_type') <> 'ELB' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'load_balancers') is null and (attributes_std -> 'target_group_arns') is null then ' not associated with a load balancer'
        when (attributes_std ->> 'health_check_type') <> 'ELB' then ' does not use ELB health check'
        else ' uses ELB health check'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_autoscaling_group';
  EOQ
}

query "autoscaling_launch_config_public_ip_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'associate_public_ip_address')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
      when (attributes_std -> 'associate_public_ip_address')::boolean then ' public IP enabled'
        else ' public IP disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_launch_configuration';
  EOQ
}

query "autoscaling_group_uses_launch_template" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'launch_template') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'launch_template') is null then ' not using launch template'
        else ' using launch template'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_autoscaling_group';
  EOQ
}

query "autoscaling_group_tagging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'tag') is not null or (attributes_std -> 'tags') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'tag') is not null or (attributes_std -> 'tags') is not null then ' tagging enabled'
        else ' tagging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_autoscaling_group';
  EOQ
}