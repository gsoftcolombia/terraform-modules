resource "aws_security_group" "global" {
  name        = "${local.name_prefix}-global"
  description = "Global Security Group used for Scheduled Tasks and other global resources."
  vpc_id      = module.networking.vpc_id

}

# Egress rules required to interact with SSM and other resources.
resource "aws_vpc_security_group_egress_rule" "global_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.global.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "global_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.global.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}