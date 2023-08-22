query "ecr_repository_encrypted_with_kms" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments ->> 'encryption_configuration') is not null
          and coalesce((arguments -> 'encryption_configuration' ->> 'encryption_type'), '') = 'KMS'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments ->> 'encryption_configuration') is not null
          and coalesce((arguments -> 'encryption_configuration' ->> 'encryption_type'), '') = 'KMS'
        then ' encrypted using KMS'
        else ' not encrypted using KMS'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecr_repository';
  EOQ
}

query "ecr_repository_tags_immutable" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'image_tag_mutability')::text = 'IMMUTABLE' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'image_tag_mutability')::text = 'IMMUTABLE' then ' has immutable tags'
        else ' does not have immutable tags'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecr_repository';
  EOQ
}

query "ecr_repository_use_image_scanning" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then ' uses image scanning'
        else ' does not use image scanning'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecr_repository';
  EOQ
}

query "ecr_repository_policy_prohibit_public_access" {
  sql = <<-EOQ
    with policy_statement as (
    select
      distinct (type || ' ' || name ) as name
    from
      terraform_resource ,
      jsonb_array_elements(
        case when ((arguments ->> 'policy') = '')
          then null
          else ((arguments ->> 'policy')::jsonb -> 'Statement') end
    ) as s
    where
      type = 'aws_ecr_repository_policy'
      and (
        (s ->> 'Principal' = '*')
        and ((s ->> 'Condition') is null)
      )
    )
    select
      type || ' ' || r.name as resource,
      case
        when (arguments ->> 'policy') = '' then 'ok'
        when s.name is null then 'ok'
        else 'alarm'
      end status,
      case
        when (arguments ->> 'policy') = '' then ' no policy defined'
        when s.name is null then ' not public'
        else ' public'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join policy_statement as s on s.name = concat(r.type || ' ' || r.name)
    where
      type = 'aws_ecr_repository_policy';
  EOQ
}
