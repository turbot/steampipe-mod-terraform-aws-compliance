locals {
  elasticbeanstalk_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ElasticBeanstalk"
  })
}

benchmark "elasticbeanstalk" {
  title       = "ElasticBeanstalk"
  description = "This benchmark provides a set of controls that detect Terraform AWS ElasticBeanstalk resources deviating from security best practices."

  children = [
    control.elasticbeanstalk_environment_use_enhanced_health_checks,
    control.elasticbeanstalk_environment_use_managed_updates
  ]

  tags = merge(local.elasticbeanstalk_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "elasticbeanstalk_environment_use_managed_updates" {
  title       = "Elastic Beanstalk managed platform updates should be enabled"
  description = "This control checks whether Elastic Beanstalk environments have managed platform updates enabled."
  query       = query.elasticbeanstalk_environment_use_managed_updates

  tags = local.elasticbeanstalk_compliance_common_tags
}

control "elasticbeanstalk_environment_use_enhanced_health_checks" {
  title       = "Elastic Beanstalk enhanced health reporting should be enabled"
  description = "This control checks whether Elastic Beanstalk environments have enhanced health reporting enabled."
  query       = query.elasticbeanstalk_environment_use_enhanced_health_checks

  tags = local.elasticbeanstalk_compliance_common_tags
}
