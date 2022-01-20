locals {
  rds_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "rds"
  })
}

benchmark "rds" {
  title       = "RDS"
  description = "This benchmark provides a set of controls that detect Terraform AWS RDS resources deviating from security best practices."

  children = [
    control.rds_db_cluster_aurora_backtracking_enabled,
    control.rds_db_cluster_copy_tags_to_snapshot_enabled,
    control.rds_db_cluster_deletion_protection_enabled,
    control.rds_db_cluster_events_subscription,
    control.rds_db_cluster_iam_authentication_enabled,
    control.rds_db_cluster_multiple_az_enabled,
    control.rds_db_instance_and_cluster_enhanced_monitoring_enabled,
    control.rds_db_instance_and_cluster_no_default_port,
    control.rds_db_instance_automatic_minor_version_upgrade_enabled,
    control.rds_db_instance_backup_enabled,
    control.rds_db_instance_copy_tags_to_snapshot_enabled,
    control.rds_db_instance_deletion_protection_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_instance_events_subscription,
    control.rds_db_instance_iam_authentication_enabled,
    control.rds_db_instance_logging_enabled,
    control.rds_db_instance_multiple_az_enabled,
    control.rds_db_instance_prohibit_public_access,
    control.rds_db_parameter_group_events_subscription,
    control.rds_db_security_group_events_subscription
  ]

  tags = local.rds_compliance_common_tags
}

control "rds_db_cluster_aurora_backtracking_enabled" {
  title         = "Amazon Aurora clusters should have backtracking enabled"
  description   = "This control checks whether Amazon Aurora clusters have backtracking enabled. Backups help you to recover more quickly from a security incident. They also strengthen the resilience of your systems. Aurora backtracking reduces the time to recover a database to a point in time. It does not require a database restore to do so."
  sql           = query.rds_db_cluster_aurora_backtracking_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_cluster_copy_tags_to_snapshot_enabled" {
  title         = "RDS DB clusters should be configured to copy tags to snapshots"
  description   = "This control checks whether RDS DB clusters are configured to copy all tags to snapshots when the snapshots are created."
  sql           = query.rds_db_cluster_copy_tags_to_snapshot_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_cluster_deletion_protection_enabled" {
  title         = "RDS clusters should have deletion protection enabled"
  description   = "This control checks whether RDS clusters have deletion protection enabled. This control is intended for RDS DB instances. However, it can also generate findings for Aurora DB instances, Neptune DB instances, and Amazon DocumentDB clusters. If these findings are not useful,then you can suppress them."
  sql           = query.rds_db_cluster_deletion_protection_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_cluster_events_subscription" {
  title         = "An RDS event notifications subscription should be configured for critical cluster events"
  description   = "This control checks whether an Amazon RDS event subscription exists that has notifications enabled for the following source type, event category key-value pairs."
  sql           = query.rds_db_cluster_events_subscription.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_cluster_iam_authentication_enabled" {
  title         = "IAM authentication should be configured for RDS clusters"
  description   = "This control checks whether an RDS DB cluster has IAM database authentication enabled. IAM database authentication allows for password-free authentication to database instances. The authentication uses an authentication token. Network traffic to and from the database is encrypted using SSL."
  sql           = query.rds_db_cluster_iam_authentication_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_cluster_multiple_az_enabled" {
  title         = "RDS DB clusters should be configured for multiple Availability Zones"
  description   = "This control checks whether high availability is enabled for your RDS DB clusters. RDS DB clusters should be configured for multiple Availability Zones to ensure availability of the data that is stored."
  sql           = query.rds_db_cluster_multiple_az_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_instance_and_cluster_enhanced_monitoring_enabled" {
  title       = "RDS DB instance and cluster enhanced monitoring should be enabled"
  description = "Enable Amazon Relational Database Service (Amazon RDS) to help monitor Amazon RDS availability. This provides detailed visibility into the health of your Amazon RDS database instances."
  sql           = query.rds_db_instance_and_cluster_enhanced_monitoring_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_csf = "true"
  })
}

control "rds_db_instance_and_cluster_no_default_port" {
  title         = "RDS databases and clusters should not use a database engine default port"
  description   = "This control checks whether the RDS cluster or instance uses a port other than the default port of the database engine."
  sql           = query.rds_db_instance_and_cluster_no_default_port.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_instance_automatic_minor_version_upgrade_enabled" {
  title       = "RDS DB instance automatic minor version upgrade should be enabled"
  description = "Ensure if Amazon Relational Database Service (RDS) database instances are configured for automatic minor version upgrades. The rule is NON_COMPLIANT if the value of 'autoMinorVersionUpgrade' is false."
  sql           = query.rds_db_instance_automatic_minor_version_upgrade_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    rbi_cyber_security = "true"
  })
}

control "rds_db_instance_backup_enabled" {
  title       = "RDS DB instance backup should be enabled"
  description = "The backup feature of Amazon RDS creates backups of your databases and transaction logs."
  sql           = query.rds_db_instance_backup_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "rds_db_instance_copy_tags_to_snapshot_enabled" {
  title         = "RDS DB instances should be configured to copy tags to snapshots"
  description   = "This control checks whether RDS DB instances are configured to copy all tags to snapshots when the snapshots are created."
  sql           = query.rds_db_instance_copy_tags_to_snapshot_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_instance_deletion_protection_enabled" {
  title       = "RDS DB instances should have deletion protection enabled"
  description = "Ensure Amazon Relational Database Service (Amazon RDS) instances have deletion protection enabled."
  sql           = query.rds_db_instance_deletion_protection_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    nist_800_53_rev_4 = "true"
    soc_2             = "true"
  })
}

control "rds_db_instance_encryption_at_rest_enabled" {
  title       = "RDS DB instance encryption at rest should be enabled"
  description = "To help protect data at rest, ensure that encryption is enabled for your Amazon Relational Database Service (Amazon RDS) instances."
  sql           = query.rds_db_instance_encryption_at_rest_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    cis = "true"
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
  })
}

control "rds_db_instance_events_subscription" {
  title         = "An RDS event notifications subscription should be configured for critical database instance events"
  description   = "This control checks whether an Amazon RDS event subscription exists with notifications enabled for the following source type, event category key-value pairs."
  sql           = query.rds_db_instance_events_subscription.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_instance_iam_authentication_enabled" {
  title       = "RDS DB instances should have iam authentication enabled"
  description = "Checks if an Amazon Relational Database Service (Amazon RDS) instance has AWS Identity and Access Management (IAM) authentication enabled."
  sql           = query.rds_db_instance_iam_authentication_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    soc_2  = "true"
  })
}

control "rds_db_instance_logging_enabled" {
  title       = "Database logging should be enabled"
  description = "To help with logging and monitoring within your environment, ensure Amazon Relational Database Service (Amazon RDS) logging is enabled."
  sql           = query.rds_db_instance_logging_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    gdpr               = "true"
    nist_800_53_rev_4  = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "rds_db_instance_multiple_az_enabled" {
  title       = "RDS DB instance multiple az should be enabled"
  description = "Multi-AZ support in Amazon Relational Database Service (Amazon RDS) provides enhanced availability and durability for database instances."
  sql           = query.rds_db_instance_multiple_az_enabled.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
  })
}

control "rds_db_instance_prohibit_public_access" {
  title       = "RDS DB instances should prohibit public access"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Relational Database Service (Amazon RDS) instances are not public."
  sql           = query.rds_db_instance_prohibit_public_access.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security   = "true"
    hipaa                       = "true"
    nist_800_53_rev_4           = "true"
    nist_csf                    = "true"
    rbi_cyber_security          = "true"
    pci                         = "true"
    soc_2                       = "true"
  })
}

control "rds_db_parameter_group_events_subscription" {
  title         = "An RDS event notifications subscription should be configured for critical database parameter group events"
  description   = "This control checks whether an Amazon RDS event subscription exists with notifications enabled for the following source type, event category key-value pairs."
  sql           = query.rds_db_parameter_group_events_subscription.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "rds_db_security_group_events_subscription" {
  title         = "An RDS event notifications subscription should be configured for critical database security group events"
  description   = "This control checks whether an Amazon RDS event subscription exists with notifications enabled for the following source type, event category key-value pairs."
  sql           = query.rds_db_security_group_events_subscription.sql

  tags = merge(local.rds_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}