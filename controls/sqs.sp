locals {
  sqs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sqs"
  })
}

benchmark "sqs" {
  title    = "SQS"
  children = [
    control.sqs_queue_encrypted_at_rest,
    control.sqs_vpc_endpoint_without_dns_resolution
  ]
  tags          = local.sqs_compliance_common_tags
}
