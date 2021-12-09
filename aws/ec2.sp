benchmark "aws_ec2" {
  title = "AWS EC2 Best Practices"
  description = "Best practices for your AWS EC2 resources."
  children = [
    benchmark.aws_ec2_instance
  ]
}

benchmark "aws_ec2_instance" {
  title = "AWS EC2 Instance Best Practices"
  description = "Best practices for your AWS EC2 instances."
  children = [
    control.aws_ec2_instance_detailed_monitoring_enabled,
    control.aws_ec2_instance_not_publicly_accessible
  ]
}

control "aws_ec2_instance_not_publicly_accessible" {
  title = "AWS EC2 instances should not be publicly accessible"
  description = "AWS EC2 instances should not have public IP addresses associated with them."
  sql = <<-EOT
    select
      type || ' ' || name as resource,
      case
        when not (arguments -> 'associate_public_ip_address')::bool then 'ok'
        -- Alarm if property is set to true or isn't defined
        else 'alarm'
      end as status,
      name || case
        when arguments -> 'associate_public_ip_address' is null then ' associate_public_address is not defined'
        when not (arguments -> 'associate_public_ip_address')::bool then ' is not publicly accessible' else ' is publicly accessible'
      end || '.' as reason,
      path
    from
      terraform_resource
    where
      type = 'aws_instance'
  EOT
}

control "aws_ec2_instance_detailed_monitoring_enabled" {
  title = "AWS EC2 instances should have detailed monitoring enabled"
  description = "AWS EC2 instances should have detailed monitoring enabled."
  sql = <<-EOT
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'monitoring')::bool then 'ok'
        -- Alarm if property is set to false or isn't defined
        else 'alarm'
      end as status,
      name || case
        when arguments -> 'monitoring' is null then ' monitoring is not defined'
        when (arguments -> 'monitoring')::bool then ' detailed monitoring is enabled' else 'detailed monitoring is disabled'
      end || '.' as reason,
      path
    from
      terraform_resource
    where
      type = 'aws_instance'
  EOT
}
