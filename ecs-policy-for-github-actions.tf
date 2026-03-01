resource "aws_iam_policy" "power_access_ecs_tasks" {
  name        = "${local.name_prefix}-power-access-ecs-tasks"
  path        = "/github/"
  description = "This policy is intended to be used by a Role assumed by a Github Action"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}