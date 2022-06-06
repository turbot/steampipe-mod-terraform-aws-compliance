locals {
  cloudtrail_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudTrail"
  })
}

benchmark "cloudtrail" {
  title        = "CloudTrail"
  description  = "This benchmark provides a set of controls that detect Terraform AWS CloudTrail resources deviating from security best practices."

  children = [
    control.cloudtrail_enabled_all_regions,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.cloudtrail_trail_validation_enabled,
  ]

  tags = merge(local.cloudtrail_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "cloudtrail_enabled_all_regions" {
  title         = "Ensure CloudTrail is enabled in all regions"
  description   = "CloudTrail is a service that records AWS API calls for your account and delivers log files to you. The recorded information includes the identity of the API caller, the time of the API call, the source IP address of the API caller, the request parameters, and the response elements returned by the AWS service."
  sql           = query.cloudtrail_enabled_all_regions.sql

  tags = merge(local.cloudtrail_compliance_common_tags, {
    cis  = "true"
    gdpr = "true"
    pci  = "true"
  })
}

control "cloudtrail_trail_logs_encrypted_with_kms_cmk" {
  title         = "CloudTrail trail logs should be encrypted with KMS CMK"
  description   = "To help protect sensitive data at rest, ensure encryption is enabled for your Amazon CloudWatch Log Groups."
  sql           = query.cloudtrail_trail_logs_encrypted_with_kms_cmk.sql

  tags = merge(local.cloudtrail_compliance_common_tags, {
    aws_foundational_security = "true"
    cis                       = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security         = "true"
  })
}

control "cloudtrail_trail_validation_enabled" {
  title         = "CloudTrail trail log file validation should be enabled"
  description   = "Utilize AWS CloudTrail log file validation to check the integrity of CloudTrail logs. Log file validation helps determine if a log file was modified or deleted or unchanged after CloudTrail delivered it. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing. This makes it computationally infeasible to modify, delete or forge CloudTrail log files without detection."
  sql           = query.cloudtrail_trail_validation_enabled.sql

  tags = merge(local.cloudtrail_compliance_common_tags, {
    aws_foundational_security = "true"
    cis                       = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    pci                       = "true"
    soc_2                     = "true"
  })
}