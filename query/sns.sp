query "sns_topic_encrypted_at_rest" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments ->> 'kms_master_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_master_key_id') is null then ' ''kms_master_key_id'' is not defined'
        when coalesce(trim(arguments ->> 'kms_master_key_id'), '') <> '' then ' encryption at rest enabled'
        else ' encryption at rest disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sns_topic';
  EOQ
}

query "sns_topic_policy_restrict_public_access" {
  sql = <<-EOQ
     with sns_topic_public_policies as (
      select
        distinct (type || ' ' || name ) as name,
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((arguments ->> 'policy') = '')
            then null
            else ((arguments ->> 'policy')::jsonb -> 'Statement') end
        ) as s
      where
        type = 'aws_sns_topic_policy'
        and (s ->> 'Effect') = 'Allow'
        and (
          (s ->> 'Principal') = '*'
          or (s -> 'Principal' ->> 'AWS') = '*'
          or (s -> 'Principals' -> 'AWS') @> '["*"]'
          or (s -> 'Principals' -> '*') @> '["*"]'
        )
    )
    select
      type || ' ' || r.name as resource,
      case
        when (arguments ->> 'policy') = '' then 'ok'
        when p.name is null then 'ok'
        else 'alarm'
      end status,
      r.name || case
        when (arguments ->> 'policy') = '' then ' no policy defined'
        when p.name is  null then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join glacier_vault_public_policies as p on p.name = concat(r.type || ' ' || r.name)
    where
      r.type = 'aws_sns_topic_policy';
  EOQ
}