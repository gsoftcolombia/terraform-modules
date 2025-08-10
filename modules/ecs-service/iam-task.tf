resource "aws_iam_role" "task" {
  name = "${var.name_prefix}-${var.environment}-${var.service_name}"
  path = "/ecs/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task.name
}
resource "aws_iam_role_policy_attachment" "task_custom_policy" {
  policy_arn = aws_iam_policy.task.arn
  role       = aws_iam_role.task.name
}

resource "aws_iam_policy" "task" {
  name = "${var.name_prefix}-${var.environment}-${var.service_name}"
  path = "/ecs/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters"
        ]
        Resource = "arn:aws:ssm:${local.aws_region}:${local.account_id}:parameter/${var.environment}/app/${var.service_name}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "additional_task_policy" {
  count      = var.container_additional_iam_policy_arn != "-1" ? 1 : 0
  policy_arn = var.container_additional_iam_policy_arn
  role       = aws_iam_role.task.name
}