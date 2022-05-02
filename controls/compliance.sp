locals {
  compliance_common_tags =  merge(local.terraform_aws_compliance_common_tags, {
    type = "Benchmark"
  })
}