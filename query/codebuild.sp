query "codebuild_project_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when coalesce(trim(attributes_std ->> 'encryption_key'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      address || case
        when coalesce(trim(attributes_std ->> 'encryption_key'), '') = '' then ' not encrypted at rest'
        else ' encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project';
  EOQ
}

query "codebuild_project_plaintext_env_variables_no_sensitive_aws_values" {
  sql = <<-EOQ
    with codebuild_projects as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_codebuild_project'
    ), invalid_key_name as (
        select
          distinct name
        from
          codebuild_projects,
          jsonb_array_elements(
            case jsonb_typeof( attributes_std -> 'environment' -> 'environment_variable')
              when 'array' then (attributes_std -> 'environment' -> 'environment_variable')
              else null end
          ) as env
        where
          env ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])
          and env ->> 'type' = 'PLAINTEXT'
    )
    select
      type || ' ' || a.name as resource,
      case
        when b.name is not null
        or ((attributes_std -> 'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and attributes_std -> 'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then 'alarm'
        else 'ok'
      end status,
      a.address || case
        when b.name is not null
        or ((attributes_std -> 'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and attributes_std -> 'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then ' has plaintext environment variables with sensitive AWS values'
        else ' has no plaintext environment variables with sensitive AWS values'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      codebuild_projects as a
      left join invalid_key_name as b on a.name = b.name;
  EOQ
}

query "codebuild_project_source_repo_oauth_configured" {
  sql = <<-EOQ
    with codebuild_projects as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_codebuild_project'
    ), codebuild_source_credential as (
        select
          *
        from
          terraform_resource
        where
          type = 'aws_codebuild_source_credential'
    )
    select
      a.type || ' ' || a.name as resource,
      case
        when (a.attributes_std -> 'source' ->> 'type') not in ('GITHUB', 'BITBUCKET') then 'skip'
        when (b.attributes_std ->> 'auth_type') = 'OAUTH' then 'ok'
        else 'alarm'
      end as status,
      case
        when (a.attributes_std -> 'source' ->> 'type') = 'NO_SOURCE' then ' doesn''t have input source code.'
        when (a.attributes_std -> 'source' ->> 'type') not in ('GITHUB', 'BITBUCKET') then ' source code isn''t in GitHub/Bitbucket repository'
        when (b.attributes_std ->> 'auth_type') = 'OAUTH' then ' using OAuth to connect source repository'
        else ' not using OAuth to connect source repository'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      codebuild_projects as a
      left join codebuild_source_credential as b on (b.attributes_std -> 'server_type') = (a.attributes_std -> 'source' -> 'type');
  EOQ
}

query "codebuild_project_s3_logs_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logs_config' -> 's3_logs' ->> 'encryption_disabled')::boolean then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'logs_config' -> 's3_logs' ->> 'encryption_disabled')::boolean then ' not encrypted at rest'
        else ' encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project';
  EOQ
}

query "codebuild_project_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logs_config' ->> 'cloudwatch_logs') is not null
        or (attributes_std -> 'logs_config' ->> 's3_logs') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'logs_config' ->> 'cloudwatch_logs') is not null
        or (attributes_std -> 'logs_config' ->> 's3_logs') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project';
  EOQ
}

query "codebuild_project_privileged_mode_disabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'environment' ->> 'privileged_mode')::boolean then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'environment' ->> 'privileged_mode')::boolean then ' has privileged mode enabled'
        else ' has privileged mode disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project';
  EOQ
}