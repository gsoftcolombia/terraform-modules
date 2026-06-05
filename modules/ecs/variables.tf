variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable ECS Container Insights. Generates ~120 custom CloudWatch metrics (~$36/month). Disable to reduce costs."
  type        = bool
  default     = false
}