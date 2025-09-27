variable "name_prefix" {
  description = "Prefix for all resources, this usually should go with the name of the project, this is used in combination with execution_name"
  type        = string
}
variable "environment" {
  description = "Task Environment"
  type        = string
}
variable "service_name" {
  description = "The suffix of majority of resources, you may want to run the same image, multiple times, set a name of this specific execution"
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "cluster_arn" {
  description = "ECS Cluster ARN"
  type        = string
}
variable "cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}
variable "ecr_repository" {
  description = "ECR Repo where the docker images are located"
  type        = string
}
variable "task_memory" {
  description = "Memory limit in MBs for this container task, considering that a scheduled task only use one container, the configuration is defined in the task level."
  type        = number
  default     = 10
}
variable "task_cpu" {
  description = "CPU limit for this container task, considering that a scheduled task only use one container, the configuration is defined in the task level."
  type        = number
  default     = 256
}
variable "task_command" {
  description = "The command to be executed in the container, it must be an array"
  type        = list(string)
  default     = [] # or [] for empty list
}
variable "container_definitions_secrets" {
  description = "Array of secrets for the container definition"
  type        = list(any)
  default     = []
}
variable "container_definitions_envvars" {
  description = "Array of envvars for the container definition"
  type        = list(any)
  default     = []
}
variable "public_subnet_ids" {
  description = "List of Subnet Ids where the task will be running."
  type        = list(string)
}
variable "private_subnet_ids" {
  description = "List of Subnet Ids where the task will be running."
  type        = list(string)
}
variable "service_health_check" {
  description = "Configuration for target group health check"
  type = object({
    path                = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
    matcher             = string
  })
  default = {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}
variable "service_capacity_provider_strategy" {
  description = "Capacity provider strategy definition"
  type = object({
    capacity_provider = string
    base              = number
    weight            = number
  })
  default = {
    capacity_provider = "general_1"
    base              = 1
    weight            = 1
  }
}

variable "service_port" {
  description = "Port used by the ELB for HTTPS, Container Image should use Port 80 but this will never be exposed."
  type        = number
  default     = 443
}

variable "expose_port_80" {
  description = "Determines whether the ELB will expose port 80 or not."
  type        = bool
  default     = false
}

variable "container_additional_iam_policy_arns" {
  description = "ARN of an additional IAM Policy to grant permissions to the service (e.g. Access to a specified S3 Bucket for storing reports)"
  type        = set(string)
  default     = []
}
variable "hosted_zone_id" {
  description = "Hosted Zone ID"
  type        = string
}
variable "service_dns_name" {
  description = "DNS for the WebApp Service"
  type        = string
}
variable "desired_count" {
  description = "Desired Count of Task Replicas"
  type        = number
  default     = 1
}