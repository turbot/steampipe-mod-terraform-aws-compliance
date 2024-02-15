## v0.24 [2024-02-15]

_Bug fixes_

- Removed duplicate control `rds_db_cluster_encrypted_with_kms_cmk`. ([#105](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/105))

## v0.23 [2024-01-23]

_What's new?_

- Added the following controls across `Simple Email Service` and `VPC` benchmarks. ([#88](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/88) [#102](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/102))
  - `ses_configuration_set_tls_enforced`
  - `vpc_security_group_restrict_ingress_rdp_all`
  - `vpc_security_group_restrict_ingress_ssh_all`

## v0.22 [2023-11-30]

_What's new?_

- Added the following controls across the benchmarks: ([#98](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/98))
  - `docdb_cluster_backup_retention_period_7`
  - `lambda_permission_restricted_service_permission`
  - `neptune_cluster_backup_retention_period_7`
  - `neptune_cluster_copy_tags_to_snapshot_enabled`
  - `neptune_cluster_iam_authentication_enabled`

## v0.21 [2023-11-03]

_Breaking changes_

- Updated the plugin dependency section of the mod to use `min_version` instead of `version`. ([#94](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/94))

## v0.20 [2023-10-03]

_Enhancements_

- Updated the queries to use the `attributes_std` and `address` columns from the `terraform_resource` table instead of `arguments`, `type` and `name` columns for better support of terraform state files. ([#90](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/90))

_Dependencies_

- Terraform plugin `v0.10.0` or higher is now required. ([#90](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/90))

## v0.19 [2023-09-13]

_Breaking changes_

- Removed the `dms_s3_endpoint_encryption_in_transit_enabled` control from the `DMS` benchmark. ([#84](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/84))

_Enhancements_

- Added the `vpc_transfer_server_allows_only_secure_protocols` control to the `VPC` benchmark. ([#84](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/84))

## v0.18 [2023-09-07]

_What's new?_

- Added the following controls across the benchmarks: ([#81](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/81))
  - `glacier_vault_restrict_public_access`
  - `glue_data_catalog_encryption_enabled`
  - `glue_security_configuration_encryption_enabled`
  - `sns_topic_policy_restrict_public_access`
  - `vpc_network_acl_allow_ftp_port_20_ingress`
  - `vpc_network_acl_allow_ftp_port_21_ingress`
  - `vpc_network_acl_allow_rdp_port_3389_ingress`
  - `vpc_network_acl_allow_ssh_port_22_ingress`
  - `vpc_network_acl_rule_restrict_ingress_ports_all`

## v0.17 [2023-08-24]

_What's new?_

- Added the following controls across the benchmarks: ([#76](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/76))
  - `apigateway_domain_name_use_latest_tls`
  - `apigateway_method_restricts_open_access`
  - `cloudfront_distribution_enabled`
  - `cloudfront_response_header_use_strict_transport_policy_setting`
  - `datasync_location_object_storage_expose_secret`
  - `ec2_ami_launch_permission_restricted`
  - `ecr_repository_policy_prohibit_public_access`
  - `ecs_task_definition_container_non_privileged`
  - `ecs_task_definition_container_readonly_root_filesystem`
  - `ecs_task_definition_no_host_pid_mode`
  - `eks_cluster_node_group_ssh_access_from_internet`
  - `rds_global_cluster_encryption_enabled`

## v0.16 [2023-08-18]

_What's new?_

- Added 64 new controls across the benchmarks for the following services: ([#72](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/72))
  - `ACM`
  - `APIGateway`
  - `AppFlow`
  - `AppSync`
  - `Athena`
  - `AutoScaling`
  - `Backup`
  - `CloudFormation`
  - `CloudSearch`
  - `CloudTrail`
  - `CodeArtifact`
  - `CodeCommit`
  - `CodePipeline`
  - `Comprehend`
  - `Connect`
  - `DAX`
  - `DLM`
  - `DMS`
  - `EBS`
  - `ECS`
  - `EFS`
  - `EKS`
  - `ELB`
  - `EMR`
  - `ElastiCache`
  - `ElasticBeanstalk`
  - `Elasticsearch`
  - `EventBridge`
  - `FSx`
  - `Glue`
  - `Kendra`
  - `Keyspaces`
  - `Lambda`
  - `MQ`
  - `MSK`
  - `MWAA`
  - `OpenSearch`
  - `QLDB`
  - `RDS`

## v0.15 [2023-08-11]

_Bug fixes_

- Fixed the `CodeBuild` benchmark to correctly reference the `codebuild_project_privileged_mode_disabled` control. ([#69](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/69))

## v0.14 [2023-08-10]

_What's new?_

- Added 35 new controls across the benchmarks. ([#65](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/65))

## v0.13 [2023-08-03]

_What's new?_

- Added 34 new controls across the benchmarks. ([#61](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/61))

## v0.12 [2023-07-28]

_What's new?_

- Added 43 new controls across the benchmarks. ([#54](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/54))

_Bug fixes_

- Removed the duplicate `ebs_attached_volume_encryption_enabled` control. ([#54](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/54))

## v0.11 [2023-06-15]

_What's new?_

- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/variables)) ([#49](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/49))
- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/variables)) ([#49](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/49))

## v0.10 [2022-11-11]

_Bug fixes_

- Fixed typo in the `kms_cmk_rotation_enabled` control tag to use `hipaa` instead of `hippa`. ([#42](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/42))

## v0.9 [2022-06-09]

_Bug fixes_

- Fixed the `redshift_cluster_automatic_snapshots_min_7_days` control to use `soc_2 = "true"` tag instead of `sco_2 = "true"`. ([#28](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/28))

## v0.8 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README to the latest format. ([#34](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/34))

## v0.7 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#31](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/31))

## v0.6 [2022-03-17]

_Enhancements_

- Paths in control outputs now also include the starting line number for the resource

## v0.5 [2022-02-10]

_Enhancements_

- Updated `README.md` and `docs/index.md` with more detailed usage instructions

## v0.4 [2022-02-09]

_What's new?_

- New benchmarks added for the following AWS services:
  - Athena
  - Kinesis
  - Workspace
- New controls added:
  - athena_database_encryption_at_rest
  - athena_workgroup_encryption_at_rest
  - codebuild_project_encryption_at_rest
  - docdb_cluster_encrypted_with_kms
  - ec2_instance_not_use_default_vpc
  - ecr_repository_encrypted_with_kms
  - kinesis_stream_encryption_at_rest
  - neptune_cluster_encryption_at_rest
  - secretsmanager_secret_encrypted_with_kms_cmk
  - workspace_root_volume_encryption_at_rest
  - workspace_user_volume_encryption_at_rest

## v0.3 [2022-02-02]

_Bug fixes_

- Updated the mod category from `iaas` to `iac`

## v0.2 [2022-01-21]

_Enhancements_

- `README.md` and `docs/index.md` files now include better setup instructions for a seamless experience

## v0.1 [2022-01-20]

_What's new?_

- Added 36 benchmarks and 142 controls to check Terraform AWS resources against security best practices. Controls for the following services have been added:
  - API Gateway
  - Auto Scaling
  - Backup
  - CloudFront
  - CloudTrail
  - CloudWatch
  - CodeBuild
  - Config
  - DAX
  - DMS
  - DocumentDB
  - DynamoDB
  - EBS
  - EC2
  - ECR
  - ECS
  - EFS
  - EKS
  - ElastiCache
  - ELB
  - EMR
  - Elasticsearch
  - Global Accelerator
  - GuardDuty
  - IAM
  - KMS
  - Lambda
  - Neptune
  - RDS
  - Redshift
  - S3
  - SageMaker
  - Secrets Manager
  - SNS
  - SQS
  - VPC
