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
