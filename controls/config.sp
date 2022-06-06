locals {
  config_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Config"
  })
}

benchmark "config" {
  title        = "Config"
  description  = "This benchmark provides a set of controls that detect Terraform AWS Config resources deviating from security best practices."

  children = [
    control.config_aggregator_enabled_all_regions
  ]

  tags = merge(local.config_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "config_aggregator_enabled_all_regions" {
  title         = "Config aggregator should be enabled in all regions"
  description   = "AWS Config should enable the config aggregator - allowing you to analyze the configuration across multiple accounts and regions."
  sql           = query.config_aggregator_enabled_all_regions.sql

  tags = local.config_compliance_common_tags
}