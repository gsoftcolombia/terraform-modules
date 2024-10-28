data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}
data "external" "get_last_dev_version" {
  program = [
    "bash",
    "${path.module}/get_last_dev_version.sh",
    "${var.aws_region}",
    "${var.ecr_repository}",
    "${var.app_env_target}"
  ]
}