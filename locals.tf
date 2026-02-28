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
  # gs-prod-{ecr-repo-name} ... this policy will be used in the variable github_repositories
  # so each github repo will have an independent role with custom permissions
  github_repositories = [
  ]

  ecr_repositories = {

  }
}
