locals {
  conformance_pack_globalaccelerator_common_tags = {
    service = "globalaccelerator"
  }
}

control "globalaccelerator_flow_logs_enabled" {
  title         = "Global Accelerator  flow logs should be enabled"
  description   = "Ensure Global Accelerator accelerator has flow logs enabled"
  sql           = query.globalaccelerator_flow_logs_enabled.sql

  tags = local.conformance_pack_globalaccelerator_common_tags
}