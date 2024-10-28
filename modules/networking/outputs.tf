output "vpc_id" {
  value = module.main_vpc.vpc_id
}
output "vpc_public_subnet_ids" {
  value = module.main_vpc.public_subnets
}