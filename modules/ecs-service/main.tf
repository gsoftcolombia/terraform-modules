resource "aws_ecs_service" "app" {
  # We use depends on here, otherwise, the policy may be destroyed 
  # too soon and the ECS service will then get stuck in the DRAINING state.
  depends_on      = [aws_iam_role.task]
  name            = "${var.name_prefix}-${var.environment}-${var.service_name}"
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count

  capacity_provider_strategy {
    capacity_provider = var.service_capacity_provider_strategy.capacity_provider
    weight            = var.service_capacity_provider_strategy.weight
    base              = var.service_capacity_provider_strategy.base
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn # Initial target group
    container_name   = "${var.name_prefix}-${var.environment}-${var.service_name}"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      load_balancer,  # Ignore changes made by CodeDeploy
      task_definition # Often good to ignore this too for Blue/Green
    ]
  }
}

# This security group is used for the ECS Tasks, Private ENIs and only the load balancer has access there.
resource "aws_security_group" "ecs_sg" {
  # Ensure this SG is destroyed before the ALB SG
  depends_on = [aws_security_group.alb]

  name   = "${var.name_prefix}-${var.environment}-${var.service_name}-private"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}