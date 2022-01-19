locals {
  globalaccelerator_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "globalaccelerator"
  })
}

benchmark "globalaccelerator" {
  title       = "Global Accelerator"
  description = "This benchmark provides a set of controls that detect Terraform AWS Global Accelerator resources deviating from security best practices."

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