module "dev-github-actions-service" {
  source             = "./modules/ecs-service"
  depends_on         = [module.ecr-all] ## Explicit dependency since ECR is passed as string input in this module
  name_prefix        = local.name_prefix
  environment        = "dev"
  service_name       = "g-actions-svc"
  vpc_id             = module.networking.vpc_id
  cluster_arn        = module.ecs-cluster.ecs_cluster_arn
  cluster_name       = "${local.name_prefix}-ecs-cluster"
  ecr_repository     = "${local.name_prefix}-github-actions"
  task_cpu           = 512 ## 1024 = 1024 CPU units = 1 vCPU
  task_memory        = 256 ## 256 = 256 MiB
  public_subnet_ids  = module.networking.vpc_public_subnet_ids
  private_subnet_ids = module.networking.vpc_private_subnet_ids
  hosted_zone_id     = aws_route53_zone.sandbox.id
  service_dns_name   = "demo-svc.sandbox.i.gsoftcolombia.co"
  desired_count      = 1
  service_capacity_provider_strategy = {
    capacity_provider = module.ecs_cp_default.capacity_provider_name
    base              = 1
    weight            = 1
  }
}
resource "aws_security_group_rule" "dev-github-actions-service-ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1" # All protocols
  security_group_id        = module.ecs_cp_default.capacity_provider_security_group_id
  source_security_group_id = module.dev-github-actions-service.load_balancer_security_group_id
  description              = "Allow all traffic from Load Balancer of this service to the selected capacity provider"
}