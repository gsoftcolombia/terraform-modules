# Task definition is defined here but there might be drifts in AWS
# since the container definition might change, the deployment of a newer version
# is performed in Github Actions by creating a new task definition version and
# triggering a CodeDeploy deployment using aws cli

resource "aws_ecs_task_definition" "task" {
  family = "${var.name_prefix}-${var.environment}-${var.service_name}"
  cpu    = var.task_cpu
  memory = var.task_memory

  requires_compatibilities = ["EC2"]
  skip_destroy             = true

  network_mode = "bridge"

  # role that allows ECS to spin up your task, for example needs permission to ECR to get container image
  execution_role_arn = aws_iam_role.task.arn

  # role that your workload gets to access AWS APIs
  task_role_arn = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name  = "${var.name_prefix}-${var.environment}-${var.service_name}"
      image = "${local.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com/${var.ecr_repository}:${data.external.get_last_dev_version.result.image_tag}"
      #image     = "httpd:latest"
      command   = length(var.task_command) > 0 ? var.task_command : null
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-stream-prefix" = "ecs"
          "awslogs-region"        = local.aws_region
        }
      }
      secrets     = var.container_definitions_secrets
      environment = var.container_definitions_envvars
      portMappings = [{
        containerPort = 80
        protocol      = "tcp"
      }]
    }

  ])
}