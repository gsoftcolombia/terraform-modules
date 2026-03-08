data "aws_caller_identity" "current" {}
locals {
  account_id      = data.aws_caller_identity.current.account_id
  task_family_arn = "arn:aws:ecs:${var.aws_region}:${local.account_id}:task-definition/${aws_ecs_task_definition.task.family}"
}
