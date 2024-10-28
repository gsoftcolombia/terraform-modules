variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "environment" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "aws_region" {
  description = "aws region where we deploy this resources"
  type        = string
}
variable "cluster_arn" {
  description = "ECS Cluster ARN"
  type        = string
}
variable "ecr_repository" {
  description = "Where the docker images are located"
  type        = string
}
variable "app_env_target" {
  description = "dev or prod are the two options"
  type        = string
}
variable "execution_name" {
  description = "You may want to run the same image, multiple times, set a name of this execution"
  type        = string
}
variable "schedule_expression" {
  description = "The schedule expression, it should be in the format \"cron(* * * * ? *)\""
  type        = string
}
variable "task_command" {
  description = "The command to be executed in the container, it must be an array"
  type        = list(string)
}
variable "container_definitions_secrets" {
  description = "Array of secrets for the container definition"
  type        = list(any)
  default     = []
}
variable "task_memory" {
  description = "Memory limit for this container task"
  type        = number
  default     = 10
}