module "dev-github-actions-schedule-task" {
  source         = "./modules/ecs-scheduled-task"
  depends_on     = [module.ecr-all] ## Explicit dependency since ECR is passed as string input in this module

  name_prefix    = "${local.name_prefix}" # The full name of the resources will be ${var.name_prefix}-${var.environment}-${var.execution_name}
  environment    = "dev"
  execution_name  = "github-actions-app"

  aws_region     = local.aws_region
  cluster_arn    = module.ecs-cluster.ecs_cluster_arn
  ecr_repository = "${local.name_prefix}-github-actions"

  task_cpu        = 256 # 0.25vCPU
  task_memory     = 512 # MB
  subnet_ids      = module.networking.vpc_public_subnet_ids
  security_groups = [aws_security_group.global.id]

  enable_schedule = false

}
