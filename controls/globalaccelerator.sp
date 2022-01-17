locals {
  globalaccelerator_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "globalaccelerator"
  })
}

benchmark "globalaccelerator" {
  title    = "Global Accelerator"
  children = [
    control.globalaccelerator_flow_logs_enabled
  ]
  tags          = local.globalaccelerator_compliance_common_tags
}

control "globalaccelerator_flow_logs_enabled" {
  title         = "Global Accelerator  flow logs should be enabled"
  description   = "Ensure Global Accelerator accelerator has flow logs enabled"
  sql           = query.globalaccelerator_flow_logs_enabled.sql

  tags = local.globalaccelerator_compliance_common_tags
}