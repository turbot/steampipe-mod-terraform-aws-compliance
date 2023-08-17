locals {
  mwaa_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/MWAA"
  })
}
benchmark "mwaa" {
  title       = "Managed Workflows for Apache Airflow"
  description = "This benchmark provides a set of controls that detect Terraform AWS Managed Workflows for Apache Airflow resources deviating from security best practices."
  children = [
    control.mwaa_environment_scheduler_logs_enabled,
    control.mwaa_environment_webserver_logs_enabled,
    control.mwaa_environment_worker_logs_enabled
  ]
  tags = merge(local.mwaa_compliance_common_tags, {
    type = "Benchmark"
  })
}
control "mwaa_environment_scheduler_logs_enabled" {
  title       = "MWAA environment should have scheduler logs enabled"
  description = "This control checks whether MWAA environment has scheduler logs enabled."
  query       = query.mwaa_environment_scheduler_logs_enabled
  
  tags = local.mwaa_compliance_common_tags
}
control "mwaa_environment_webserver_logs_enabled" {
  title       = "MWAA environment should have webserver logs enabled"
  description = "This control checks whether MWAA environment has webserver logs enabled."
  query       = query.mwaa_environment_webserver_logs_enabled
  
  tags = local.mwaa_compliance_common_tags
}
control "mwaa_environment_worker_logs_enabled" {
  title       = "MWAA environment should have worker logs enabled"
  description = "This control checks whether MWAA environment has worker logs enabled"
  query       = query.mwaa_environment_worker_logs_enabled
  
  tags = local.mwaa_compliance_common_tags
}