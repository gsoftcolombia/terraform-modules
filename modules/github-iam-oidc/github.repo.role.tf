resource "aws_iam_role" "this" {
  for_each    = var.github_repositories
  name        = "${var.name_prefix}-${each.key}"
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
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${each.key}:*"
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
  path       = "/github/"
  depends_on = [aws_iam_openid_connect_provider.this]
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for idx, item in local.github_policy_attachments :
    "${item.repo_name}-${idx}" => item
  }
  policy_arn = each.value.policy_arn
  role       = aws_iam_role.github[each.value.repo_name].name
  depends_on = [aws_iam_role.this]
}
