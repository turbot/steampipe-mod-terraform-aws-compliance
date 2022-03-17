select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'runtime') is null then 'skip'
    when (arguments ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'runtime') is null then ' runtime not set'
    when (arguments ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then ' uses latest runtime - ' || (arguments ->> 'runtime') || '.'
    else ' uses ' || (arguments ->> 'runtime')|| ' which is not the latest version.'
  end as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_lambda_function';
