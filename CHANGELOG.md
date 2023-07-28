## v0.12 [2023-07-28]

_What's new?_

- 43 new controls have been added across the benchmarks. ([#54](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/pull/54))

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
