locals {
  policies = flatten([
    for index, github_repo in var.github_repositories : [
      for policy_arn in github_repo.policies : {
        "repo"       = github_repo.name
        "policy_arn" = policy_arn
      }
    ]
  ])
}