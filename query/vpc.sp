query "vpc_default_security_group_restricts_all_traffic" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'egress') is null and (attributes_std -> 'ingress') is null then 'ok'
        else 'alarm'
      end as status,
      case
        when (attributes_std -> 'ingress') is not null and (attributes_std -> 'egress') is not null then 'Default security group ' || split_part(address, '.', 2) || ' has inbound and outbound rules'
        when (attributes_std -> 'ingress') is not null and (attributes_std -> 'egress') is null then 'Default security group ' || split_part(address, '.', 2) || ' has inbound rules'
        when (attributes_std -> 'ingress') is null and (attributes_std -> 'egress') is not null then 'Default security group ' || split_part(address, '.', 2) || ' has outbound rules'
        else 'Default security group ' || split_part(address, '.', 2) || ' has no inbound or outbound rules'
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
      address as resource,
      case
        when (attributes_std -> 'vpc') is null then 'skip'
        when (attributes_std -> 'instance') is not null or (attributes_std -> 'network_interface') is not null then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'vpc') is null then ' not associated with VPC'
        when (attributes_std -> 'instance') is not null or (attributes_std -> 'network_interface') is not null then ' associated with an instance or network interface'
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
        attributes_std ->> 'vpc_id' as flow_log_vpc_id
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
      a.address as resource,
      case
        when b.flow_log_vpc_id is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(a.address, '.', 2) || case
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
      address as resource,
      case
        when name in (select split_part((attributes_std ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
      when name in (select split_part((attributes_std ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then ' has internet gateway attachment(s)'
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
      address as resource,
      case
        when (attributes_std -> 'subnet_ids') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'subnet_ids') is null then ' not associated with subnets'
        else ' associated with ' || (jsonb_array_length(attributes_std -> 'subnet_ids')) || ' subnet(s)'
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
      address as resource,
      case
        when name in (select split_part((jsonb_array_elements(attributes_std -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
      when name in (select split_part((jsonb_array_elements(attributes_std -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then ' has attached ENI(s)'
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
      address as resource,
      case
        when (attributes_std -> 'description') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'description') is null then ' no description defined'
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
      address as resource,
      case
        when (attributes_std -> 'description') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'description') is null then ' no description defined'
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
      address as resource,
      case
        when (attributes_std -> 'map_public_ip_on_launch') is null then 'ok'
        when (attributes_std ->> 'map_public_ip_on_launch')::boolean then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'map_public_ip_on_launch') is null then ' ''map_public_ip_on_launch'' disabled'
        when (attributes_std ->> 'map_public_ip_on_launch')::boolean then ' ''map_public_ip_on_launch'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'acceptance_required') is null then 'alarm'
        when (attributes_std ->> 'acceptance_required')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'acceptance_required') is null then ' ''acceptance_required'' not defined'
        when (attributes_std ->> 'acceptance_required')::boolean then ' ''acceptance_required'' enabled'
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
      address as resource,
      case
        when (attributes_std -> 'endpoint_type') is null then 'alarm'
        when (attributes_std ->> 'endpoint_type') in ('VPC', 'VPC_ENDPOINT') then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'endpoint_type') is null then ' publicly accessible'
        when (attributes_std ->> 'endpoint_type') in ('VPC', 'VPC_ENDPOINT') then ' not publicly accessible'
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
      address as resource,
      case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_configuration' ->> 'key_id') is null then ' not encrypted with KMS CMK'
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
      address as resource,
      case
        when (attributes_std ->> 'delete_protection')::boolean then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'delete_protection')::boolean is null then ' deletion protection not set'
        when (attributes_std ->> 'delete_protection')::boolean then ' deletion protection enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'auto_accept_shared_attachments') = 'enable' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'auto_accept_shared_attachments') = 'enable' then ' automatically accept VPC attachment requests'
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
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'ingress')
            when 'array' then (attributes_std -> 'ingress')
            else jsonb_build_array(attributes_std -> 'ingress')
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
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts FTP data port 20 access from the internet'
        else ' allows FTP data port 20 access from the internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.address
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_ftp_port_21_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'ingress')
            when 'array' then (attributes_std -> 'ingress')
            else jsonb_build_array(attributes_std -> 'ingress')
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
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts FTP port 21 access from the internet'
        else ' allows FTP port 21 access from the internet'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.address
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_ssh_port_22_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'ingress')
            when 'array' then (attributes_std -> 'ingress')
            else jsonb_build_array(attributes_std -> 'ingress')
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
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts SSH access from the internet through port 22'
        else ' allows SSH access from the internet through port 22'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.address
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_allow_rdp_port_3389_ingress" {
  sql = <<-EOQ
    with rules as (
      select distinct
        address as name
      from
        terraform_resource,
        jsonb_array_elements(
          case jsonb_typeof(attributes_std -> 'ingress')
            when 'array' then (attributes_std -> 'ingress')
            else jsonb_build_array(attributes_std -> 'ingress')
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
      r.address as resource,
      case
        when g.name is null then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || case
        when g.name is null then ' restricts RDP access from the internet through port 3389'
        else ' allows RDP access from the internet through port 3389'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join rules as g on g.name = r.address
    where
      type = 'aws_network_acl';
  EOQ
}

query "vpc_network_acl_rule_restrict_ingress_ports_all" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'egress') = 'true' then 'skip'
        when (attributes_std ->> 'rule_action') = 'allow' and (attributes_std -> 'from_port') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'egress') = 'true' then ' is egress rule'
        when (attributes_std ->> 'rule_action') = 'allow' and (attributes_std -> 'from_port') is null then ' allows access to all ports'
        else ' restricts access to all ports'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_network_acl_rule';
  EOQ
}

query "vpc_transfer_server_allows_only_secure_protocols" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'protocols') @> '["FTP"]' then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'protocols') @> '["FTP"]' then ' allows unsecure protocols'
        else ' allows only secure protocols'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_transfer_server';
  EOQ
}