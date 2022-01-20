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
  end || '.' reason,
  a.path
from
  codebuild_projects as a
  left join codebuild_source_credential as b on (b.arguments -> 'server_type') = (a.arguments -> 'source' -> 'type');