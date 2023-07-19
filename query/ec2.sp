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
      ${local.tag_dimensions_sql}
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
        when (arguments ->> 'monitoring')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'monitoring')::bool is true then ' detailed monitoring enabled'
        else ' detailed monitoring disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
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
        when (arguments -> 'ebs_optimized')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'ebs_optimized')::bool is true then ' EBS optimization enabled'
        else ' EBS optimization disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
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
        when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object' then 'ok'
        else 'alarm'
      end status,
      name || case
        when jsonb_typeof(arguments -> 'network_interface') is null then ' has no ENI attached'
        when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object' then ' has 1 ENI attached'
        else ' has ' || (jsonb_array_length(arguments -> 'network_interface')) || ' ENI(s) attached'
      end || '.' as reason
      ${local.tag_dimensions_sql}
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
        when (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then ' instance termination protection enabled'
        else ' instance termination protection disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_instance_user_data_no_secrets" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'user_data') is null then 'skip'
        when (arguments ->> 'user_data') like any (array ['%pass%', '%secret%','%token%','%key%'])
          or (arguments ->> 'user_data') ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'user_data') is null then ' no user data defined.'
        when (arguments ->> 'user_data') like any (array ['%pass%', '%secret%','%token%','%key%'])
          or (arguments ->> 'user_data') ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]' then ' potential secret found in user data.'
        else ' no secrets found in user data.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_ami_imagebuilder_component_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'kms_key_id') is null then ' is not encrypted with customer-managed CMK'
        else ' is encrypted with customer-managed CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_component';
  EOQ
}

query "ec2_ami_imagebuilder_distribution_configuration_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'distribution' -> 'ami_distribution_configuration' ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'distribution' -> 'ami_distribution_configuration' ->> 'kms_key_id') is null then ' is not encrypted with customer-managed CMK'
        else ' is encrypted with customer-managed CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_distribution_configuration';
  EOQ
}

query "ec2_ami_imagebuilder_image_recipe_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'block_device_mapping' -> 'ebs' ->> 'kms_key_id') is null or (arguments -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') <> 'true' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'block_device_mapping' -> 'ebs' ->> 'kms_key_id') is null or (arguments -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') <> 'true' then ' is not encrypted with customer-managed CMK.'
        else ' is encrypted with customer-managed CMK.'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_image_recipe';
  EOQ
}