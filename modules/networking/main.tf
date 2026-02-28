module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.cidr_range

  azs             = var.azs
  public_subnets  = var.public_subnets_values
  private_subnets = var.private_subnets_values

  enable_nat_gateway = true

  map_public_ip_on_launch = true
  create_igw              = true

}

resource "aws_key_pair" "this" {
  count      = var.key_pair_name != null && var.key_pair_name != "" ? 1 : 0
  key_name   = var.key_pair_name
  public_key = var.key_pair_pkey
}