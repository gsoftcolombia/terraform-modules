output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.this.name
}
output "capacity_provider_security_group_id" {
  value = module.autoscaling_sg.security_group_id
}
