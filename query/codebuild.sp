query "codebuild_project_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim(arguments ->> 'encryption_key'), '') = '' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim(arguments ->> 'encryption_key'), '') = '' then ' not encrypted at rest'
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
            case jsonb_typeof( arguments -> 'environment' -> 'environment_variable')
              when 'array' then (arguments -> 'environment' -> 'environment_variable')
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
        or ((arguments -> 'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and arguments -> 'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then 'alarm'
        else 'ok'
      end status,
      a.name || case
        when b.name is not null
        or ((arguments -> 'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and arguments -> 'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then ' has plaintext environment variables with sensitive AWS values'
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
        when (a.arguments -> 'source' ->> 'type') not in ('GITHUB', 'BITBUCKET') then 'skip'
        when (b.arguments ->> 'auth_type') = 'OAUTH' then 'ok'
        else 'alarm'
      end as status,
      case
        when (a.arguments -> 'source' ->> 'type') = 'NO_SOURCE' then ' doesn''t have input source code.'
        when (a.arguments -> 'source' ->> 'type') not in ('GITHUB', 'BITBUCKET') then ' source code isn''t in GitHub/Bitbucket repository'
        when (b.arguments ->> 'auth_type') = 'OAUTH' then ' using OAuth to connect source repository'
        else ' not using OAuth to connect source repository'
      end || '.' reason
      ${replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      codebuild_projects as a
      left join codebuild_source_credential as b on (b.arguments -> 'server_type') = (a.arguments -> 'source' -> 'type');
  EOQ
}

query "codebuild_project_s3_logs_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_extract_path_text(arguments, 'logs_config', 's3_logs', 'encryption_disabled')::boolean then 'alarm'
        else 'ok'
      end as status,
      name || case
        when jsonb_extract_path_text(arguments, 'logs_config', 's3_logs', 'encryption_disabled')::boolean then ' not encrypted at rest'
        else ' encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project'
  EOQ
}

query "codebuild_project_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_extract_path_text(arguments, 'logs_config', 'cloudwatch_logs') is not null
        or jsonb_extract_path_text(arguments, 'logs_config', 's3_logs') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when jsonb_extract_path_text(arguments, 'logs_config', 'cloudwatch_logs') is not null
        or jsonb_extract_path_text(arguments, 'logs_config', 's3_logs') is not null then ' logging enabled'
        else ' logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_codebuild_project'
  EOQ
}