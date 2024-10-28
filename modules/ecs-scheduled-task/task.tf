resource "aws_ecs_task_definition" "task" {
  family = "${var.name_prefix}-${var.execution_name}"

  requires_compatibilities = ["EC2"]
  skip_destroy             = true

  # since the DB is not in the same VPC, it is not required to put it on the same vpc
  network_mode = "bridge"

  # role that allows ECS to spin up your task, for example needs permission to ECR to get container image
  execution_role_arn = aws_iam_role.task.arn

  # role that your workload gets to access AWS APIs
  # task_role_arn      = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}"
      image     = "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository}:${data.external.get_last_dev_version.result.image_tag}"
      command   = var.task_command
      essential = true
      memory    = var.task_memory
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
}