data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

data "external" "get_last_dev_version" {
  program = [
    "bash",
    "${path.module}/get_last_dev_version.sh",
    "${local.aws_region}",
    "${var.ecr_repository}",
    "${var.environment}"
  ]
}