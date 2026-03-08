variable "name_prefix" {
  description = "Prefix for all resources"
  type        = string
}
variable "aws_region" {
  description = "aws region where we deploy this resources"
  type        = string
}
variable "environment" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "ecr_repositories" {
  description = "List of ECR repositories to create"
  type        = map(any)
}