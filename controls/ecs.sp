locals {
  ecs_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "ecs"
  })
}

benchmark "ecs" {
  title         = "ECS"
  children = [
    control.ecs_cluster_container_insights_enabled,
    control.ecs_task_definition_encryption_in_transit_enabled,
  ]
  tags          = local.ecs_compliance_common_tags
}
