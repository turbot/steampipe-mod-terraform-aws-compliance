benchmark "aws_s3" {
  title = "AWS S3 Best Practices"
  description = "Best practices for your AWS S3 resources."
  children = [
    benchmark.aws_s3_bucket
  ]
}

benchmark "aws_s3_bucket" {
  title = "AWS S3 Bucket Best Practices"
  description = "Best practices for your AWS S3 buckets."
  children = [
    control.aws_s3_account_block_public_access,
    control.aws_s3_bucket_versioning_enabled
  ]
}

control "aws_s3_account_block_public_access" {
  title = "AWS S3 account should block public access"
  description = "AWS S3 account should block all public access."
  sql = <<-EOT
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'block_public_acls')::bool
          and (arguments -> 'block_public_policy')::bool
          and (arguments -> 'ignore_public_acls')::bool
          and (arguments -> 'restrict_public_buckets')::bool
        then 'ok'
        -- Alarm if properties are set to false or aren't defined
        else 'alarm'
      end as status,
      -- TODO: Improve the message, differentiating between undefined/false properties
      name || case
        when (arguments -> 'block_public_acls')::bool
          and (arguments -> 'block_public_policy')::bool
          and (arguments -> 'ignore_public_acls')::bool
          and (arguments -> 'restrict_public_buckets')::bool
        then ' account level public access blocks enabled.'
        else ' account level public access not enabled for: ' ||
          concat_ws(', ',
            case when (arguments -> 'block_public_acls' is null or not (arguments -> 'block_public_acls')::bool) then 'block_public_acls' end,
            case when (arguments -> 'block_public_policy' is null or not (arguments -> 'block_public_policy')::bool) then 'block_public_policy' end,
            case when arguments -> 'ignore_public_acls' is null or not (arguments -> 'ignore_public_acls')::bool then 'ignore_public_acls' end,
            case when (arguments -> 'restrict_public_buckets' is null or not (arguments -> 'restrict_public_buckets')::bool) then 'restrict_public_buckets' end
          ) || '.'
      end as reason,
      path
    from
      terraform_resource
    where
      type = 'aws_s3_account_public_access_block'
  EOT
}

control "aws_s3_bucket_versioning_enabled" {
  title = "AWS S3 buckets should have versioning enabled"
  description = "AWS S3 buckets should have versioning enabled."
  sql = <<-EOT
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'versioning' -> 'enabled')::bool then 'ok'
        -- Alarm if property is set to false or isn't defined
        else 'alarm'
      end as status,
      name || case
        when arguments -> 'versioning' is null then ' versioning is not defined'
        when arguments -> 'versioning' -> 'enabled' is null then ' versioning.enabled is not defined'
        when (arguments -> 'versioning' -> 'enabled')::bool then ' versioning is enabled' else ' versioning is disabled'
      end || '.' as reason,
      path
    from
      terraform_resource
    where
      type = 'aws_s3_bucket'
  EOT
}
