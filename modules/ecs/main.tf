module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "~> 5.11.4"

  cluster_name = "${var.name_prefix}-cluster"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/cluster"
      }
    }
  }
  cloudwatch_log_group_name              = "/aws/ecs/cluster"
  cloudwatch_log_group_retention_in_days = 14

  # By default if there is no capacity provider specified,
  # it will use FARGATE, so no EC2 will be affected.
  default_capacity_provider_use_fargate = false # in false during tests

}