variable "name_prefix" {
  description = "Prefix for all resources, this usually should go with the name of the project, this is used in combination with execution_name"
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
  description = "The suffix of majority of resources, you may want to run the same image, multiple times, set a name of this specific execution"
  type        = string
}
variable "schedule_expression" {
  description = "The schedule expression, it should be in the format \"cron(* * * * ? *)\" This is not required if enable_schedule is set to false"
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
variable "enable_alarms" {
  description = "This will configure CloudWatch Alarms, using TF Module cloudtrail is a requirement."
  type        = bool
  default     = false
}
variable "alarms_notify_to_emails" {
  description = "List of emails who will receive notifications in case an Alarm is triggered. This field is required if enable_alarms is true"
  type        = list(string)
  default     = []
}

variable "enable_schedule" {
  description = "This will configure the task in one schedule."
  type        = bool
  default     = true
}