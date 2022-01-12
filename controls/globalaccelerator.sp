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
