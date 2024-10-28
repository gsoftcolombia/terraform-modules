resource "aws_iam_role" "this" {
  for_each    = { for index, github_repo in var.github_repositories : github_repo.name => github_repo }
  name        = module.iamroles_label[each.value.name].id
  description = "Role for Github Actions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowingGithub"
        Action = ["sts:AssumeRoleWithWebIdentity"]
        Effect = "Allow"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${each.value.name}:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
        Principal = {
          Federated = aws_iam_openid_connect_provider.this.arn
        }
      },
    ]
  })
  tags       = module.iamroles_label[each.value.name].tags
  path       = "/github/"
  depends_on = [aws_iam_openid_connect_provider.this]
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = tomap({
    for policy in local.policies : "${policy.repo}.${policy.policy_arn}" => policy
  })
  policy_arn = each.value.policy_arn
  role       = module.iamroles_label[each.value.repo].id
  depends_on = [aws_iam_role.this]
}

module "iamroles_label" {
  source  = "cloudposse/label/null"
  version = "~> 0.24.1"

  for_each = { for index, github_repo in var.github_repositories : github_repo.name => github_repo }

  namespace = "gs"
  stage     = "prod"
  name      = each.value.name
  delimiter = "-"

  tags = {
    terraform   = "true",
    environment = var.environment
  }
}