module "main_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.cidr_range

  azs                     = var.public_azs
  public_subnets          = var.public_subnets_values
  map_public_ip_on_launch = true
  create_igw              = true

}

resource "aws_key_pair" "this" {
  key_name   = var.key_pair_name
  public_key = var.key_pair_pkey
}