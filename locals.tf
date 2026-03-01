locals {
  name_prefix = "gs-sandbox"
  aws_region  = "us-east-2"
  environment = "production"    # Just used as placeholder, I know, it is sandbox.
  cidr_range  = "10.32.60.0/22" #gsoft-sandbox-account

  subnets_azs            = ["us-east-2a"]
  public_subnets_values  = ["10.32.60.0/23"]
  private_subnets_values = ["10.32.62.0/23"]
  github_thumbprint      = "d89e3bd43d5d909b47a18977aa9d5ce36cee184c"
  github_org             = "gsoftcolombia"
  # The ECR Repo will create a policy, the policy in this case will be created with the following format:
  # {name_prefix}-{ecr-repo-name} ... this policy will be used in the variable github_repositories
  # so each github repo will have an independent role with custom permissions
  github_repositories = {
    github-actions = {
      policies = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/github/gs-sandbox-github-actions",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/github/gs-sandbox-power-access-ecs-tasks"
      ]
    },
  }

  ecr_repositories = {
    github-actions = {
      image_tag_mutability   = "IMMUTABLE"
      image_scanning         = true
      read_write_access_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"]
      lifecycle_policy = {
        rules = [
          {
            rulePriority = 1,
            description  = "Keep last 3 dev images",
            selection = {
              tagStatus     = "tagged",
              tagPrefixList = ["dev-"],
              countType     = "imageCountMoreThan",
              countNumber   = 3
            }
            action = {
              type = "expire"
            }
          },
          {
            rulePriority = 2,
            description  = "Keep last 3 prod images",
            selection = {
              tagStatus     = "tagged",
              tagPrefixList = ["prod-"],
              countType     = "imageCountMoreThan",
              countNumber   = 3
            }
            action = {
              type = "expire"
            }
          }
        ]
      }
    }
  }
}
