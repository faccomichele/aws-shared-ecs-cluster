resource "aws_ecs_cluster" "this" {
  name = "${local.project_name}-${local.environment}"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = merge(local.tags,
    {
      File = "main.tf"
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.project_name}-${local.environment}"
  retention_in_days = local.log_retention_days

  tags = merge(local.tags,
    {
      File = "main.tf"
    }
  )
}
