resource "aws_iam_role" "scheduler" {
  name = "${var.name_prefix}-scheduler-${var.execution_name}"
  path = "/event-bridge/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler" {
  policy_arn = aws_iam_policy.scheduler.arn
  role       = aws_iam_role.scheduler.name
}

resource "aws_iam_policy" "scheduler" {
  name = "${var.name_prefix}-scheduler-${var.execution_name}"
  path = "/event-bridge/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RunTask"
        ]
        # trim :<revision> from arn, to point at the whole task definition and not just one revision
        Resource = [
          trimsuffix(aws_ecs_task_definition.task.arn, ":${aws_ecs_task_definition.task.revision}"),
          "${trimsuffix(aws_ecs_task_definition.task.arn, ":${aws_ecs_task_definition.task.revision}")}:*"
        ]
      },
      { # allow scheduler to set the IAM roles of your task
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      },
    ]
  })
}