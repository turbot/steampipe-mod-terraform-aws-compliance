locals {
  cloudtrail_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cloudtrail"
  })
}

benchmark "cloudtrail" {
  title         = "CloudTrail"
  children = [
    control.cloudtrail_enabled_all_regions,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.cloudtrail_trail_validation_enabled,
  ]
  tags          = local.cloudtrail_compliance_common_tags
}

control "cloudtrail_enabled_all_regions" {
  title         = "Ensure CloudTrail is enabled in all regions"
  description   = "CloudTrail is a service that records AWS API calls for your account and delivers log files to you. The recorded information includes the identity of the API caller, the time of the API call, the source IP address of the API caller, the request parameters, and the response elements returned by the AWS service."
  sql           = query.cloudtrail_enabled_all_regions.sql

  tags = local.cloudtrail_compliance_common_tags
}

control "cloudtrail_trail_logs_encrypted_with_kms_cmk" {
  title         = "CloudTrail trail logs should be encrypted with KMS CMK"
  description   = "To help protect sensitive data at rest, ensure encryption is enabled for your Amazon CloudWatch Log Groups."
  sql           = query.cloudtrail_trail_logs_encrypted_with_kms_cmk.sql

  tags = local.cloudtrail_compliance_common_tags
}

control "cloudtrail_trail_validation_enabled" {
  title         = "CloudTrail trail log file validation should be enabled"
  description   = "Utilize AWS CloudTrail log file validation to check the integrity of CloudTrail logs. Log file validation helps determine if a log file was modified or deleted or unchanged after CloudTrail delivered it. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing. This makes it computationally infeasible to modify, delete or forge CloudTrail log files without detection."
  sql           = query.cloudtrail_trail_validation_enabled.sql

  tags = local.cloudtrail_compliance_common_tags
}