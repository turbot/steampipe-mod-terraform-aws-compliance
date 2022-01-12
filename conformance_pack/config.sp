locals {
  conformance_pack_config_common_tags = {
    service = "config"
  }
}

control "config_aggregator_enabled_all_regions" {
  title         = "Config aggregator should be enabled in all regions"
  description   = "AWS Config should enable the config aggregator - allowing you to analyze the configuration across multiple accounts and regions."
  sql           = query.config_aggregator_enabled_all_regions.sql

  tags = local.conformance_pack_config_common_tags
}