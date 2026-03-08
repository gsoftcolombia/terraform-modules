variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "name" {
  description = "Capacity Provider Name"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "VPC Subnets for the ECS-ASG"
  type        = list(string)
}

variable "key_pair_name" {
  description = "Key Pair Name"
  type        = string
  default     = null
}
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3a.micro"
}
variable "node_user_data" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "autoscaling_config" {
  description = "Autoscaling Configuration, the autoscaling group will not spin more than max_size instances, and will not spin down less than min_size instances. Desired capacity is the number of instances that will be running at the moment of the creation of the ASG, and it will be used as a reference for scaling up or down."
  type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
  })
  default = {
    min_size         = 1
    max_size         = 2
    desired_capacity = 1
  }
}