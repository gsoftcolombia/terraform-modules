data "aws_caller_identity" "current" {}

module "networking" {
  source                 = "./modules/networking"
  name_prefix            = local.name_prefix
  aws_region             = local.aws_region
  environment            = local.environment
  cidr_range             = local.cidr_range
  azs                    = local.subnets_azs
  public_subnets_values  = local.public_subnets_values
  private_subnets_values = local.private_subnets_values
}

module "ecr-all" {
  source           = "./modules/ecr"
  name_prefix      = local.name_prefix
  aws_region       = local.aws_region
  environment      = local.environment
  ecr_repositories = local.ecr_repositories
}

module "github-iam-oidc" {
  source     = "./modules/github-iam-oidc"
  depends_on = [module.ecr-all, aws_iam_policy.power_access_ecs_tasks]

  name_prefix         = local.name_prefix
  aws_region          = local.aws_region
  environment         = local.environment
  github_thumbprint   = local.github_thumbprint
  github_org          = local.github_org
  github_repositories = local.github_repositories
}

module "ecs-cluster" {
  source      = "./modules/ecs"
  name_prefix = "${local.name_prefix}-ecs"
}

# Attach here multiple capacity providers to the ECS Cluster
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = module.ecs-cluster.ecs_cluster_name
  capacity_providers = [
    "FARGATE",
    module.ecs_cp_default.capacity_provider_name,
  ]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

module "cloudtrail" {
  source      = "./modules/cloudtrail"
  name_prefix = local.name_prefix
}