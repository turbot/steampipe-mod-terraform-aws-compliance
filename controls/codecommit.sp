locals {
  codecommit_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CodeCommit"
  })
}

benchmark "codecommit" {
  title       = "CodeCommit"
  description = "This benchmark provides a set of controls that detect Terraform AWS CodeCommit resources deviating from security best practices."

  children = [
    control.codecommit_approval_rule_template_number_of_approval_2
  ]

  tags = merge(local.codecommit_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "codecommit_approval_rule_template_number_of_approval_2" {
  title       = "CodeCommit approval rule template should have at least 2 approvals"
  description = "Ensure that codecommit branch changes receive a minimum of 2 approvals."
  query       = query.codecommit_approval_rule_template_number_of_approval_2

  tags = local.codecommit_compliance_common_tags
}
