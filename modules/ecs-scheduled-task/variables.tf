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
  default     = ""
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
  description = "Memory limit in MBs for this container task, considering that a scheduled task only use one container, the configuration is defined in the task level."
  type        = number
  default     = 10
}
variable "task_cpu" {
  description = "CPU limit for this container task, considering that a scheduled task only use one container, the configuration is defined in the task level."
  type        = number
  default     = 256
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
variable "alarm_error_count_threshold" {
  description = "Threshold for the Alarm of ErrorCount during container executions. This field is required if enable_alarms is true"
  type        = number
  default     = 1
}
variable "alarm_error_count_pattern" {
  description = "Pattern for Filtering Metrics on CW logs for the Alarm of ErrorCount during container executions. This field is required if enable_alarms is true"
  type        = string
  default     = "?error ?ERROR ?Error ?fail ?Fail ?FAIL"
}

variable "enable_schedule" {
  description = "This will configure the task in one schedule."
  type        = bool
  default     = true
}
variable "subnet_ids" {
  description = "List of Subnet Ids where the task will be running."
  type        = list(string)
}
variable "security_groups" {
  description = "List of Security Groups where the task will be running."
  type        = list(string)
}