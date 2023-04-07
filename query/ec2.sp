query "ec2_classic_lb_connection_draining_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'connection_draining') is null then 'alarm'
        when (arguments -> 'connection_draining')::bool then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'connection_draining') is null then ' ''connection_draining'' disabled'
        when (arguments -> 'connection_draining')::bool then ' ''connection_draining'' enabled'
        else ' ''connection_draining'' disabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elb';
  EOQ
}

query "ec2_ebs_default_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enabled') is null then 'alarm'
        when (arguments ->> 'enabled')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'enabled') is null then ' ''enabled'' is not defined'
        when (arguments ->> 'enabled')::bool then ' default EBS encryption enabled'
        else ' default EBS encryption disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ebs_encryption_by_default';
  EOQ
}

query "ec2_instance_detailed_monitoring_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when  (arguments ->> 'monitoring')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when  (arguments ->> 'monitoring')::bool is true then ' detailed monitoring enabled'
        else ' detailed monitoring disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_ebs_optimized" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when  (arguments -> 'ebs_optimized')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when  (arguments -> 'ebs_optimized')::bool is true then ' EBS optimization enabled'
        else ' EBS optimization disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'associate_public_ip_address') is null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'associate_public_ip_address') is null then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_not_use_default_vpc" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'subnet_id') is null then 'skip'
        when split_part((arguments ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (arguments ->> 'vpc_id') like '%default%') then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'subnet_id') is null then ' does not have a subnet id defined'
        when split_part((arguments ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (arguments ->> 'vpc_id') like '%default%') then ' deployed to a default VPC'
        else ' not deployed to a default VPC'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_not_use_multiple_enis" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'network_interface') is null then 'skip'
        when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object'  then 'ok'
        else 'alarm'
      end status,
      name || case
        when jsonb_typeof(arguments -> 'network_interface') is null then ' has no ENI attached'
        when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object' then ' has 1 ENI attached'
        else ' has ' || (jsonb_array_length(arguments -> 'network_interface')) || ' ENI(s) attached'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_termination_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when  (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then ' instance termination protection enabled'
        else ' instance termination protection disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_uses_imdsv2" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments -> 'metadata_options' ->> 'http_tokens'),'') in ('optional', '') then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'metadata_options' -> 'http_tokens') is null then ' ''http_tokens'' is not defined'
        when (arguments -> 'metadata_options' ->> 'http_tokens') = 'optional'
        then ' not configured to use Instance Metadata Service Version 2 (IMDSv2)'
        else ' configured to use Instance Metadata Service Version 2 (IMDSv2)'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}
