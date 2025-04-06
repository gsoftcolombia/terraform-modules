data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
}