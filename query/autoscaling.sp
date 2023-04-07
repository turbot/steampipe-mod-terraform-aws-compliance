query "autoscaling_group_with_lb_use_health_check" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'load_balancers') is null and (arguments -> 'target_group_arns') is null then 'alarm'
        when (arguments ->> 'health_check_type') <> 'ELB' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'load_balancers') is null and (arguments -> 'target_group_arns') is null then ' not associated with a load balancer'
        when (arguments ->> 'health_check_type') <> 'ELB' then ' does not use ELB health check'
        else ' uses ELB health check'
      end || '.' reason
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'associate_public_ip_address')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
      when (arguments -> 'associate_public_ip_address')::boolean then ' public IP enabled'
        else ' public IP disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_launch_configuration';
  EOQ
}
