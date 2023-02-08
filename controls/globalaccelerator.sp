locals {
  globalaccelerator_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/GlobalAccelerator"
  })
}

benchmark "globalaccelerator" {
  title       = "Global Accelerator"
  description = "This benchmark provides a set of controls that detect Terraform AWS Global Accelerator resources deviating from security best practices."

  children = [
    control.globalaccelerator_flow_logs_enabled
  ]

  tags = merge(local.globalaccelerator_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "globalaccelerator_flow_logs_enabled" {
  title       = "Global Accelerator  flow logs should be enabled"
  description = "Ensure Global Accelerator accelerator has flow logs enabled"
  query       = query.globalaccelerator_flow_logs_enabled

  tags = local.globalaccelerator_compliance_common_tags
}
