resource "aws_scheduler_schedule" "cron" {
  count      = var.enable_schedule ? 1 : 0
  name       = "${var.name_prefix}-cron-${var.execution_name}"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {
    arn      = var.cluster_arn
    role_arn = aws_iam_role.scheduler[0].arn

    ecs_parameters {
      # trimming the revision suffix here so that schedule always uses latest revision
      task_definition_arn = trimsuffix(aws_ecs_task_definition.task.arn, ":${aws_ecs_task_definition.task.revision}")

      # Force the task to run on FARGATE (or another specific provider)
      capacity_provider_strategy {
        capacity_provider = "FARGATE" # Must match a provider in the cluster
        weight            = 1         # Required, but irrelevant if only one provider
        base              = 1         # Ensures at least 1 task runs here
      }
    }

    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 3
    }
  }
}