variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "environment" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "node_user_data" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "vpc_id" {
  description = "VPC Id"
  type        = string
}
variable "vpc_subnet_ids" {
  description = "VPC Subnets for the ECS-ASG"
  type        = list(string)
}
variable "key_pair_name" {
  description = "Key Pair Name"
  type        = string
}