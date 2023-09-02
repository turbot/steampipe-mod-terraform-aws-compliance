query "vpc_default_security_group_restricts_all_traffic" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'egress') is null and (arguments -> 'ingress') is null then 'ok'
        else 'alarm'
      end as status,
      case
        when (arguments -> 'ingress') is not null and (arguments -> 'egress') is not null then 'Default security group ' || name || ' has inbound and outbound rules'
        when (arguments -> 'ingress') is not null and (arguments -> 'egress') is null then 'Default security group ' || name || ' has inbound rules'
        when (arguments -> 'ingress') is null and (arguments -> 'egress') is not null then 'Default security group ' || name || ' has outbound rules'
        else 'Default security group ' || name || ' has no inbound or outbound rules'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_default_security_group';
  EOQ
}

query "vpc_eip_associated" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'vpc') is null then 'skip'
        when (arguments -> 'instance') is not null or (arguments -> 'network_interface') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'vpc') is null then ' not associated with VPC'
        when (arguments -> 'instance') is not null or (arguments -> 'network_interface') is not null then ' associated with an instance or network interface'
        else ' not associated with an instance or network interface'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_eip';
  EOQ
}

query "vpc_flow_logs_enabled" {
  sql = <<-EOQ
    with flow_logs as (
      select
        arguments ->> 'vpc_id' as flow_log_vpc_id
      from
        terraform_resource
      where
        type = 'aws_flow_log'
    ), all_vpc as (
        select
          '\$\{aws_vpc.' || name || '.id}' as vpc_id,
          *
        from
          terraform_resource
        where
          type = 'aws_vpc'
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when b.flow_log_vpc_id is not null then 'ok'
        else 'alarm'
      end as status,
      a.name || case
        when b.flow_log_vpc_id is not null then ' flow logging enabled'
        else ' flow logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      all_vpc as a
      left join flow_logs as b on a.vpc_id = b.flow_log_vpc_id;
  EOQ
}

query "vpc_igw_attached_to_authorized_vpc" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then 'ok'
        else 'alarm'
      end status,
      name || case
      when name in (select split_part((arguments ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then ' has internet gateway attachment(s)'
      else ' has no internet gateway attachment(s)'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_vpc';
  EOQ
}

query "vpc_network_acl_unused" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'subnet_ids') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'subnet_ids') is null then ' not associated with subnets'
        else ' associated with ' || (jsonb_array_length(arguments -> 'subnet_ids')) || ' subnet(s)'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_security_group_associated_to_eni" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((jsonb_array_elements(arguments -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then 'ok'
        else 'alarm'
      end status,
      name || case
      when name in (select split_part((jsonb_array_elements(arguments -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then ' has attached ENI(s)'
      else ' has no attached ENI(s)'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_security_group';
  EOQ
}

query "vpc_security_group_description_for_rules" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'description') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'description') is null then ' no description defined'
        else ' description defined'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_security_group';
  EOQ
}

query "vpc_security_group_rule_description_for_rules" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'description') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'description') is null then ' no description defined'
        else ' description defined'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_security_group_rule';
  EOQ
}

query "vpc_subnet_auto_assign_public_ip_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'map_public_ip_on_launch') is null then 'ok'
        when (arguments ->> 'map_public_ip_on_launch')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'map_public_ip_on_launch') is null then ' ''map_public_ip_on_launch'' disabled'
        when (arguments ->> 'map_public_ip_on_launch')::boolean then ' ''map_public_ip_on_launch'' enabled'
        else ' ''map_public_ip_on_launch'' disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_subnet';
  EOQ
}

query "vpc_endpoint_service_acceptance_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'acceptance_required') is null then 'alarm'
        when (arguments ->> 'acceptance_required')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'acceptance_required') is null then ' ''acceptance_required'' not defined'
        when (arguments ->> 'acceptance_required')::boolean then ' ''acceptance_required'' enabled'
        else ' ''acceptance_required'' disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_vpc_endpoint_service';
  EOQ
}

query "vpc_transfer_server_not_publicly_accesible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'endpoint_type') is null then 'alarm'
        when (arguments ->> 'endpoint_type') in ('VPC', 'VPC_ENDPOINT') then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'endpoint_type') is null then ' publicly accessible'
        when (arguments ->> 'endpoint_type') in ('VPC', 'VPC_ENDPOINT')  then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_transfer_server';
  EOQ
}


query "vpc_network_firewall_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_networkfirewall_firewall';
  EOQ
}

query "vpc_network_firewall_rule_group_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_networkfirewall_rule_group';
  EOQ
}

query "vpc_network_firewall_policy_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_networkfirewall_firewall_policy';
  EOQ
}

query "vpc_network_firewall_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'delete_protection')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'delete_protection')::boolean is null then ' deletion protection not set'
        when (arguments ->> 'delete_protection')::boolean then ' deletion protection enabled'
        else ' deletion protection disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_networkfirewall_firewall';
  EOQ
}

query "vpc_ec2_transit_gateway_auto_accept_attachment_requests_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'auto_accept_shared_attachments') = 'enable' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'auto_accept_shared_attachments') = 'enable' then ' automatically accept VPC attachment requests'
        else ' do not automatically accept VPC attachment requests'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ec2_transit_gateway';
  EOQ
}

query "vpc_network_acl_allow_ftp_port_20_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(arguments -> 'ingress')
            when 'array' then (arguments -> 'ingress')
            else jsonb_build_array(arguments -> 'ingress')
          end
          ) ingress
      where
        type = 'aws_network_acl' and
        ingress is not null and
        (ingress ->> 'cidr_block' = '0.0.0.0/0' or ingress ->> 'ipv6_cidr_block' = '::/0')
        and ingress ->> 'action' = 'allow'
        and (
          ingress ->> 'protocol' = '-1' or
          (ingress ->> 'from_port') :: integer >= 20 or
          (ingress ->> 'to_port') :: integer <= 20
        )
    )
    select
      type || ' ' || r.name as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when g.name is null then ' restricts FTP access from internet through port 20'
        else ' allows FTP access from internet through port 20'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.name
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_ftp_port_21_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(arguments -> 'ingress')
            when 'array' then (arguments -> 'ingress')
            else jsonb_build_array(arguments -> 'ingress')
          end
          ) ingress
      where
        type = 'aws_network_acl' and
        ingress is not null and
        (ingress ->> 'cidr_block' = '0.0.0.0/0' or ingress ->> 'ipv6_cidr_block' = '::/0')
        and ingress ->> 'action' = 'allow'
        and (
          ingress ->> 'protocol' = '-1' or
          (ingress ->> 'from_port') :: integer >= 21 or
          (ingress ->> 'to_port') :: integer <= 21
        )
    )
    select
      type || ' ' || r.name as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when g.name is null then ' restricts FTP access from internet through port 21'
        else ' allows FTP access from internet through port 21'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.name
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_ssh_port_22_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(arguments -> 'ingress')
            when 'array' then (arguments -> 'ingress')
            else jsonb_build_array(arguments -> 'ingress')
          end
          ) ingress
      where
        type = 'aws_network_acl' and
        ingress is not null and
        (ingress ->> 'cidr_block' = '0.0.0.0/0' or ingress ->> 'ipv6_cidr_block' = '::/0')
        and ingress ->> 'action' = 'allow'
        and (
          ingress ->> 'protocol' = '-1' or
          (ingress ->> 'from_port') :: integer >= 22 or
          (ingress ->> 'to_port') :: integer <= 22
        )
    )
    select
      type || ' ' || r.name as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when g.name is null then ' restricts SSH access from internet through port 22'
        else ' allows SSH access from internet through port 22'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.name
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_rdp_port_3389_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(arguments -> 'ingress')
            when 'array' then (arguments -> 'ingress')
            else jsonb_build_array(arguments -> 'ingress')
          end
          ) ingress
      where
        type = 'aws_network_acl' and
        ingress is not null and
        (ingress ->> 'cidr_block' = '0.0.0.0/0' or ingress ->> 'ipv6_cidr_block' = '::/0')
        and ingress ->> 'action' = 'allow'
        and (
          ingress ->> 'protocol' = '-1' or
          (ingress ->> 'from_port') :: integer >= 3389 or
          (ingress ->> 'to_port') :: integer <= 3389
        )
    )
    select
      type || ' ' || r.name as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      r.name || case
        when g.name is null then ' restricts RDP access from internet through port 3389'
        else ' allows RDP access from internet through port 3389'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.name
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_rule_restrict_ingress_ports_all" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'egress') = 'true' then 'skip'
        when (arguments ->> 'rule_action') = 'allow' and (arguments -> 'from_port') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'egress') = 'true' then ' is egress rule'
        when (arguments ->> 'rule_action') = 'allow' and (arguments -> 'from_port') is null then ' allows access to all port'
        else ' restricts access to all port'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_network_acl_rule';
  EOQ
}