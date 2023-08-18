locals {
  sqs_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/SQS"
  })
}

benchmark "sqs" {
  title       = "Simple Queue Service"
  description = "This benchmark provides a set of controls that detect Terraform AWS SQS resources deviating from security best practices."

  children = [
    control.sqs_queue_encrypted_at_rest,
    control.sqs_queue_policy_no_action_star,
    control.sqs_queue_policy_no_principal_star,
    control.sqs_vpc_endpoint_without_dns_resolution
  ]

  tags = merge(local.sqs_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "sqs_queue_encrypted_at_rest" {
  title       = "Amazon SQS queues should be encrypted at rest"
  description = "This control checks whether Amazon SQS queues are encrypted at rest."
  query       = query.sqs_queue_encrypted_at_rest

  tags = merge(local.sqs_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "sqs_vpc_endpoint_without_dns_resolution" {
  title       = "VPC Endpoint for SQS should be enabled in all Availability Zones in use a VPC"
  description = "Using VPC endpoints helps secure traffic by ensuring the data does not traverse the Internet or access public networks. It also helps keep private subnets private. Setting up VPC endpoints can be complicated."
  query       = query.sqs_vpc_endpoint_without_dns_resolution

  tags = local.sqs_compliance_common_tags
}

control "sqs_queue_policy_no_action_star" {
  title       = "SQS queue policies should not allow ALL (*) actions"
  description = "SQS CloudWatch Logs destination policy should avoid wildcard in 'actions'."
  query       = query.sqs_queue_policy_no_action_star

  tags = local.sqs_compliance_common_tags
}

control "sqs_queue_policy_no_principal_star" {
  title       = "SQS queue policies should not allow ALL (*) principal"
  description = "Ensure that the SQS queue policy restricts access to specific services or principals, ensuring that it is not publicly accessible."
  query       = query.sqs_queue_policy_no_principal_star

  tags = local.sqs_compliance_common_tags
}
