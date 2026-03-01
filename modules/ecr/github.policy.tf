resource "aws_iam_policy" "this" {
  depends_on  = [module.ecr]
  for_each    = var.ecr_repositories
  name        = "${var.name_prefix}-${each.key}"
  path        = "/github/"
  description = "This policy is intended to be used by a Role assumed by a Github Action"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${local.account_id}:repository/${var.name_prefix}-${each.key}"
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