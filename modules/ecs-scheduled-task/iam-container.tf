resource "aws_iam_role" "container" {
  name = "${var.name_prefix}-${var.environment}-${var.execution_name}-container"
  path = "/ecs/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "container" {
  policy_arn = aws_iam_policy.container.arn
  role       = aws_iam_role.container.name
}

resource "aws_iam_policy" "container" {
  name        = "${var.name_prefix}-${var.environment}-${var.execution_name}-container"
  path        = "/ecs/"
  description = "This policy is intended to be used by a Role assumed by a ECS Container"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${local.account_id}:repository/${var.ecr_repository}"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      }
    ]
  })
}