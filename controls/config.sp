locals {
  config_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "config"
  })
}

benchmark "config" {
  title    = "Config"
  children = [
    control.config_aggregator_enabled_all_regions
  ]
  tags     = local.config_compliance_common_tags
}

control "config_aggregator_enabled_all_regions" {
  title         = "Config aggregator should be enabled in all regions"
  description   = "AWS Config should enable the config aggregator - allowing you to analyze the configuration across multiple accounts and regions."
  sql           = query.config_aggregator_enabled_all_regions.sql

  tags = local.config_compliance_common_tags
}