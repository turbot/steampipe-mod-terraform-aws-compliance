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
      jsonb_array_elements(arguments -> 'environment' -> 'environment_variable') as env
    where
      env ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])
      and env ->> 'type' = 'PLAINTEXT'
)
select
  type || ' ' || a.name as resource,
  case
    when b.name is not null then 'alarm'
    else 'ok'
  end status,
  a.name || case
    when b.name is not null then ' has plaintext environment variables with sensitive AWS values'
    else ' has no plaintext environment variables with sensitive AWS values'
  end || '.' reason,
  path
from
  codebuild_projects as a
  left join invalid_key_name as b on a.name = b.name;