data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.0"

  for_each = var.ecr_repositories

  repository_name                   = module.ecr_names_label[each.key].id
  repository_image_tag_mutability   = each.value.image_tag_mutability
  repository_image_scan_on_push     = each.value.image_scanning
  repository_lifecycle_policy       = jsonencode(each.value.lifecycle_policy)
  repository_read_write_access_arns = each.value.read_write_access_arns

  tags = module.ecr_names_label[each.key].tags
}
module "ecr_names_label" {
  source  = "cloudposse/label/null"
  version = "~> 0.24.1"

  for_each = var.ecr_repositories

  namespace = "gs"
  stage     = "prod"
  name      = each.key
  delimiter = "-"

  tags = {
    terraform   = "true",
    environment = var.environment
  }
}