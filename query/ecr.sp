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
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ecr_repository';
  EOQ
}
