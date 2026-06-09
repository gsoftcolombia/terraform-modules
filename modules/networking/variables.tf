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
  description = "CIDR blocks for private subnets. Resources in private subnets have no direct internet access — they require a NAT Gateway to reach the internet (e.g., to pull ECR images or call AWS APIs). Enable enable_nat_gateway=true when using this. Leaving this as an empty list ([]) avoids creating private subnets altogether. If CIDRs are provided but enable_nat_gateway=false, resources in these subnets will have no outbound internet access."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway so that resources in private subnets can reach the internet. One NAT Gateway is created per AZ by default. Set to false when all workloads (ECS tasks, EC2 ASG) run in public subnets — this is the recommended cost-saving configuration. COST WARNING: each NAT Gateway costs ~$32/month in us-east-2 ($0.045/hr) plus $0.045/GB of data processed. At idle (no traffic), two NAT GWs across two AZs cost ~$64/month. Under typical ECS workloads with ECR pulls and AWS API calls, expect $70-90/month per environment. Only enable this if you have resources that must stay in private subnets (e.g., compliance requirements)."
  type        = bool
  default     = true
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