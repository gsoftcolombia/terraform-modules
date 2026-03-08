# module "ecs_services" {
#   for_each = local.services

#   source     = "./modules/ecs-service"
#   depends_on = [module.ecr-all]

#   name_prefix = local.name_prefix
#   environment = each.value.environment

#   service_name = each.value.service_name

#   vpc_id       = module.networking.vpc_id
#   cluster_arn  = module.ecs-cluster.ecs_cluster_arn
#   cluster_name = "${local.name_prefix}-ecs-cluster"

#   ecr_repository = each.value.ecr_repository

#   task_cpu    = each.value.task_cpu
#   task_memory = each.value.task_memory

#   public_subnet_ids  = module.networking.vpc_public_subnet_ids
#   private_subnet_ids = module.networking.vpc_private_subnet_ids

#   hosted_zone_id   = aws_route53_zone.sandbox.id
#   service_dns_name = each.value.service_dns_name

#   desired_count = each.value.desired_count

#   service_capacity_provider_strategy = {
#     capacity_provider = module.ecs_cp_default.capacity_provider_name
#     base              = 1
#     weight            = 1
#   }
# }
# resource "aws_security_group_rule" "service_ingress" {
#   for_each = local.services

#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"

#   security_group_id = module.ecs_cp_default.capacity_provider_security_group_id
#   source_security_group_id = module.ecs_services[each.key].load_balancer_security_group_id
#   description = "Allow all traffic from Load Balancer of ${each.key} to the capacity provider"
# }