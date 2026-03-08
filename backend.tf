terraform {
  backend "s3" {
    bucket = "gsoft-sandbox-s3-tfstate-prod"
    key    = "apps/terraform.state"
    region = "us-east-2"
  }
}