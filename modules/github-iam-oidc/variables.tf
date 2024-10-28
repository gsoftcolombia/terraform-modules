# Refer to the README for information on obtaining the thumbprint.
# This is specified as a variable to allow it to be updated quickly if it is
# unexpectedly changed by GitHub.
# See: https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
variable "aws_region" {
  description = "aws region where we deploy this resources"
  type        = string
}
variable "github_thumbprint" {
  description = "GitHub OpenID TLS certificate thumbprint."
  type        = string
}
variable "environment" {
  description = "Environment literally, where is deployed and criticy"
  type        = string
}
variable "github_org" {
  description = "Github Organization"
  type        = string
}
variable "github_repositories" {
  type        = list(any)
  description = "List of repositories with the list of policies to attach on the respective role"
}