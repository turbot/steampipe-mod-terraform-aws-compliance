query "elasticbeanstalk_environment_use_managed_updates" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when jsonb_typeof(attributes_std -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (setting ->> 'name') = 'ManagedActionsEnabled' and (setting ->> 'value')::boolean) then 'ok'
        when jsonb_typeof(attributes_std -> 'setting') = 'object' and (attributes_std -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (attributes_std -> 'setting' ->> 'name') = 'ManagedActionsEnabled' and (attributes_std -> 'setting' ->> 'value')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when jsonb_typeof(attributes_std -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (setting ->> 'name') = 'ManagedActionsEnabled' and (setting ->> 'value')::boolean) then ' managed updates enabled'
        when jsonb_typeof(attributes_std -> 'setting') = 'object' and (attributes_std -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (attributes_std -> 'setting' ->> 'name') = 'ManagedActionsEnabled' and (attributes_std -> 'setting' ->> 'value')::boolean then ' managed updates enabled'
        else ' managed updates disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elastic_beanstalk_environment';
  EOQ
}

query "elasticbeanstalk_environment_use_enhanced_health_checks" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when jsonb_typeof(attributes_std -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (setting ->> 'name') = 'HealthStreamingEnabled' and (setting ->> 'value')::boolean) then 'ok'
        when jsonb_typeof(attributes_std -> 'setting') = 'object' and (attributes_std -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (attributes_std -> 'setting' ->> 'name') = 'HealthStreamingEnabled' and (attributes_std -> 'setting' ->> 'value')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when jsonb_typeof(attributes_std -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(attributes_std -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (setting ->> 'name') = 'HealthStreamingEnabled' and (setting ->> 'value')::boolean) then ' health streaming enabled'
        when jsonb_typeof(attributes_std -> 'setting') = 'object' and (attributes_std -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (attributes_std -> 'setting' ->> 'name') = 'HealthStreamingEnabled' and (attributes_std -> 'setting' ->> 'value')::boolean then ' health streaming enabled'
        else ' health streaming disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elastic_beanstalk_environment';
  EOQ
}
