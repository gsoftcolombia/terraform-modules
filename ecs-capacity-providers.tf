module "ecs_cp_default" {
  source         = "./modules/ecs-capacity-provider"
  name_prefix    = local.name_prefix
  name           = "default"
  vpc_id         = module.networking.vpc_id
  vpc_subnet_ids = module.networking.vpc_private_subnet_ids
  instance_type  = "t3a.micro"
  autoscaling_config = {
    min_size         = 1
    max_size         = 2
    desired_capacity = 1
  }
  node_user_data = <<-EOT
      #!/bin/bash
      cd /tmp
      yum update -y
      yum install -y aws-cli
      yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      systemctl enable amazon-ssm-agent
      systemctl start amazon-ssm-agent
      cat <<'EOF' >> /etc/ecs/ecs.config
      ECS_CLUSTER=gs-sandbox-ecs-cluster
      ECS_LOGLEVEL=INFO
      ECS_ENABLE_TASK_IAM_ROLE=true
      EOF
    EOT
}
