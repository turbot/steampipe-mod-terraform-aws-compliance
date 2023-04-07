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
    or ((arguments ->  'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and arguments ->  'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then 'alarm'
    else 'ok'
  end status,
  a.name || case
    when b.name is not null
    or ((arguments ->  'environment' -> 'environment_variable' ->> 'name' ilike any (ARRAY['%AWS_ACCESS_KEY_ID%', '%AWS_SECRET_ACCESS_KEY%', '%PASSWORD%'])) and arguments ->  'environment' -> 'environment_variable' ->> 'type' = 'PLAINTEXT') then ' has plaintext environment variables with sensitive AWS values'
    else ' has no plaintext environment variables with sensitive AWS values'
  end || '.' reason,
  path || ':' || start_line
from
  codebuild_projects as a
  left join invalid_key_name as b on a.name = b.name;