# Port Mappings:
#  - Container must export port 80
#  - Port 80 will be configured in the target groups to reach the container service
#  - ELB will have port 80 exposed per default but this will redirect to the var.service_port
#  - var.service_port is by default 443, but the user may choose another one for security

# Main ALB Resource
resource "aws_lb" "app" {
  name               = "${var.name_prefix}-${var.environment}-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

# Two Target Groups (Blue and Green)
resource "aws_lb_target_group" "blue" {
  name                 = "${var.name_prefix}-${var.environment}-${var.service_name}-blue"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30 # Draining of 30 secs only

  health_check {
    path                = var.service_health_check.path
    interval            = var.service_health_check.interval
    timeout             = var.service_health_check.timeout
    healthy_threshold   = var.service_health_check.healthy_threshold
    unhealthy_threshold = var.service_health_check.unhealthy_threshold
    matcher             = var.service_health_check.matcher
  }

  # Enable sticky sessions (load balancer-generated cookie)
  stickiness {
    type            = "lb_cookie" # ALB-generated cookie
    cookie_duration = 86400       # Cookie expiration in seconds (default: 1 day)
    enabled         = true        # Explicitly enable stickiness
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "green" {
  name                 = "${var.name_prefix}-${var.environment}-${var.service_name}-green"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30 # Draining of 30 secs only

  health_check {
    path                = var.service_health_check.path
    interval            = var.service_health_check.interval
    timeout             = var.service_health_check.timeout
    healthy_threshold   = var.service_health_check.healthy_threshold
    unhealthy_threshold = var.service_health_check.unhealthy_threshold
    matcher             = var.service_health_check.matcher
  }

  # Enable sticky sessions (load balancer-generated cookie)
  stickiness {
    type            = "lb_cookie" # ALB-generated cookie
    cookie_duration = 86400       # Cookie expiration in seconds (default: 1 day)
    enabled         = true        # Explicitly enable stickiness
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Production Listener (port 80)
resource "aws_lb_listener" "production" {
  count = var.expose_port_80 == "true" ? 1 : 0

  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = var.service_port
      protocol    = "HTTPS"
      status_code = "HTTP_301" # Permanent redirect
    }
  }
}
# Production Listener (HTTPS)
resource "aws_lb_listener" "production_https" {
  load_balancer_arn = aws_lb.app.arn
  port              = var.service_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.app.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn # Initial active group
  }

  lifecycle {
    ignore_changes = [default_action[0].target_group_arn] # Let CodeDeploy manage switching
  }

}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-${var.environment}-${var.service_name}"
  description = "Allow HTTP and HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.expose_port_80 == "true" ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true # To prevent errors when it needs to be redeployed and the SG can't be deleted due to the ELB ENI
  }
}