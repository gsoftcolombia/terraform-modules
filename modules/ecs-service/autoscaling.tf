resource "aws_appautoscaling_target" "service" {
  depends_on         = [aws_ecs_service.app]
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster_name}/${var.name_prefix}-${var.environment}-${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.autoscaling_min_tasks
  max_capacity = var.autoscaling_max_tasks
}

resource "aws_appautoscaling_policy" "cpu" {
  depends_on         = [aws_ecs_service.app]
  name               = "${var.name_prefix}-${var.environment}-${var.service_name}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service.resource_id
  scalable_dimension = aws_appautoscaling_target.service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "memory" {
  depends_on         = [aws_ecs_service.app]
  name               = "${var.name_prefix}-${var.environment}-${var.service_name}-mem"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service.resource_id
  scalable_dimension = aws_appautoscaling_target.service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.service.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 75

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}