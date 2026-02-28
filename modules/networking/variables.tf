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
variable "cidr_range" {
  description = "value"
  type        = string
}
variable "azs" {
  description = "availability zones"
  type        = list(string)
}
variable "public_subnets_values" {
  description = "public subnets values literally"
  type        = list(string)
}
variable "private_subnets_values" {
  description = "private subnets values literally"
  type        = list(string)
}

variable "key_pair_name" {
  description = "(Optional) Key Pair Name"
  type        = string
  default     = null
}
variable "key_pair_pkey" {
  description = "(Optional) Public Key, if no key_pair_name is provided, this value will be ignored"
  type        = string
  default     = null
}