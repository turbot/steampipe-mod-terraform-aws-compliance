query "ec2_classic_lb_connection_draining_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'connection_draining') is null then 'alarm'
        when (attributes_std -> 'connection_draining')::bool then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'connection_draining') is null then ' ''connection_draining'' disabled'
        when (attributes_std -> 'connection_draining')::bool then ' ''connection_draining'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'enabled') is null then 'alarm'
        when (attributes_std ->> 'enabled')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enabled') is null then ' ''enabled'' is not defined'
        when (attributes_std ->> 'enabled')::bool then ' default EBS encryption enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'monitoring')::bool is true then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'monitoring')::bool is true then ' detailed monitoring enabled'
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
      address as resource,
      case
        when (attributes_std -> 'ebs_optimized')::bool is true then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ebs_optimized')::bool is true then ' EBS optimization enabled'
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
      address as resource,
      case
        when (attributes_std -> 'associate_public_ip_address') is null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'associate_public_ip_address') is null then ' not publicly accessible'
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
      address as resource,
      case
        when (attributes_std -> 'subnet_id') is null then 'skip'
        when split_part((attributes_std ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (attributes_std ->> 'vpc_id') like '%default%') then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'subnet_id') is null then ' does not have a subnet id defined'
        when split_part((attributes_std ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (attributes_std ->> 'vpc_id') like '%default%') then ' deployed to a default VPC'
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
      address as resource,
      case
        when jsonb_typeof(attributes_std -> 'network_interface') is null then 'skip'
        when (jsonb_typeof(attributes_std -> 'network_interface'))::text = 'object' then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when jsonb_typeof(attributes_std -> 'network_interface') is null then ' has no ENI attached'
        when (jsonb_typeof(attributes_std -> 'network_interface'))::text = 'object' then ' has 1 ENI attached'
        else ' has ' || (jsonb_array_length(attributes_std -> 'network_interface')) || ' ENI(s) attached'
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
      address as resource,
      case
        when (attributes_std -> 'root_block_device' ->> 'delete_on_termination')::bool is true then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'root_block_device' ->> 'delete_on_termination')::bool is true then ' instance termination protection enabled'
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
      address as resource,
      case
        when coalesce(trim(attributes_std -> 'metadata_options' ->> 'http_tokens'),'') in ('optional', '') then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'metadata_options' -> 'http_tokens') is null then ' ''http_tokens'' is not defined'
        when (attributes_std -> 'metadata_options' ->> 'http_tokens') = 'optional'
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
      address as resource,
      case
        when (attributes_std ->> 'user_data') is null then 'skip'
        when (attributes_std ->> 'user_data') like any (array ['%pass%', '%secret%','%token%','%key%'])
          or (attributes_std ->> 'user_data') ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'user_data') is null then ' no user data defined.'
        when (attributes_std ->> 'user_data') like any (array ['%pass%', '%secret%','%token%','%key%'])
          or (attributes_std ->> 'user_data') ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]' then ' potential secret found in user data.'
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

query "ec2_ami_imagebuilder_component_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_id') is null then ' is not encrypted with CMK'
        else ' is encrypted with CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_component';
  EOQ
}

query "ec2_ami_imagebuilder_distribution_configuration_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'distribution' -> 'ami_distribution_configuration' ->> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'distribution' -> 'ami_distribution_configuration' ->> 'kms_key_id') is null then ' is not encrypted with CMK'
        else ' is encrypted with CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_distribution_configuration';
  EOQ
}

query "ec2_ami_imagebuilder_image_recipe_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'kms_key_id') is null or (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') <> 'true' or (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'kms_key_id') is null or (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') <> 'true' or (attributes_std -> 'block_device_mapping' -> 'ebs' ->> 'encrypted') is null then ' is not encrypted with CMK'
        else ' is encrypted with CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_imagebuilder_image_recipe';
  EOQ
}

query "ec2_launch_template_metadata_hop_limit_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'metadata_options' ->> 'http_put_response_hop_limit')::int > 1 then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'metadata_options' ->> 'http_put_response_hop_limit')::int > 1 then ' metadata response hop limit value is greater than 1'
        else ' metadata response hop limit value is not less than 1'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_launch_template';
  EOQ
}

query "ec2_launch_configuration_metadata_hop_limit_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'metadata_options' ->> 'http_put_response_hop_limit')::int > 1 then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'metadata_options' ->> 'http_put_response_hop_limit')::int > 1 then ' metadata response hop limit value is greater than 1'
        else ' metadata response hop limit value is less than 1'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_launch_configuration';
  EOQ
}

query "ec2_launch_configuration_ebs_encryption_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'root_block_device') is not null and ((attributes_std -> 'root_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'root_block_device' ->> 'snapshot_id') is not null) and (((attributes_std -> 'ebs_block_device') is not null and ((attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null)) or ((attributes_std -> 'ebs_block_device') is null)) then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'root_block_device') is not null and ((attributes_std -> 'root_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'root_block_device' ->> 'snapshot_id') is not null) and (((attributes_std -> 'ebs_block_device') is not null and ((attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null)) or ((attributes_std -> 'ebs_block_device') is null)) then ' is securely encrypted'
        else ' is not securely encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_launch_configuration';
  EOQ
}

query "ec2_instance_ebs_encryption_check" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'root_block_device') is not null and ((attributes_std -> 'root_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'root_block_device' ->> 'snapshot_id') is not null) and (((attributes_std -> 'ebs_block_device') is not null and ((attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null)) or ((attributes_std -> 'ebs_block_device') is null)) then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'root_block_device') is not null and ((attributes_std -> 'root_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'root_block_device' ->> 'snapshot_id') is not null) and (((attributes_std -> 'ebs_block_device') is not null and ((attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null)) or ((attributes_std -> 'ebs_block_device') is null)) then ' is securely encrypted'
        else ' is not securely encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_instance';
  EOQ
}

query "ec2_ami_copy_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'encrypted') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'encrypted') = 'true' then ' is encrypted'
        else ' is not encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ami_copy';
  EOQ
}

query "ec2_ami_copy_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_id') is not null then ' is encrypted with CMK'
        else ' is not encrypted with CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ami_copy';
  EOQ
}

query "ec2_ami_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'ebs_block_device' ->> 'encrypted') = 'true' or (attributes_std -> 'ebs_block_device' ->> 'snapshot_id') is not null then ' is encrypted'
        else ' is not encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ami';
  EOQ
}

query "ec2_ami_launch_permission_restricted" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'account_id') is not null then 'ok'
        when (attributes_std -> 'group') is not null then 'info'
        when (attributes_std -> 'organizational_arn') is not null then 'info'
        when (attributes_std -> 'organizational_unit_arn') is not null then 'info'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'account_id') is not null then ' is restrictive to account(s)'
        when (attributes_std -> 'group') is not null then ' is open to IAM group'
        when (attributes_std -> 'organizational_arn') is not null then ' is open to organization'
        when (attributes_std -> 'organizational_unit_arn') is not null then ' is open to organization unit'
        else ' is wide open'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ami_launch_permission';
  EOQ
}