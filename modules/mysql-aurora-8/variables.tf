variable "app_name" {
  description = "Name of the Aurora Cluster"
  type        = string
}

variable "backup_retention_period" {
  type = number
}
variable "cloudwatch_log_group_retention_in_days" {
  type    = number
  default = 14
}

variable "cluster_performance_insights_enabled" {
  type    = bool
  default = null
}
variable "cluster_performance_insights_retention_period" {
  type    = number
  default = null
}
variable "database_subnet_group_name" {
  type = string

}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}
variable "engine_mode" {
  type    = string
  default = "provisioned"
}
variable "engine_version" { type = string }
variable "environment" { type = string }
variable "instances" { type = any }
variable "performance_insights_enabled" {
  type    = bool
  default = false
}
variable "performance_insights_retention_period" {
  type    = number
  default = null
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "security_group_rules" {
  type = any
}
variable "vpc_id" { type = string }

variable "db_cluster_parameter_group_parameters" {
  type    = list(map(string))
  default = []
}

variable "db_parameter_group_parameters" {
  type    = list(map(string))
  default = []
}

