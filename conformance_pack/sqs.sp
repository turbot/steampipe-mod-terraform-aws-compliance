locals {
  conformance_pack_sqs_common_tags = {
    service = "sqs"
  }
}

control "sqs_queue_encrypted_at_rest" {
  title         = "Amazon SQS queues should be encrypted at rest"
  description   = "This control checks whether Amazon SQS queues are encrypted at rest."
  sql           = query.sqs_queue_encrypted_at_rest.sql

  tags = local.conformance_pack_sqs_common_tags
}

control "sqs_vpc_endpoint_without_dns_resolution" {
  title       = "VPC Endpoint for SQS should be enabled in all Availability Zones in use a VPC"
  description = "Using VPC endpoints helps secure traffic by ensuring the data does not traverse the Internet or access public networks. It also helps keep private subnets private. Setting up VPC endpoints can be complicated."
  sql           = query.sqs_vpc_endpoint_without_dns_resolution.sql

  tags = local.conformance_pack_sqs_common_tags
}