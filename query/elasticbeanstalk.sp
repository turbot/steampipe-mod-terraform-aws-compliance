query "elasticbeanstalk_use_managed_updates" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (setting ->> 'name') = 'ManagedActionsEnabled' and (setting ->> 'value')::boolean) then 'ok'
        when jsonb_typeof(arguments -> 'setting') = 'object' and (arguments -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (arguments -> 'setting' ->> 'name') = 'ManagedActionsEnabled' and (arguments -> 'setting' ->> 'value')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when jsonb_typeof(arguments -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (setting ->> 'name') = 'ManagedActionsEnabled' and (setting ->> 'value')::boolean) then ' managed updates enabled'
        when jsonb_typeof(arguments -> 'setting') = 'object' and (arguments -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:managedactions' and (arguments -> 'setting' ->> 'name') = 'ManagedActionsEnabled' and (arguments -> 'setting' ->> 'value')::boolean then ' managed updates enabled'
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

query "elasticbeanstalk_use_enhanced_health_checks" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (setting ->> 'name') = 'HealthStreamingEnabled' and (setting ->> 'value')::boolean) then 'ok'
        when jsonb_typeof(arguments -> 'setting') = 'object' and (arguments -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (arguments -> 'setting' ->> 'name') = 'HealthStreamingEnabled' and (arguments -> 'setting' ->> 'value')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when jsonb_typeof(arguments -> 'setting') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'setting') as setting where (setting ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (setting ->> 'name') = 'HealthStreamingEnabled' and (setting ->> 'value')::boolean) then ' health streaming enabled'
        when jsonb_typeof(arguments -> 'setting') = 'object' and (arguments -> 'setting' ->> 'namespace') = 'aws:elasticbeanstalk:healthreporting:system' and (arguments -> 'setting' ->> 'name') = 'HealthStreamingEnabled' and (arguments -> 'setting' ->> 'value')::boolean then ' health streaming enabled'
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