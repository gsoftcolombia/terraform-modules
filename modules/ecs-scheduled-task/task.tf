resource "aws_ecs_task_definition" "task" {
  family = "${var.name_prefix}-${var.environment}-${var.execution_name}"
  cpu    = var.task_cpu
  memory = var.task_memory

  requires_compatibilities = ["FARGATE", "EC2"]

  network_mode = "awsvpc"

  # role that allows ECS to spin up your task, for example needs permission to ECR to get container image
  execution_role_arn = aws_iam_role.task.arn

  # role that your workload gets to access AWS APIs
  # task_role_arn      = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-${var.environment}-${var.execution_name}"
      image     = "public.ecr.aws/docker/library/busybox"
      command   = ["sh", "-c", "echo bootstrap task; exit 0"]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-stream-prefix" = "ecs"
          "awslogs-region"        = var.aws_region
        }
      }
    }
  ])
}