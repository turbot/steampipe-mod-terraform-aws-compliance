query "glacier_vault_restrict_public_access" {
  sql = <<-EOQ
    with glacier_vault_public_policies as (
      select
        distinct (address ) as name
      from
        terraform_resource,
        jsonb_array_elements(
          case when ((attributes_std ->> 'access_policy') = '')
            then null
            else ((attributes_std ->> 'access_policy')::jsonb -> 'Statement') end
        ) as s
      where
        type = 'aws_glacier_vault'
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
        when (attributes_std ->> 'access_policy') = '' then 'ok'
        when p.name is null then 'ok'
        else 'alarm'
      end status,
      split_part(r.address, '.', 2) || case
        when (attributes_std ->> 'access_policy') = '' then ' no policy defined'
        when p.name is null then ' not publicly accessible'
        else ' publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join glacier_vault_public_policies as p on p.name = r.address
    where
      r.type = 'aws_glacier_vault';
  EOQ
}

