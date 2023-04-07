query "iam_account_password_policy_min_length_14" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'minimum_password_length') is null then 'alarm'
        when (arguments -> 'minimum_password_length')::integer >= 14 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'minimum_password_length') is null then ' ''minimum_password_length'' is not defined'
        when (arguments -> 'minimum_password_length')::integer >= 14 then ' ''minimum_password_length'' is set and greater than 14'
        else ' ''minimum_password_length'' is set and less than 14'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_one_lowercase_letter" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'require_lowercase_characters') is null then 'alarm'
        when (arguments -> 'require_lowercase_characters')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'require_lowercase_characters') is null then ' lowercase character not set to required'
        when (arguments -> 'require_lowercase_characters')::boolean then ' lowercase character set to required'
        else ' lowercase character not set to required'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_one_number" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'require_numbers') is null then 'alarm'
        when (arguments -> 'require_numbers')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'require_numbers') is null then ' number not set to required'
        when (arguments -> 'require_numbers')::bool then ' number set to required'
        else ' number not set to required'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_one_symbol" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'require_symbols') is null then 'alarm'
        when (arguments -> 'require_symbols')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'require_symbols') is null then ' symbol not set to required'
        when (arguments -> 'require_symbols')::boolean then ' symbol set to required'
        else ' symbol not set to required'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_one_uppercase_letter" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'require_uppercase_characters') is null then 'alarm'
        when (arguments -> 'require_uppercase_characters')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'require_uppercase_characters') is null then ' ''require_uppercase_characters'' not defined'
        when (arguments -> 'require_uppercase_characters')::boolean then ' uppercase characters set to required'
        else ' uppercase characters not set to required'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_reuse_24" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'password_reuse_prevention') is null then 'alarm'
        when (arguments -> 'password_reuse_prevention')::integer >= 24 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'password_reuse_prevention') is null then ' password reuse prevention not set'
        when (arguments -> 'password_reuse_prevention')::integer >= 24 then ' password reuse prevention set to ' || (arguments ->> 'password_reuse_prevention') || ' days'
        else ' password reuse prevention set to ' || (arguments ->> 'password_reuse_prevention') || ' days'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_strong_min_length_8" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments -> 'minimum_password_length')::integer >= 8
          and (arguments -> 'require_lowercase_characters')::bool
          and (arguments -> 'require_uppercase_characters')::bool
          and (arguments -> 'require_numbers')::bool
          and (arguments -> 'require_symbols')::bool
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'minimum_password_length')::integer >= 8
          and (arguments -> 'require_lowercase_characters')::bool
          and (arguments -> 'require_uppercase_characters')::bool
          and (arguments -> 'require_numbers')::bool
          and (arguments -> 'require_symbols')::bool
        then ' Strong password policies configured'
        else ' Strong password policies not configured'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_account_password_policy_strong" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments -> 'minimum_password_length')::integer >= 14
          and (arguments -> 'require_lowercase_characters')::bool
          and (arguments -> 'require_uppercase_characters')::bool
          and (arguments -> 'require_numbers')::bool
          and (arguments -> 'require_symbols')::bool
          and (arguments -> 'password_reuse_prevention')::integer >= 24
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'minimum_password_length')::integer >= 14
          and (arguments -> 'require_lowercase_characters')::bool
          and (arguments -> 'require_uppercase_characters')::bool
          and (arguments -> 'require_numbers')::bool
          and (arguments -> 'require_symbols')::bool
          and (arguments -> 'password_reuse_prevention')::integer >= 24
        then ' Strong password policies configured'
        else ' Strong password policies not configured'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}

query "iam_password_policy_expire_90" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'max_password_age') is null then 'alarm'
        when (arguments -> 'max_password_age')::integer <= 90 then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'max_password_age') is null then ' password expiration not set'
        when (arguments -> 'max_password_age')::integer <= 90 then ' password expiration set to ' || (arguments ->> 'max_password_age') || ' days'
        else ' password expiration set to ' || (arguments ->> 'max_password_age') || ' days'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_iam_account_password_policy';
  EOQ
}
