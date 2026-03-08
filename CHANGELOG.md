# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] – 2026-02-28

### Changed
- Made `module.networking.key_pair` optional (breaking change)
  - Before upgrading, run: `terraform state mv aws_key_pair.this aws_key_pair.this[0]` to update tfstate
- Made `module.ecs-capacity-provider.key_pair_name` optional.
- Made force_delete on the ASG for `module.ecs-capacity-provider`.
- Fix on `module.ecr` removed hardcoded prefix, using `name_prefix` instead.
  - Breaking change. Pending to test how to prevent issues.
- Refactor in `module.github-iam-oidc`, removed hardcoded prefix, using `name_prefix` instead.
  - Breaking change. Pending to test how to prevent issues.

### Security
- (any security fixes)
