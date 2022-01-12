locals {
  conformance_pack_ecs_common_tags = {
    service = "ecs"
  }
}

control "ecs_cluster_container_insights_enabled" {
  title         = "ECS cluster container insights should be enabled"
  description   = "One of the best practices when using AWS ECR is to enable container insights for better visibility."
  sql           = query.ecs_cluster_container_insights_enabled.sql

  tags = local.conformance_pack_ecs_common_tags
}

control "ecs_task_definition_encryption_in_transit_enabled" {
  title         = "ECS task definition encryption in transit should be enabled"
  description   = "Ensure Encryption in transit is enabled for EFS volumes in ECS Task definitions."
  sql           = query.ecs_task_definition_encryption_in_transit_enabled.sql

  tags = local.conformance_pack_ecs_common_tags
}