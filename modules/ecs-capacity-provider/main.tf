resource "aws_ecs_capacity_provider" "this" {
  name = "${var.name_prefix}-${var.name}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0.0"

  name = "${var.name_prefix}-${var.name}-asg"

  min_size                  = var.autoscaling_config.min_size
  max_size                  = var.autoscaling_config.max_size
  desired_capacity          = var.autoscaling_config.desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.vpc_subnet_ids

  # Launch template
  launch_template_name        = "${var.name_prefix}-${var.name}-asg-lt"
  launch_template_description = "${var.name_prefix}-${var.name}-asg Launch template"
  update_default_version      = true

  image_id          = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  key_name          = var.key_pair_name != null ? var.key_pair_name : null
  instance_type     = var.instance_type
  ebs_optimized     = true
  enable_monitoring = var.enable_detailed_monitoring
  force_delete      = true

  create_iam_instance_profile = true
  iam_role_name               = "${var.name_prefix}-${var.name}-asg"
  iam_role_description        = "ECS role for ${var.name_prefix}-${var.name}-asg"

  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  user_data                       = base64encode(var.node_user_data)
  ignore_desired_capacity_changes = true

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # This will ensure imdsv2 is enabled and required, aws security best practices.
  # Hop limit is 2 (not 1) because containers reach IMDS through the docker bridge,
  # adding one extra network hop; with hop_limit=1 the token request/response can't
  # reach containers, causing 401 Unauthorized from the instance profile provider.
  # See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance-metadata-service.html
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  security_groups = [module.autoscaling_sg.security_group_id]

}

module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.2.0"

  name         = "${var.name_prefix}-sg"
  description  = "${var.name_prefix} Security Group"
  vpc_id       = var.vpc_id
  egress_rules = ["all-all"]
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}