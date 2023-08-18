locals {
  mq_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/MQ"
  })
}

benchmark "mq" {
  title       = "MQ"
  description = "This benchmark provides a set of controls that detect Terraform AWS MQ resources deviating from security best practices."

  children = [
    control.mq_broker_audit_logging_enabled,
    control.mq_broker_automatic_minor_upgrade_enabled,
    control.mq_broker_currect_broker_version,
    control.mq_broker_encrypted_with_kms_cmk,
    control.mq_broker_general_logging_enabled,
    control.mq_broker_publicly_accessible
  ]

  tags = merge(local.mq_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "mq_broker_audit_logging_enabled" {
  title       = "MQ Broker should have audit logging enabled"
  description = "This control checks whether audit logging is enabled for the MQ Broker."
  query       = query.mq_broker_audit_logging_enabled

  tags = local.mq_compliance_common_tags
}

control "mq_broker_encrypted_with_kms_cmk" {
  title       = "MQ Broker should be encrypted with KMS CMK"
  description = "This control checks whether the MQ Broker is encrypted with KMS CMK."
  query       = query.mq_broker_encrypted_with_kms_cmk

  tags = local.mq_compliance_common_tags
}

control "mq_broker_general_logging_enabled" {
  title       = "MQ Broker should have general logging enabled"
  description = "This control checks whether general logging is enabled for the MQ Broker."
  query       = query.mq_broker_general_logging_enabled

  tags = local.mq_compliance_common_tags
}

control "mq_broker_automatic_minor_upgrade_enabled" {
  title       = "MQ Broker should have automatic minor version upgrade enabled"
  description = "This control checks whether automatic minor version upgrade is enabled for the MQ Broker."
  query       = query.mq_broker_automatic_minor_upgrade_enabled

  tags = local.mq_compliance_common_tags
}

control "mq_broker_publicly_accessible" {
  title       = "MQ Broker should not be publicly accessible"
  description = "This control checks whether the MQ Broker is publicly accessible. This control is non-compliant if the MQ Broker is publicly accessible."
  query       = query.mq_broker_publicly_accessible

  tags = local.mq_compliance_common_tags
}

control "mq_broker_currect_broker_version" {
  title       = "MQ Broker should use correct engine version for their engine type"
  description = "This control checks whether the MQ Broker uses the correct engine version for their engine type."
  query       = query.mq_broker_currect_broker_version

  tags = local.mq_compliance_common_tags
}
