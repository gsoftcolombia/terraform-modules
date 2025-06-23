resource "aws_ecs_task_definition" "task" {
  family = "${var.name_prefix}-${var.execution_name}"
  cpu    = var.task_cpu
  memory = var.task_memory

  requires_compatibilities = ["FARGATE", "EC2"]
  skip_destroy             = true

  network_mode = "awsvpc"

  # role that allows ECS to spin up your task, for example needs permission to ECR to get container image
  execution_role_arn = aws_iam_role.task.arn

  # role that your workload gets to access AWS APIs
  # task_role_arn      = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-${var.execution_name}"
      image     = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository}:${data.external.get_last_dev_version.result.image_tag}"
      command   = var.task_command
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-stream-prefix" = "ecs"
          "awslogs-region"        = var.aws_region
        }
      }
      secrets = var.container_definitions_secrets
    }

  ])
  lifecycle {
    ignore_changes = [
      container_definitions, # This will ignore all changes to container definitions
    ]
  }
}