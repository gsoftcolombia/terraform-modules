locals {
  github_policy_attachments = flatten([
    for repo_name, repo in var.github_repositories : [
      for policy_arn in repo.policies : {
        repo_name  = repo_name
        policy_arn = policy_arn
      }
    ]
  ])
}