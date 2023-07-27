locals {
  redshift_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Redshift"
  })
}

benchmark "redshift" {
  title       = "Redshift"
  description = "This benchmark provides a set of controls that detect Terraform AWS Redshift resources deviating from security best practices."

  children = [
    control.redshift_cluster_automatic_snapshots_min_7_days,
    control.redshift_cluster_automatic_upgrade_major_versions_enabled,
    control.redshift_cluster_deployed_in_ec2_classic_mode,
    control.redshift_cluster_encryption_logging_enabled,
    control.redshift_cluster_enhanced_vpc_routing_enabled,
    control.redshift_cluster_kms_enabled,
    control.redshift_cluster_logging_enabled,
    control.redshift_cluster_maintenance_settings_check,
    control.redshift_cluster_no_default_database_name,
    control.redshift_cluster_prohibit_public_access
  ]

  tags = merge(local.redshift_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "redshift_cluster_automatic_snapshots_min_7_days" {
  title       = "Amazon Redshift clusters should have automatic snapshots enabled"
  description = "This control checks whether Amazon Redshift clusters have automated snapshots enabled. It also checks whether the snapshot retention period is greater than or equal to seven."
  query       = query.redshift_cluster_automatic_snapshots_min_7_days

  tags = merge(local.redshift_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_csf                  = "true"
    rbi_cyber_security        = "true"
    soc_2                     = "true"
  })
}

control "redshift_cluster_automatic_upgrade_major_versions_enabled" {
  title       = "Amazon Redshift should have automatic upgrades to major versions enabled"
  description = "This control checks whether automatic major version upgrades are enabled for the Amazon Redshift cluster."
  query       = query.redshift_cluster_automatic_upgrade_major_versions_enabled

  tags = merge(local.redshift_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "redshift_cluster_deployed_in_ec2_classic_mode" {
  title       = "Redshift clusters should not be using EC2 classic mode"
  description = "Ensure EC2-Classic mode is not used for the deployment of redshift clusters"
  query       = query.redshift_cluster_deployed_in_ec2_classic_mode

  tags = local.redshift_compliance_common_tags
}

control "redshift_cluster_encryption_logging_enabled" {
  title       = "Redshift cluster audit logging and encryption should be enabled"
  description = "To protect data at rest, ensure that encryption is enabled for your Amazon Redshift clusters. You must also ensure that required configurations are deployed on Amazon Redshift clusters. The audit logging should be enabled to provide information about connections and user activities in the database."
  query       = query.redshift_cluster_encryption_logging_enabled

  tags = merge(local.redshift_compliance_common_tags, {
    soc_2 = "true"
  })
}

control "redshift_cluster_enhanced_vpc_routing_enabled" {
  title       = "Amazon Redshift clusters should use enhanced VPC routing"
  description = "This control checks whether an Amazon Redshift cluster has EnhancedVpcRouting enabled."
  query       = query.redshift_cluster_enhanced_vpc_routing_enabled

  tags = merge(local.redshift_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "redshift_cluster_kms_enabled" {
  title       = "Amazon Redshift clusters should be encrypted with KMS"
  description = "Ensure if Amazon Redshift clusters are using a specified AWS Key Management Service (AWS KMS) key for encryption. The rule is complaint if encryption is enabled and the cluster is encrypted with the key provided in the kmsKeyArn parameter. The rule is non complaint if the cluster is not encrypted or encrypted with another key."
  query       = query.redshift_cluster_kms_enabled

  tags = merge(local.redshift_compliance_common_tags, {
    rbi_cyber_security = "true"
  })
}

control "redshift_cluster_logging_enabled" {
  title       = "Amazon Redshift clusters should have logging enabled"
  description = "Ensure that Amazon Redshift clusters have logging enabled."
  query       = query.redshift_cluster_logging_enabled

  tags = local.redshift_compliance_common_tags
}

control "redshift_cluster_maintenance_settings_check" {
  title       = "Amazon Redshift should have required maintenance settings"
  description = "Ensure whether Amazon Redshift clusters have the specified maintenance settings. Redshift clusters 'allowVersionUpgrade' should be set to 'true' and 'automatedSnapshotRetentionPeriod' should be greater than 7."
  query       = query.redshift_cluster_maintenance_settings_check

  tags = merge(local.redshift_compliance_common_tags, {
    rbi_cyber_security = "true"
  })
}

control "redshift_cluster_prohibit_public_access" {
  title       = "Redshift clusters should prohibit public access"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Redshift clusters are not public."
  query       = query.redshift_cluster_prohibit_public_access

  tags = merge(local.redshift_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "redshift_cluster_no_default_database_name" {
  title       = "Redshift clusters should not use the default database name"
  description = "This control checks whether a Redshift cluster has changed the database name from its default value. The control will fail if the database name for a Redshift cluster is set to dev."
  query       = query.redshift_cluster_no_default_database_name

  tags = merge(local.redshift_compliance_common_tags, {
    nist_csf = "true"
  })
}
