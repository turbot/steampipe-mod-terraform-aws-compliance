query "mq_broker_audit_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'engine_type') = 'RabbitMQ') and (arguments -> 'logs' ->> 'audit')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'engine_type') = 'RabbitMQ') and (arguments -> 'logs' ->> 'audit')::bool is null then ' audit logging enabled'
        else ' audit logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}

query "mq_broker_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments -> 'encryption_option' ->> 'use_aws_owned_key')::bool and (arguments -> 'encryption_option' ->> 'kms_key_id') is null) then 'alarm'
        else 'ok'
      end as status,
      name || case
        when ((arguments -> 'encryption_option' ->> 'use_aws_owned_key')::bool and (arguments -> 'encryption_option' ->> 'kms_key_id') is null) then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}

query "mq_broker_general_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logs' ->> 'general')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logs' ->> 'general')::bool is null then ' general logging enabled'
        else ' general logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}

query "mq_broker_automatic_minor_upgrade_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'auto_minor_version_upgrade')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'auto_minor_version_upgrade')::bool then ' automatic minor version upgrade enabled'
        else ' automatic minor version upgrade disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}

query "mq_broker_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'publicly_accessible')::bool then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'publicly_accessible')::bool then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}

query "mq_broker_currect_broker_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when ((arguments ->> 'engine_type') = 'ActiveMQ' and (regexp_split_to_array(arguments ->> 'engine_version', '\.')::int[] >= regexp_split_to_array('5.16', '\.')::int[])) then 'ok'
        when ((arguments ->> 'engine_type') = 'RabbitMQ' and (regexp_split_to_array(arguments ->> 'engine_version', '\.')::int[] >= regexp_split_to_array('3.8', '\.')::int[])) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when ((arguments ->> 'engine_type') = 'ActiveMQ' and (regexp_split_to_array(arguments ->> 'engine_version', '\.')::int[] >= regexp_split_to_array('5.16', '\.')::int[])) then ' uses current broker version'
        when ((arguments ->> 'engine_type') = 'RabbitMQ' and (regexp_split_to_array(arguments ->> 'engine_version', '\.')::int[] >= regexp_split_to_array('3.8', '\.')::int[])) then ' uses current broker version'
        else ' does not use current broker version'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mq_broker';
  EOQ
}