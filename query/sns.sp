query "sns_topic_encrypted_at_rest" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when coalesce(trim(attributes_std ->> 'kms_master_key_id'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_master_key_id') is null then ' ''kms_master_key_id'' is not defined'
        when coalesce(trim(attributes_std ->> 'kms_master_key_id'), '') <> '' then ' encryption at rest enabled'
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
        distinct (address ) as name
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((attributes_std ->> 'policy') = '')
            then null
            else ((attributes_std ->> 'policy')::jsonb -> 'Statement') end
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
      r.address as resource,
      case
        when (attributes_std ->> 'policy') = '' then 'ok'
        when p.name is null then 'ok'
        else 'alarm'
      end status,
      split_part(r.address, '.', 2) || case
        when (attributes_std ->> 'policy') = '' then ' no policy defined'
        when p.name is null then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join sns_topic_public_policies as p on p.name = r.address
    where
      r.type = 'aws_sns_topic_policy';
  EOQ
}
